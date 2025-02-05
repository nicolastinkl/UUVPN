package com.github.kr328.clash

import android.content.Intent
import com.github.kr328.clash.design.H5WebViewDesign
import com.github.kr328.clash.design.PreferenceManager


class H5WebActivity : BaseActivity<H5WebViewDesign>() {
    override suspend fun main() {

        val design = H5WebViewDesign(this) {
            startActivity(Intent(Intent.ACTION_VIEW).setData(it))
            //Uri.parse(PreferenceManager.getConfigFromPreferences(this@ProfileActivity)?.telegramurl)
        }

        setContentDesign(design)

        val url = intent.getStringExtra("url")

        if (url != null && url.length > 1){
            title = url
            design.refereshApplyFrom()
            design.breaseURL(url)
        }else{

            PreferenceManager.getConfigFromPreferences(this@H5WebActivity)?.kefuurl?.let {
                design.breaseURL(
                    it
                )
            }
        }

//        while (isActive) {
//            events.receive()
//        }
    }
}