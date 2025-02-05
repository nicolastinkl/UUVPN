package com.github.kr328.clash

import com.github.kr328.clash.design.SubmitOrderViewDesign

class SubmitOrderActivity  : BaseActivity<SubmitOrderViewDesign>()  {

    override suspend fun main() {

        val design = SubmitOrderViewDesign(this)
        setContentDesign(design)

        //
        val trade_no = intent.getStringExtra("trade_no")
        design.fetchTradeInfo(trade_no)
    }
}