package com.github.kr328.clash

import android.app.Activity
import android.content.Intent
import com.github.kr328.clash.common.util.ticker
import com.github.kr328.clash.design.HelpDesign
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.isActive
import kotlinx.coroutines.selects.select
import kotlinx.coroutines.withContext
import java.util.concurrent.TimeUnit

class NewGongdanActivity : BaseActivity<HelpDesign>() {
    override suspend fun main() {
        val design = HelpDesign(this) {
            startActivity(Intent(Intent.ACTION_VIEW).setData(it))
        }

        setContentDesign(design)
//
//        while (isActive) {
//            events.receive()
//        }

        //val ticker = ticker(TimeUnit.SECONDS.toMillis(1))

        while (isActive) {
            select<Unit> {
                events.onReceive {
                    println("events  : " + it.name)
                }
                design.requests.onReceive {
                    println("requests  : " + it.name)
                    when (it) {
                        HelpDesign.Request.CommitSuccess -> {
                            withContext(Dispatchers.Main) {


                                val resultIntent = Intent()
                                resultIntent.putExtra("resultKey", "shuaxin")
                                setResult(Activity.RESULT_OK, resultIntent)
                                finish()

                            }
                        }
                    }
                }
            }
        }
    }
}