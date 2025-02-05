package com.github.kr328.clash

import androidx.recyclerview.widget.RecyclerView
import com.github.kr328.clash.common.util.intent
import com.github.kr328.clash.design.BaseListActivity
import com.github.kr328.clash.design.PreferenceManager
import com.github.kr328.clash.design.adapter.OrdersDataAdapter
import com.github.kr328.clash.design.adapter.PlanDataAdapter
import com.github.kr328.clash.network.ApiClient
import com.github.kr328.clash.network.ApiService
import com.github.kr328.clash.network.OrderData
import com.github.kr328.clash.network.PlanData
import com.github.kr328.clash.network.safeApiRequestCall


class MyOrdersActivity : BaseListActivity<OrderData>() {

    override fun createAdapter(): RecyclerView.Adapter<*> {
        return OrdersDataAdapter(){  item ->

            startActivity(SubmitOrderActivity::class.intent.putExtra("trade_no",item.trade_no))
        }
    }
    override fun onCreate() {}
    override suspend fun loadData(page: Int, callback: (List<OrderData>?, Throwable?) -> Unit) {

        val apiService = ApiClient.retrofit.create(ApiService::class.java)
        safeApiRequestCall {  apiService.getOrders(PreferenceManager.loginauthData)}.let {
            if (it!= null && it.isSuccessful) {
                callback(it.body()?.data,null)
            }else{
                callback(null, Throwable("请求失败"))
            }
        }
    }

}
