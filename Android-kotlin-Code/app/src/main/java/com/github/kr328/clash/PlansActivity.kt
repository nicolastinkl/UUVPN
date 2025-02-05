package com.github.kr328.clash

import android.content.Intent
import android.widget.Toast
import androidx.recyclerview.widget.RecyclerView
import com.github.kr328.clash.common.util.intent
import com.github.kr328.clash.design.BaseListActivity
import com.github.kr328.clash.design.PreferenceManager
import com.github.kr328.clash.design.adapter.PlanDataAdapter
import com.github.kr328.clash.design.view.ActivityBarLayout

import com.github.kr328.clash.network.ApiClient
import com.github.kr328.clash.network.ApiService
import com.github.kr328.clash.network.PlanData
import com.github.kr328.clash.network.safeApiRequestCall

class PlansActivity : BaseListActivity<PlanData>() {

    override fun createAdapter(): RecyclerView.Adapter<*> {
        return PlanDataAdapter(){ planData ->
            // 在这里处理 item 点击事件
            val intent = Intent(this, ConfigOrderActivity::class.java)
            intent.putExtra("planData", planData) // 使用 Serializable 传递对象
            startActivity(intent)
        }
    }

    override fun onCreate() {
        //
        setRightButtonVisible {
            startActivity(MyOrdersActivity::class.intent)
        }
    }


    override suspend fun loadData(page: Int, callback: (List<PlanData>?, Throwable?) -> Unit) {

        val apiService = ApiClient.retrofit.create(ApiService::class.java)
        safeApiRequestCall { apiService.getplans(PreferenceManager.loginauthData)}.let {
            if (it != null && it.isSuccessful) {
                callback(it.body()?.data,null)
            }else{
                callback(null, Throwable("请求失败"))
            }
        }
    }

}
