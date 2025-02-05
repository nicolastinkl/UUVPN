package com.github.kr328.clash

import android.os.Handler
import android.os.Looper
import android.util.Log
import com.github.kr328.clash.common.util.intent
import com.github.kr328.clash.core.Clash
import com.github.kr328.clash.core.model.Proxy
import com.github.kr328.clash.design.PreferenceManager
import com.github.kr328.clash.design.ProxyDesign
import com.github.kr328.clash.design.model.ProxyState
import com.github.kr328.clash.util.withClash
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch
import kotlinx.coroutines.selects.select
import kotlinx.coroutines.sync.Semaphore
import kotlinx.coroutines.sync.withPermit
import kotlinx.coroutines.withContext

class ProxyActivity : BaseActivity<ProxyDesign>() {
    override suspend fun main() {
        val mode = withClash { queryOverride(Clash.OverrideSlot.Session).mode }
        val names = withClash { queryProxyGroupNames(uiStore.proxyExcludeNotSelectable) }
        val states = List(names.size) { ProxyState("?") }
        val unorderedStates = names.indices.map { names[it] to states[it] }.toMap()
        val reloadLock = Semaphore(10)

        setTitle("选择节点")

        val design = ProxyDesign(
            this,
            mode,
            names,
            uiStore
        )

        setContentDesign(design)


        //刷新所以Groups
        //design.requests.send(ProxyDesign.Request.ReloadAll)

        design.requests.send(ProxyDesign.Request.Reload(0))

        while (isActive) {
            select<Unit> {
                events.onReceive {
                    when (it) {
                        Event.ProfileLoaded -> {
                            val newNames = withClash {
                                queryProxyGroupNames(uiStore.proxyExcludeNotSelectable)
                            }

                            if (newNames != names) {
                                startActivity(ProxyActivity::class.intent)

                                finish()
                            }
                        }
                        else -> Unit
                    }
                }
                design.requests.onReceive {
                    when (it) {
                        ProxyDesign.Request.ReLaunch -> {
                            startActivity(ProxyActivity::class.intent)

                            finish()
                        }
                        ProxyDesign.Request.ReloadAll -> {
                            names.indices.forEach { idx ->
                                design.requests.trySend(ProxyDesign.Request.Reload(idx))
                            }
                        }
                        is ProxyDesign.Request.Reload -> {
                            launch {
                                design.urlTesting = false
                                val group = reloadLock.withPermit {
                                    withClash {
                                        queryProxyGroup(names[it.index], uiStore.proxySort)
                                    }
                                }
                                var state = states[it.index]


                                println(">>>>>>>>>>>> ${names}")
                                println(">>>>>>>>>>>> ${it.index} group: "+group + "  ${group.type.name}  ${group.proxies.size}")

                                if (group.proxies.first().name == "GLOBAL"){
                                    println(">>>>>>>>>>>> GLOBAL ")
                                }

                                if (PreferenceManager.selectnodeName.length  > 0){
                                    state.now = PreferenceManager.selectnodeName //group.now
                                }else{
                                    state.now =  group.now
                                }

                                println(">>>>>>>>>>>>unorderedStates : ${unorderedStates}")
                                println(">>>>>>>>>>>> state: "+state)
                                //PreferenceManager.selectnodeName  =  state.now //刷新目前使用的节点名称
//                                >>>>>>>>>>>> state: ProxyState(now=?)
//                                >>>>>>>>>>>> 0 group: 距离下次重置剩余：18 天  Selector
//                                >>>>>>>>>>>>{代理=ProxyState(now=距离下次重置剩余：18 天), 电报=ProxyState(now=?), 油管=ProxyState(now=?), 奈飞=ProxyState(now=?), b站=ProxyState(now=?), 规则外路由选择=ProxyState(now=?)}


                                design.updateGroup(
                                    it.index,
                                    group.proxies,
                                    group.type == Proxy.Type.Selector,
                                    state,
                                    unorderedStates
                                )


                                design.finishreferesh()

                                /*val group = reloadLock.withPermit {
                                    withClash {
                                        queryProxyGroup(names[it.index], uiStore.proxySort)
                                    }
                                }
                                val state = states[it.index]

                                state.now = group.now

                                design.updateGroup(
                                    it.index,
                                    group.proxies,
                                    group.type == Proxy.Type.Selector,
                                    state,
                                    unorderedStates
                                ) */
                            }
                        }
                        is ProxyDesign.Request.Select -> {
                            withClash {
                                patchSelector(names[it.index], it.name)
                                states[it.index].now = it.name
                            }
                            PreferenceManager.selectnodeName = it.name
                            design.requestRedrawVisible()
                            launch {
                                finish()
                            }
                        }
                        is ProxyDesign.Request.UrlTest -> {
                            launch {
                                withClash {
                                    healthCheck(names[it.index])
                                }

                                design.requests.send(ProxyDesign.Request.Reload(it.index))
                            }
                        }
                        is ProxyDesign.Request.PatchMode -> {
                           // design.showModeSwitchTips()

                            withClash {
                                val o = queryOverride(Clash.OverrideSlot.Session)

                                o.mode = it.mode

                                patchOverride(Clash.OverrideSlot.Session, o)
                            }
                        }
                    }
                }
            }
        }


        // 使用协程延迟 500ms 后执行
      /*  GlobalScope.launch(Dispatchers.Main) {
            delay(1500) // 延迟 500ms

            launch {
                withClash {
                    healthCheck(names[0])
                }
                design.requests.send(ProxyDesign.Request.Reload(0))
            }

        }*/


    }
}