package com.github.kr328.clash

import androidx.activity.result.contract.ActivityResultContracts
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.github.kr328.clash.common.log.Log
import com.github.kr328.clash.common.util.intent
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
import com.github.kr328.clash.core.model.TunnelState
import com.github.kr328.clash.design.NewProfileDesign
import com.github.kr328.clash.design.PreferenceLiveData
import com.github.kr328.clash.design.PreferenceManager
import com.github.kr328.clash.design.dialog.requestModelTextInput
import com.github.kr328.clash.design.util.ValidatorHttpUrl
import com.github.kr328.clash.service.ProfileManager
import com.github.kr328.clash.service.model.Profile
import com.github.kr328.clash.service.remote.IRemoteService
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch
import kotlinx.coroutines.selects.select
import kotlinx.coroutines.withContext
import java.util.*
import java.util.concurrent.TimeUnit

class MainActivity : BaseActivity<MainDesign>() {



    private val selectnodeName: LiveData<String> by lazy {
        PreferenceLiveData(this)
    }

    override suspend fun main() {
        val design = MainDesign(this)

        PreferenceManager.init(this)

        setContentDesign(design)

        design.fetch()
        design.startBannsers()

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
                            startActivity(NetworkSettingsActivity::class.intent)
                        MainDesign.Request.OpenSettingsKEFU ->
                            startActivity(HelpActivity::class.intent)

                        MainDesign.Request.OpenModeDirect ->
                            withClash {
                                val o = queryOverride(Clash.OverrideSlot.Session)
                                o.mode = TunnelState.Mode.Direct
                                patchOverride(Clash.OverrideSlot.Session, o)
                            }

                        MainDesign.Request.OpenModeGlobal ->  withClash {
                            withClash {
                                val o = queryOverride(Clash.OverrideSlot.Session)
                                o.mode = TunnelState.Mode.Global
                                patchOverride(Clash.OverrideSlot.Session, o)
                            }
                        }
                        MainDesign.Request.OpenModeRule ->  withClash {
                            withClash {
                                val o = queryOverride(Clash.OverrideSlot.Session)
                                o.mode = TunnelState.Mode.Direct
                                patchOverride(Clash.OverrideSlot.Session, o)
                            }
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
    }

    private suspend fun MainDesign.fetch() {
        setClashRunning(clashRunning)

        val state = withClash {
            queryTunnelState()
        }
        val providers = withClash {
            queryProviders()
        }
        android.util.Log.i("MainActivity","fetch Info: ${state.mode.name} ${providers.count()}")
        if (providers.isNotEmpty()) {
            providers.forEach { android.util.Log.i("MainActivity", "The element is ${it.name}") }
        }

        setMode(state.mode)
        setHasProviders(providers.isNotEmpty())

        withProfile {
            setProfileName(queryActive()?.name)

            setSelectNodeName(PreferenceManager.selectnodeName)

        }

    }

    private suspend fun MainDesign.fetchTraffic() {
        withClash {
            setForwarded(queryTrafficTotal())
        }
    }

    private suspend fun MainDesign.startClash() {

        withProfile {
            var allProfiles = queryAll()
            if (allProfiles.isNotEmpty() && allProfiles.count() > 1){
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

        if (activeProfile == null || !activeProfile.imported) {

            showToast("正在请求节点数据....", ToastDuration.Long) {

            }


            //create(Profile.Type.Url, "VPN")
            withProfile{
                val uuid: UUID = create(Profile.Type.Url,"VPN","https://api.0009.uk/api/v1/client/subscribe?token=5652e3eec20c553047dbe3fcf8754090")
                commit(uuid){
                    android.util.Log.i("commit",">> ${it.progress}  ${it.action}  ${it.args.toString()} ")
                    if (it.action == FetchStatus.Action.Verifying){
                        // 在协程中启动 activeProfile 调用
                        CoroutineScope(Dispatchers.IO).launch {
                            activeProfile()
                        }
                    }
                }
            }

        }else{
//            showToast(R.string.no_profile_selected, ToastDuration.Long) {
//                setAction(R.string.profiles) {
//                    startActivity(ProfilesActivity::class.intent)
//                }
//            }

            android.util.Log.i("activeProfile",">> ${activeProfile.type.name}  ${activeProfile.uuid} ${activeProfile.imported} ")

        }

        val vpnRequest = startClashService()

        try {
            if (vpnRequest != null) {
                val result = startActivityForResult(
                    ActivityResultContracts.StartActivityForResult(),
                    vpnRequest
                )

                if (result.resultCode == RESULT_OK)
                    startClashService()
            }
        } catch (e: Exception) {
            design?.showToast(R.string.unable_to_start_vpn, ToastDuration.Long)
        }
    }

    private suspend fun activeProfile(){
        withProfile {
            setActive(queryAll().first())
        }

    }
    private suspend fun queryAppVersionName(): String {
        return withContext(Dispatchers.IO) {
            packageManager.getPackageInfo(packageName, 0).versionName + "\n" + Bridge.nativeCoreVersion().replace("_", "-")

        }
    }
}