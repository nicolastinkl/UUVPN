package com.sail_tunnel.sail

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.VpnService
import android.os.BatteryManager
import android.os.Build
import android.os.Bundle
import android.util.Log
import com.sail_tunnel.sail.services.VpnState
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.util.GeneratedPluginRegister
import io.flutter.plugin.common.MethodChannel

import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.File

class MainActivity: FlutterActivity() {
    private val channel = "com.sail_tunnel.sail/vpn_manager"

    private fun getServiceIntent(): Intent {
        return Intent(this, TunnelService::class.java)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Core.init(this, MainActivity::class)

//        GeneratedPluginRegistrant.registerWith(FlutterEngine(this))
//        GeneratedPluginRegister.registerGeneratedPlugins(FlutterEngine(this));

//        MethodChannel(FlutterView(this), channel).setMethodCallHandler { call, result ->
//            if (call.method == "getBatteryLevel") {
//                val batteryLevel : Int = getBatteryLevel()
//
//                if (batteryLevel != -1) {
//                    result.success(batteryLevel)
//                } else {
//                    result.error("UNAVAILABLE", "Battery level not available.", null)
//                }
//            } else {
//                Log.e("user_debug", "getBatteryLevel is not method of called")
//                result.notImplemented()
//            }
//        }

    }
    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP){
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else  {
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        }
        return batteryLevel
    }

    override fun onResume() {
        super.onResume()


    }

    override fun onPause() {
        super.onPause()

    }

    private fun getVPNConnectionStatus(): Boolean? {
        val context = this@MainActivity
        val connectivityManager =
            context.getSystemService(CONNECTIVITY_SERVICE) as ConnectivityManager
        val networks = connectivityManager.allNetworks
        //val TAG = "getVPNConnectionStatus"
        //Log.i(TAG, "Network count: " + networks.size);
        var hasvpn = false
        for (i in 0 until networks.size) {
//            connectivityManager.getNetworkCapabilities()
            val caps: NetworkCapabilities? = connectivityManager.getNetworkCapabilities(networks.get(i))

            hasvpn = caps?.hasTransport(NetworkCapabilities.TRANSPORT_VPN) == true

//            Log.i(TAG, "Network " + i + ": " + networks.get(i).toString())
//            Log.i(TAG, "VPN transport is: " + caps?.hasTransport(NetworkCapabilities.TRANSPORT_VPN))
//            Log.i(TAG, "NOT_VPN capability is: " + caps?.hasCapability(NetworkCapabilities.NET_CAPABILITY_NOT_VPN) )
        }
    return hasvpn



//        val activeNetwork = connectivityManager.activeNetwork
//        val networkCapabilities = connectivityManager.getNetworkCapabilities(activeNetwork)
//
//        return networkCapabilities?.hasTransport(NetworkCapabilities.TRANSPORT_VPN)
    }

    override fun configureFlutterEngine( flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler {
            call, result ->
            // This method is invoked on the main thread.
            if (call.method == "getStatus") {
                result.success(getVPNConnectionStatus())
            } else if (call.method == "toggle") {
                val intent = VpnService.prepare(this)
                if (intent != null) {
                    startActivityForResult(intent, 0)
                    result.success(false)
                } else {
                    startService(getServiceIntent())
                    result.success(true)
                }
            } else if (call.method == "getTunnelLog") {
               // val context = Core.deviceStorage
               // val configRoot = context.noBackupFilesDir
               // val config = File(configRoot, VpnState.LEAF_LOG_FILE).readText()
               // result.success(config)
            } else if (call.method == "getTunnelConfiguration") {
                val context = Core.deviceStorage
                val configRoot = context.noBackupFilesDir
                val config = File(configRoot, VpnState.CONFIG_FILE).readText()
                val TAGs = "getVPNConnectionStatus"
                Log.i(TAGs, config);
                result.success(config)
            } else if (call.method == "setTunnelConfiguration") {
                try {
                    val context = Core.deviceStorage
                    val configRoot = context.noBackupFilesDir
                    val TAGs = "setTunnelConfiguration"
                    Log.i(TAGs, call.arguments.toString());
                    File(configRoot, VpnState.CONFIG_FILE).writeText(call.arguments.toString())
                }catch (e: Exception ){
                    println("setTunnelConfiguration FILE NullPointerException")
                }


            } else if (call.method == "update") {
                //
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onActivityResult(request: Int, result: Int, data: Intent?) {
        if (result == RESULT_OK) {
            startService(getServiceIntent())
        } else {
            super.onActivityResult(request, result, data)
        }
    }
}
