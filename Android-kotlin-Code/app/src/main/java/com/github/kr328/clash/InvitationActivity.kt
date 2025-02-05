package com.github.kr328.clash

import com.github.kr328.clash.common.util.intent
import com.github.kr328.clash.common.util.ticker
import com.github.kr328.clash.design.InvitationDesign
import com.github.kr328.clash.design.PreferenceManager
import com.github.kr328.clash.design.ProfileDesign
import kotlinx.coroutines.isActive
import kotlinx.coroutines.selects.select
import java.util.concurrent.TimeUnit

class InvitationActivity  : BaseActivity<InvitationDesign>()  {

    override suspend fun main() {

        PreferenceManager.init(this)


        val design = InvitationDesign(this)
        setContentDesign(design)
        design.requestdataDisible()
    }

}
