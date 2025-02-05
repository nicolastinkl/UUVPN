package com.github.kr328.clash

import com.github.kr328.clash.common.util.intent
import com.github.kr328.clash.common.util.ticker
import com.github.kr328.clash.design.ConfigOrderDesign
import com.github.kr328.clash.design.PreferenceManager
import com.github.kr328.clash.design.ProfileDesign
import com.github.kr328.clash.network.PlanData
import com.github.kr328.clash.utity.LoadingDialog
import kotlinx.coroutines.isActive
import kotlinx.coroutines.selects.select
import java.util.concurrent.TimeUnit

//ConfigOrderDesign

class ConfigOrderActivity : BaseActivity<ConfigOrderDesign>()  {

    override suspend fun main() {

        // 获取 Intent 并接收传递的 PlanData 对象
        // 使用 Parcelable 获取对象
        val planData = intent.getSerializableExtra("planData") as? PlanData

        val design = ConfigOrderDesign(this)
        setContentDesign(design)
        design.fillData(planData)

        val ticker = ticker(TimeUnit.SECONDS.toMillis(1))

        while (isActive) {
            select<Unit> {
                events.onReceive {
                    println("events  : " + it.name)
                }
                design.requests.onReceive {
                    println("requests  : " + it.name)
                    when (it) {
                        ConfigOrderDesign.Request.SubmitOrder -> {
                            startActivity(SubmitOrderActivity::class.intent.putExtra("trade_no",design.trade_no))
                        }
                    }
                }
            }
        }

    }
}