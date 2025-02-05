package com.github.kr328.clash

import android.os.Handler
import android.os.Looper
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.widget.PopupMenu
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.github.kr328.clash.common.log.Log
import com.github.kr328.clash.common.util.intent
import com.github.kr328.clash.common.util.setUUID
import com.github.kr328.clash.common.util.ticker
import com.github.kr328.clash.core.Clash
import com.github.kr328.clash.design.MainDesign
import com.github.kr328.clash.design.ui.ToastDuration
import com.github.kr328.clash.util.startClashService
import com.github.kr328.clash.util.stopClashService
import com.github.kr328.clash.util.withClash
import com.github.kr328.clash.util.withProfile
import com.github.kr328.clash.core.bridge.*
import com.github.kr328.clash.core.model.FetchStatus
import com.github.kr328.clash.core.model.ProxySort
import com.github.kr328.clash.core.model.TunnelState
import com.github.kr328.clash.design.NewProfileDesign
import com.github.kr328.clash.design.PreferenceLiveData
import com.github.kr328.clash.design.PreferenceManager
import com.github.kr328.clash.design.R
import com.github.kr328.clash.design.component.ProxyMenu
import com.github.kr328.clash.design.databinding.ActivitySplashBinding
import com.github.kr328.clash.design.dialog.requestModelTextInput
import com.github.kr328.clash.design.dialog.withModelProgressBar
import com.github.kr328.clash.design.network.APIGlobalObject
import com.github.kr328.clash.design.util.ValidatorHttpUrl
import com.github.kr328.clash.design.util.root
import com.github.kr328.clash.design.util.showCustomDialog
import com.github.kr328.clash.design.util.showExceptionToast
import com.github.kr328.clash.network.ApiClient
import com.github.kr328.clash.network.ApiClientConfig
import com.github.kr328.clash.network.ApiService
import com.github.kr328.clash.network.ConfigResponse
import com.github.kr328.clash.network.LoginRequest
import com.github.kr328.clash.network.SubscribeData
import com.github.kr328.clash.network.SubscribeResponse
import com.github.kr328.clash.network.safeApiCall
import com.github.kr328.clash.network.safeApiRequestCall
import com.github.kr328.clash.service.ProfileManager
import com.github.kr328.clash.service.model.Profile
import com.github.kr328.clash.service.remote.IRemoteService
import com.github.kr328.clash.service.util.PreferenceManagerServer
import com.github.kr328.clash.utity.LoadingDialog
import com.google.gson.Gson
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch
import kotlinx.coroutines.selects.select
import kotlinx.coroutines.withContext
import java.util.*
import java.util.concurrent.TimeUnit
import kotlin.concurrent.timer

class MainActivity : BaseActivity<MainDesign>() {


    private lateinit var apiService: ApiService
    private  var  subData: SubscribeData? = null



    private val selectnodeName: LiveData<String> by lazy {
        PreferenceLiveData(this)
    }

    override suspend fun main() {
        val design = MainDesign(this)

        if (PreferenceManager.isLoginin){
            setContentDesign(design)

            design.fetch()
            design.startBannsers()


            //1 : 查询 config 信息

            apiService = ApiClientConfig.retrofit.create(ApiService::class.java)

            //获取 Config 数据
//        CoroutineScope(Dispatchers.IO).launch {   }



            val currentTime = System.currentTimeMillis()
            val cacheExpiryTime = 10 * 60 * 1000 // 10 minutes in milliseconds


// 如果缓存数据存在且未超过 10 分钟，使用缓存数据；否则，重新请求数据
            if (  PreferenceManager.cached_data != null && (currentTime - PreferenceManager.cache_timestamp) <= cacheExpiryTime)  {
                // 使用缓存数据
                val gson = Gson()
                val configResponse =  gson.fromJson(PreferenceManager.cached_data, ConfigResponse::class.java)
                println(configResponse)
                println("Using cached data: ${PreferenceManager.cached_data}")
                println("Using cached_userSubscritedata  : ${PreferenceManager.cached_userSubscritedata}")
                if (PreferenceManager.cached_userSubscritedata.length > 0){
                    val subcache =  gson.fromJson(PreferenceManager.cached_userSubscritedata, SubscribeResponse::class.java)
                    subData =  subcache.data

                    //存储到本地
                    val plainid = subcache.data.plan_id ?: 0
//                    或者检查使用量
                    val guoqi = (subcache.data.u ) +  (subcache.data.d) >  (subcache.data.transfer_enable ?: 0) && (subcache.data.transfer_enable ?: 0) > 0
                    if ( plainid == 0 || guoqi ) {
                        //提示到期
                        //删除所有节点
                        withProfile {
                            var allProfiles = queryAll()
                            println(allProfiles)
                            //删除所有节点
                            if (allProfiles.isNotEmpty() && allProfiles.count() > 0){
                                allProfiles.forEach {
                                    delete(it.uuid)
                                    println("Deleted ${it.uuid} ${it.name}: ${it.source}")
                                }
                            }

                        }

                        //删除所有节点文件

                        withContext(Dispatchers.Main) {
                            showCustomDialog(
                                title = "提示",
                                message = "您的订阅已到期，请续费订阅开启服务",
                                positiveButtonText = "确定",
                                negativeButtonText = "取消",
                                onPositiveClick = {
                                    // 执行确认操作
                                    startActivity(PlansActivity::class.intent)
                                },
                                onNegativeClick = {
                                    // 执行取消操作
                                }
                            )
                        }

                    }

                }

                println("subData ： ${subData}")



            }else{
                // 缓存已过期，重新请求数据
                println("Cache expired, requesting new data")
                // 重新请求数据
                //requestNewData()
                LoadingDialog.show(this, "正在更新节点数据...")
                configRequesting()

            }




            selectnodeName.observe(this, androidx.lifecycle.Observer { newValue ->
            })

            val ticker = ticker(TimeUnit.SECONDS.toMillis(1))

            while (isActive) {
                select<Unit> {
                    events.onReceive {
                        when (it) {
                            Event.ActivityStart,
                            Event.ServiceRecreated,
                            Event.ClashStop, Event.ClashStart,
                            Event.ProfileLoaded, Event.ProfileChanged -> design.fetch()
                            else -> Unit
                        }
                    }
                    design.requests.onReceive {
                        when (it) {
                            MainDesign.Request.ToggleStatus -> {
                                if (clashRunning)
                                    stopClashService()
                                else
                                    design.startClash()
                            }
                            MainDesign.Request.OpenProxy ->
                                startActivity(ProxyActivity::class.intent)

                            MainDesign.Request.OpenProfiles ->
                                startActivity(ProfilesActivity::class.intent)
                            MainDesign.Request.OpenProviders ->
                                startActivity(ProvidersActivity::class.intent)
                            MainDesign.Request.OpenLogs ->
                                startActivity(LogsActivity::class.intent)
                            MainDesign.Request.OpenSettings ->
                                startActivity(SettingsActivity::class.intent)
                            MainDesign.Request.OpenHelp ->
                                startActivity(HelpActivity::class.intent)
                            MainDesign.Request.OpenAbout ->
                                design.showAbout(queryAppVersionName())
                            MainDesign.Request.OpenSettingsDIY ->
                                startActivity(ProfileActivity::class.intent)
                            MainDesign.Request.OpenSettingsKEFU ->
                                startActivity(PlansActivity::class.intent)

                            MainDesign.Request.OpenModeDirect ->

                                 withClash {
                                    PreferenceManager.modeName =  TunnelState.Mode.Direct.name
                                    val override = queryOverride(Clash.OverrideSlot.Session)
                                     override.mode = TunnelState.Mode.Direct
                                    patchOverride(Clash.OverrideSlot.Session, override)

                                }

                            MainDesign.Request.OpenModeGlobal ->  withClash {
                                CoroutineScope(Dispatchers.Main).launch {
                                    PreferenceManager.modeName =  TunnelState.Mode.Global.name
                                    LoadingDialog.show(this@MainActivity, "正在切换中...")

                                    val names = withClash { queryProxyGroupNames(uiStore.proxyExcludeNotSelectable) }

                                    withClash {
                                        val o = queryOverride(Clash.OverrideSlot.Session)
                                        o.mode = TunnelState.Mode.Global
                                        patchOverride(Clash.OverrideSlot.Session, o)


                                    }
                                    startServer()

                                }
                            }
                            MainDesign.Request.OpenModeRule ->  withClash {

                                CoroutineScope(Dispatchers.Main).launch {
                                    PreferenceManager.modeName =  TunnelState.Mode.Rule.name
                                    LoadingDialog.show(this@MainActivity, "正在切换中...")
                                        withClash {
                                            val o = queryOverride(Clash.OverrideSlot.Session)
                                            o.mode = TunnelState.Mode.Rule
                                            patchOverride(Clash.OverrideSlot.Session, o)

                                        }
                                    startServer()

                                }
                            }


                            MainDesign.Request.OpenModeMenu -> {
                                design.OpenModeMenu()
                            }

                            MainDesign.Request.OpenChangeMode -> {
                                design.OpenModeMenu()
                            }

                            MainDesign.Request.OpenModeSheet ->{
                                design.OpenModeSheet()
                            }
                        }
                    }
                    if (clashRunning) {
                        ticker.onReceive {
                            design.fetchTraffic()
                        }
                    }
                }
            }



        }else{
            val binding = ActivitySplashBinding
                .inflate(this.layoutInflater, this.root, false)

            setContentView(binding.root)

            Handler(Looper.getMainLooper()).postDelayed({
                startActivity(LoginActivity::class.intent)

            }, 1000) // Simulating a network delay
        }

    }

    private suspend fun configRequesting(){
        val gson = Gson()
        val currentTime = System.currentTimeMillis()
        /*apiService.getConfig().let {
            if (it.isSuccessful) {
                val response: ConfigResponse = it.body()  ?: throw Exception("Response body is null")

                if (response.code == 1 ) {
                    PreferenceManager.saveConfigToPreferences(response)
                    //更新缓存数据
                    PreferenceManager.cache_timestamp = currentTime
                    PreferenceManager.cached_data =  gson.toJson( it.body())
                    println("API Response:  ${gson.toJson( it.body())}")
                    //重新初始化 ApiClint
                    //2 : 获取订阅节点信息
                    performSubscrite()
                }

            } else {
                println("API Error: ${it.errorBody()}")
                configRequesting()
            }


        }
         */

        safeApiCall {apiService.getConfig()}.let {
            if (it !=null){
                if (it.code == 1 ) {
                    PreferenceManager.saveConfigToPreferences(it)
                    //更新缓存数据
                    PreferenceManager.cache_timestamp = currentTime
                    PreferenceManager.cached_data =  gson.toJson( it)
                    println("API Response:  ${it}")
                    //重新初始化 ApiClint
                    //2 : 获取订阅节点信息
                    performSubscrite()
                }
            }else{
                configRequesting()
            }

        }
    }

    private fun performSubscrite(){


        val apiServiceApp = ApiClient.retrofit.create(ApiService::class.java)

        //获取 Config 数据
        CoroutineScope(Dispatchers.IO).launch {
            safeApiRequestCall {
                apiServiceApp.getSubscribe(PreferenceManager.loginauthData)}.let {
                withContext(Dispatchers.Main) {
                    LoadingDialog.hide()
                }
                if (it != null &&
                    it.isSuccessful) {
                    println(" performSubscrite : ${it.body()?.data}")
                    subData = it.body()?.data

                    val gson = Gson()
                    PreferenceManager.cached_userSubscritedata =  gson.toJson( it.body())
                    APIGlobalObject.subData =  it.body()?.data
                    //存储到本地
                    val plainid = it.body()?.data?.plan_id ?: 0
//                    或者检查使用量
                    val guoqi = (it.body()?.data?.u ?: 0) +  (it.body()?.data?.d ?: 0) >  (it.body()?.data?.transfer_enable ?: 0) && (it.body()?.data?.transfer_enable ?: 0) > 0
                    if ( plainid == 0 || guoqi ) {
                        //提示到期
                        //删除所有节点
                        withProfile {
                            var allProfiles = queryAll()
                            println(allProfiles)
                            if (allProfiles.isNotEmpty() && allProfiles.count() > 1){
                                allProfiles.forEach { delete(it.uuid) }
                               //删除所有节点
                            }
                        }

                        //删除所有节点文件

                        withContext(Dispatchers.Main) {
                            showCustomDialog(
                                title = "提示",
                                message = "您的订阅已到期，请续费订阅开启服务",
                                positiveButtonText = "确定",
                                negativeButtonText = "取消",
                                onPositiveClick = {
                                    // 执行确认操作
                                    startActivity(PlansActivity::class.intent)
                                },
                                onNegativeClick = {
                                    // 执行取消操作
                                }
                            )
                        }

                    }else{
                        //更新本地节点
                        withProfile {
                            var profileActive = queryActive()
                            if (profileActive != null){
                                try {
                                    println(">>>>>>>>> 更新节点订阅地址：${profileActive.uuid}  ${profileActive.source}")
                                    update(profileActive.uuid)
                                }catch (e: Exception){
                                    println(">>>>>>>>> 更新节点订阅地址 catch：${e.message}")
                                }
                                finally {
                                    println(">>>>>>>>> 更新节点订阅地址 完成 finally")
                                }
                            }

                        }
                    }
                }
            }
        }
    }


    private suspend fun MainDesign.fetch() {
        setClashRunning(clashRunning)

        val state = withClash {
            queryTunnelState()
        }

        println("运行时查询系统mode模式： ${state}")

        val providers = withClash {
            queryProviders()
        }

        if (providers.isNotEmpty()) {
            println("模式providers： ${providers}")
            providers.forEach { println("The element is ${it.name}") }
        }

        setMode(state.mode)
        setHasProviders(providers.isNotEmpty())

        withProfile {
            setProfileName(queryActive()?.name)
            setSelectNodeName(PreferenceManager.selectnodeName )
        }
    }

    //查询上传速度和下载速度
    private suspend fun MainDesign.fetchTraffic() {
        withClash {

//            setForwarded(queryTrafficTotal())

            setUploadedSeep(queryTrafficTotal())
            setDownloadedSeep(queryTrafficTotal())
        }
    }

    private suspend fun MainDesign.startClash() {

        //删除所有节点
        withProfile {
            var allProfiles = queryAll()
            if (allProfiles.isNotEmpty() && allProfiles.count() > 1){ //删除超过多余的 1 个节点之外的节点
                allProfiles.forEach { delete(it.uuid) }
               //删除所有节点
            }
        }


//        val activeProfile = withProfile { queryActive() }
//        if (activeProfile != null) {
//            android.util.Log.i("activeProfile",">> ${activeProfile.type.name}  ${activeProfile.uuid} ${activeProfile.source} ")
//            showToast(R.string.no_profile_selected, ToastDuration.Long) {
//                setAction(R.string.profiles) {
//                    startActivity(ProfilesActivity::class.intent)
//                }
//            }

//        }
        val activeProfile = withProfile { queryActive() }
        println("当前订阅文件：${activeProfile}")
        if (activeProfile == null ) { //|| !activeProfile.imported

            LoadingDialog.show(this@MainActivity, "正在请求节点数据...")

           // showToast("正在请求节点数据....", ToastDuration.Long)

            //create(Profile.Type.Url, "VPN")
            withProfile{
                println(">>>>>>>>>${subData}")
                //https://hongxingdl.com/hxvip?token=bc2f2839ccc608f34d6a6fc90b6e7f15
                //https://hongxingdl.com/api/v1/client/subscribe?token=bc2f2839ccc608f34d6a6fc90b6e7f15
                //"https://api.0009.uk/api/v1/client/subscribe?token=5652e3eec20c553047dbe3fcf8754090"
                if (subData?.subscribe_url != null && subData?.plan?.name != null  && subData?.plan?.id != null) {
                    var suburl = subData?.subscribe_url ?: ""
                    var encodeURL = java.net.URLEncoder.encode(suburl, "utf-8")
                    encodeURL =  encodeURL.replace("?","%3F")
                    var newULR =suburl

                    println(">>>>>>>>> "+suburl)
                    if( ApiClientConfig.ConfigNodeURL.length > 3){
                        newULR = ApiClientConfig.ConfigNodeURL + encodeURL
                    }

                    println(">>>>>>>>> "+newULR)

                    //val uuid: UUID = create(Profile.Type.Url,subData?.plan?.name ?: "VPN",newULR)

                    launch {
                        val uuid2 = withProfile {
                            val type = Profile.Type.Url
                            val name = subData?.plan?.name ?: "VPN"

                            create(type, name).also {
                                patch(it, name, newULR, 0)
                            }
                        }

                        withProcessing { updateStatus ->
                            withProfile {

                               try {
                                   commit(uuid2) {

                                       launch {
                                           activeProfile()
                                           updateStatus(it)
                                       }
                                   }
                               } catch (e: Exception) {
                                   LoadingDialog.hide()
                                   showExceptionToast("初始化节点数据失败，请检查网络重试")

                               }
                                coroutineScope {
                                }
                            }
                        }

                       /* coroutineScope {
                            commit(uuid2) {
                                println(">>>>>>>>>> ${it.progress}  ${it.action}  ${it.args.toString()} ${it} ")
                                if (it.action == FetchStatus.Action.Verifying){
                                    // 在协程中启动 activeProfile 调用

                                    CoroutineScope(Dispatchers.IO).launch {
                                        activeProfile()
                                        //自动开启订阅
                                        startServer()
                                    }
                                }
                            }
                        }*/


                    }




                    /* commit(uuid){
                       println(">> ${it.progress}  ${it.action}  ${it.args.toString()} ")
                        if (it.action == FetchStatus.Action.Verifying){
                            // 在协程中启动 activeProfile 调用
                            CoroutineScope(Dispatchers.IO).launch {
                                activeProfile()
                                //自动开启订阅
                                startServer()
                            }
                        }
                    }*/
                }else{
                    //重新请求网络
                    performSubscrite()
                }

/*
                if (subData == null){
                    withContext(Dispatchers.Main){
                        LoadingDialog.hide()
                    }
                    performSubscrite()
                }else{

                    val plainid =subData?.plan_id  ?: 0
//                    或者检查使用量
                    val guoqi = (subData?.u ?: 0) +  (subData?.d ?: 0) >  (subData?.transfer_enable ?: 0) && (subData?.transfer_enable ?: 0) > 0
                    if ( plainid == 0 || guoqi ) {
                        //提示到期
                        performSubscrite()
                    }
                }

 */



            }

        }else{
//            showToast(R.string.no_profile_selected, ToastDuration.Long) {
//                setAction(R.string.profiles) {
//                    startActivity(ProfilesActivity::class.intent)
//                }
//            }

            println("当前订阅文件>> ${activeProfile.type.name}  ${activeProfile.uuid} ${activeProfile.imported} ")
            withProfile {
                activeProfile.uuid
            }
            startServer()
        }


    }


    suspend fun withProcessing(executeTask: suspend (suspend (FetchStatus) -> Unit) -> Unit) {
        try {


            executeTask {
                    // applyFrom(it)
                    println("applyFrom ${it.progress}  ${it}")
                if (it.action == FetchStatus.Action.Verifying) {
                    //验证通过
                    CoroutineScope(Dispatchers.IO).launch {
                        //选中节点
                        activeProfile()
                        //自动开启订阅
                        startServer()
                    }
                }else{
                    //请求中

                }
            }
        } finally {

        }
    }

    private  suspend fun startServer(){

        //读取配置文件


        val vpnRequest = startClashService()

        try {
            if (vpnRequest != null) {
                val result = startActivityForResult(
                    ActivityResultContracts.StartActivityForResult(),
                    vpnRequest
                )

                if (result.resultCode == RESULT_OK)
                {
                    startClashService()
                    withContext(Dispatchers.Main){
                        LoadingDialog.hide()
                    }
                }



            }

            println("缓存配置模式：${PreferenceManager.modeName}")
            CoroutineScope(Dispatchers.Main).launch {
                // Delay for 3 seconds
                //第一次全部使用全局模式连接

                delay(500)
                withClash {
                    // Query the current mode
                    val override = queryOverride(Clash.OverrideSlot.Session)

                    // Toggle between Rule and Global modes
                    if (PreferenceManager.modeName == TunnelState.Mode.Global.name){
                        override.mode = TunnelState.Mode.Global
                    }else{
                        override.mode = TunnelState.Mode.Rule //第一次默认使用智能 模式连接
                    }
                    // Apply the new mode`
                    patchOverride(Clash.OverrideSlot.Session, override)
                    //模式切换完毕
                    // Optional: Log or display the current mode for verification
                    println("模式切换 Clash mode is now set to: ${override.mode}")

                    delay(500)
                    //如果切换全局模式，默认 直接主动选择节点 根据缓存来
                    //if (override.mode == TunnelState.Mode.Global){
                        val names =  queryProxyGroupNames(uiStore.proxyExcludeNotSelectable)
                        println("模式切换>>>>>>>>>>>>>"+names)
                        if ( names.size > 0){
                            var progxys  = queryProxyGroup(names[0], ProxySort.Default)

                            if (progxys.proxies.first().title.length > 0){


                                println("模式切换>>>>>>>>>>>>>: "+progxys.proxies.last())
                                if ( progxys.proxies.size > 2)
                                {

                                    val zutuolist = progxys.proxies.filter {  it.title == "自动选择" }
                                    var  autoNode = ""
                                    if (PreferenceManager.selectnodeName.length > 0){
                                        autoNode = PreferenceManager.selectnodeName

                                    }  else{
                                        if (zutuolist.size > 0){
                                            //说明存在自动选择
                                            autoNode = "自动选择"
                                        }else{
                                            autoNode = progxys.proxies.first().title
                                        }
                                        PreferenceManager.selectnodeName  = autoNode   // progxys.proxies.last().title
                                    }


                                    patchSelector(names.first(),autoNode) // progxys.proxies.last().title

                                    withContext(Dispatchers.Main){
                                        design?.setSelectNodeName(PreferenceManager.selectnodeName)
                                    }
                                }

                            }

                        }

                   // }


                    withContext(Dispatchers.Main){
                        LoadingDialog.hide()
                    }
                }

            }



        } catch (e: Exception) {
            withContext(Dispatchers.Main){
                LoadingDialog.hide()
            }
            //design?.showToast(R.string.unable_to_start_vpn, ToastDuration.Long)
        }


    }


    private suspend fun activeProfile(){
        withProfile {
            setActive(queryAll().first())
        }

    }
    private suspend fun queryAppVersionName(): String {
        return withContext(Dispatchers.IO) {
            packageManager.getPackageInfo(packageName, 0).versionName// + "\n" + Bridge.nativeCoreVersion().replace("_", "-")

        }
    }
}