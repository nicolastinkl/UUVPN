package com.sail_tunnel.sail

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.media.projection.MediaProjection
import android.media.projection.MediaProjectionManager
import android.net.*
import android.os.Build
import android.os.ParcelFileDescriptor
import androidx.core.app.NotificationCompat
import com.sail_tunnel.sail.net.DefaultNetworkListener
import com.sail_tunnel.sail.net.DnsResolverCompat
import com.sail_tunnel.sail.services.LocalDnsWorker
import com.sail_tunnel.sail.services.TunnelInstance
import com.sail_tunnel.sail.services.VpnState
import com.sail_tunnel.sail.utils.readableMessage
import kotlinx.coroutines.*
import java.io.File
import java.io.IOException

class TunnelService : VpnService() {
    companion object {
        private const val CORE_NAME = "leaf"
        private const val VPN_MTU = 1500
        private const val PRIVATE_VLAN4_CLIENT = "198.18.20.20"
        private const val PRIVATE_VLAN4_ROUTER = "1.1.1.1"
    }

    inner class NullConnectionException : NullPointerException() {
        override fun getLocalizedMessage() =
            "Failed to start VPN service. You might need to reboot your device."
    }

    private val data = VpnState.Data()

    private fun startRunner() {

        if (Build.VERSION.SDK_INT >= 26) startForegroundService(Intent(this, javaClass))
        else startService(Intent(this, javaClass))
    }

    private var pfd: ParcelFileDescriptor? = null
    private var active = false
    private var metered = false


    var notification: Notification? = null
    private val mResultData: Intent? = null
    private val mMediaProjection: MediaProjection? = null
    private val mMediaProjectionManager: MediaProjectionManager? = null


    @Volatile
    private var underlyingNetwork: Network? = null
        set(value) {
            field = value
            if (active) setUnderlyingNetworks(underlyingNetworks)
        }
    private val underlyingNetworks
        get() =
            // clearing underlyingNetworks makes Android 9 consider the network to be metered
            if (Build.VERSION.SDK_INT == 28 && metered) null else underlyingNetwork?.let {
                arrayOf(
                    it
                )
            }

    override fun onRevoke() = stopRunner()

    private fun killProcesses(scope: CoroutineScope) {
        data.proxy?.run {
            shutdown(scope)
            data.proxy = null
        }
        data.localDns?.shutdown(scope)
        data.localDns = null

        active = false
        scope.launch { DefaultNetworkListener.stop(this) }
        pfd?.close()
        pfd = null
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val data = data
        if (data.state != VpnState.State.Stopped) return Service.START_NOT_STICKY

        try {
            data.proxy = TunnelInstance()
        } catch (e: IllegalArgumentException) {
            stopRunner(false, e.message)
            return Service.START_NOT_STICKY
        }
        createNotificationChannel()
        data.changeState(VpnState.State.Connecting)
        data.connectingJob = GlobalScope.launch(Dispatchers.Main) {
            try {
                preInit()

                startVpn()

                data.changeState(VpnState.State.Connected)
            } catch (_: CancellationException) {
                // if the job was cancelled, it is canceller's responsibility to call stopRunner
            } catch (exc: Throwable) {
                stopRunner(false, exc.readableMessage)
            } finally {
                data.connectingJob = null
            }
        }

        return START_NOT_STICKY
    }


    private fun createNotificationChannel() {
        val CHANNEL_ID: String = "notification_id"
        val builder = NotificationCompat.Builder(this.applicationContext,CHANNEL_ID) //获取一个Notification构造器
        val nfIntent = Intent(this, MainActivity::class.java) //点击后跳转的界面，可以设置跳转数据
        val pendingIntent: PendingIntent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            PendingIntent.getActivity(this, 0, nfIntent, PendingIntent.FLAG_IMMUTABLE)
        } else {
            PendingIntent.getActivity(this, 0, nfIntent, PendingIntent.FLAG_ONE_SHOT)
        }

        val intentClick = Intent(
            this,MainActivity::class.java
//            BroadcastReceiver::class.java
        )


        intentClick.action = "notification_clicked"
//        intentClick.putExtra(BroadcastReceiver.TYPE, type)
        val pendingIntentClick =
            PendingIntent.getBroadcast(this, 0, intentClick, PendingIntent.FLAG_ONE_SHOT)


        //.setContentIntent(pendingIntent) // 设置PendingIntent
        builder.setContentIntent(pendingIntentClick).setLargeIcon(
            BitmapFactory.decodeResource(
                this.resources,
                R.mipmap.app_icon_round
            )
        ) // 设置下拉列表中的图标(大图标)
            .setContentTitle("UUVPN") // 设置下拉列表里的标题
            .setSmallIcon( R.mipmap.app_icon_round) // 设置状态栏内的小图标
            .setContentText("正在运行...") // 设置上下文内容
            .setWhen(System.currentTimeMillis()) // 设置该通知发生的时间

        /*以下是对Android 8.0的适配*/
        //普通notification适配
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            builder.setChannelId("notification_id")
        }


        //前台服务notification适配
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

            val channel = NotificationChannel(
                "notification_id",
                "notification_name",
                NotificationManager.IMPORTANCE_LOW
            )


            // Register the channel with the system
            val notificationManager: NotificationManager =
                getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)

        }

        notification = builder.build() // 获取构建好的Notification
//        notification.defaulte = Notification.DEFAULT_SOUND //设置为默认的声音
        try {
            startForeground(110, notification)
        } catch (w: Exception) {
            w.printStackTrace()
        }
    }
    private suspend fun preInit() = DefaultNetworkListener.start(this) { underlyingNetwork = it }
    private suspend fun rawResolver(query: ByteArray) =
    // no need to listen for network here as this is only used for forwarding local DNS queries.
        // retries should be attempted by client.
        DnsResolverCompat.resolveRaw(underlyingNetwork ?: throw IOException("no network"), query)

    private suspend fun startVpn() {
        val builder = Builder()
            .setConfigureIntent(Core.configureIntent(this))
            .setSession(CORE_NAME)
            .setMtu(VPN_MTU)
            .addAddress(PRIVATE_VLAN4_CLIENT, 24)
            .addDnsServer(PRIVATE_VLAN4_ROUTER)
            .addRoute("0.0.0.0", 0)

        active = true   // possible race condition here?
        builder.setUnderlyingNetworks(underlyingNetworks)
        if (Build.VERSION.SDK_INT >= 29) builder.setMetered(metered)

        this.pfd = builder.establish() ?: throw NullConnectionException()

        val context = Core.deviceStorage
        val configRoot = context.noBackupFilesDir

        data.localDns = LocalDnsWorker(this::rawResolver).apply { start() }

        val configFile = File(configRoot, VpnState.CONFIG_FILE)
        val configContent = configFile
            .readText()
            .replace("{{leafLogFile}}", File(configRoot, VpnState.LEAF_LOG_FILE).absolutePath)
            .replace("{{tunFd}}", this.pfd?.fd?.toLong().toString())

        configFile.writeText(configContent)

        data.proxy!!.start(
            this,
            File(Core.deviceStorage.noBackupFilesDir, "stat_main"),
            configFile,
        )

    }

    private fun stopRunner(restart: Boolean = false, msg: String? = null) {
        if (data.state == VpnState.State.Stopping) return
        // channge the state
        data.changeState(VpnState.State.Stopping)
        GlobalScope.launch(Dispatchers.Main.immediate) {
            data.connectingJob?.cancelAndJoin() // ensure stop connecting first
            // we use a coroutineScope here to allow clean-up in parallel
            coroutineScope {
                killProcesses(GlobalScope)
            }

            // change the state
            data.changeState(VpnState.State.Stopped, msg)

            // stop the service if nothing has bound to it
            if (restart) startRunner() else {
                stopSelf()
            }
        }
    }
}
