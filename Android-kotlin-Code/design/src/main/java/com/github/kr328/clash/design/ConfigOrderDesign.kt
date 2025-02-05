package com.github.kr328.clash.design

import android.content.Context
import android.view.View
import androidx.core.content.ContextCompat
import com.github.kr328.clash.design.ProfileDesign.Request
import com.github.kr328.clash.design.databinding.ActivityConfigorderBinding
import com.github.kr328.clash.design.databinding.ActivityPlanItemBinding
import com.github.kr328.clash.design.databinding.ActivityProfileBinding
import com.github.kr328.clash.design.ui.ToastDuration
import com.github.kr328.clash.design.util.applyFrom
import com.github.kr328.clash.design.util.layoutInflater
import com.github.kr328.clash.design.util.root
import com.github.kr328.clash.network.ApiClient
import com.github.kr328.clash.network.ApiService
import com.github.kr328.clash.network.ConfigResponse
import com.github.kr328.clash.network.PlanData
import com.github.kr328.clash.network.SaveOrderRequest
import com.github.kr328.clash.network.SubmitOrderResponse
import com.github.kr328.clash.network.safeApiRequestCall
import com.github.kr328.clash.utity.LoadingDialog
import com.google.gson.Gson
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.trySendBlocking
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class ConfigOrderDesign (context: Context) : Design<ConfigOrderDesign.Request>(context)  {

    private  var  currentChoose: Map<String,String>? = null
    public  var trade_no:String = ""
    enum class Request {
        SubmitOrder,
    }

    private val binding = ActivityConfigorderBinding
        .inflate(context.layoutInflater, context.root, false)

    override val root: View
        get() = binding.root


    init {
        binding.self = this
        binding.activityBarLayout.applyFrom(context)

    }

    fun request(request: Request) {
        if (request == Request.SubmitOrder){
            //提交订单
            LoadingDialog.show(context, "正在下单中...")


            CoroutineScope(Dispatchers.IO).launch {
                val apiService = ApiClient.retrofit.create(ApiService::class.java)

                safeApiRequestCall { apiService.saveOrder(PreferenceManager.loginauthData, SaveOrderRequest("${currentChoose?.get("period")}",(currentChoose?.get("plan_id") ?: "0").toInt(),""))}.let {
                    withContext(Dispatchers.Main) {
                        LoadingDialog.hide()
                    }

                    if(it != null && it.isSuccessful){
                        if (it.body()?.data != null){
                            //tradeNO 订单号 成功
                            trade_no = it.body()?.data ?: ""
                            requests.trySend(request)
                        }
                    }else{
                        val errorinfo =  (it?.errorBody()?.string())
                        if (errorinfo != null){
                            //解析错错误信息

                            val gson = Gson()
                            val submitResponse = gson.fromJson(errorinfo, SubmitOrderResponse::class.java)

                            if (submitResponse?.message != null){
                                withContext(Dispatchers.Main) {
                                    showToast("下单失败:${submitResponse.message}", ToastDuration.Long)
                                }
                            }
                        }else{
                            withContext(Dispatchers.Main) {
                                showToast("下单失败:请求数据失败", ToastDuration.Long)
                            }
                        }

                    }
                }
            }
        }
    }

    fun fillData(plan: PlanData?){


        binding.configorderPlanname = "商品名称：${plan?.name}"
        if (plan?.onetime_price != null && plan.onetime_price > 0) {
            binding.configorderPlantype = "类型/周期：一次性"
            binding.configorderPlantype2 = "一次性"
        }else{
            binding.configorderPlantype = "类型/周期：按月"
            binding.configorderPlantype2 = "按月"
        }

        binding.configorderPlanname2 = "${plan?.name}"

        binding.configorderPlantransfer = "商品流量：${plan?.transfer_enable} GB"
        if (plan?.onetime_price !=null) {
            binding.configorderPlanamount = "¥ ${plan?.onetime_price.toFloat()/100}0"
        }else{
            if (plan?.month_price !=null) {
                binding.configorderPlanamount = "¥ ${plan?.month_price.toFloat() / 100}0"
            }
        }

        var selectedIndex = 0
        if (plan?.onetime_price != null && plan.onetime_price > 0) {
            //一次性
            val map =  HashMap<String,String>()
            map.put("type","一次性");//存储key和value
            map.put("amount","${plan.onetime_price}");
            map.put("period","onetime_price");
            map.put("plan_id","${plan.id}");

            val frameLayout =  ActivityPlanItemBinding.inflate(context.layoutInflater, context.root, false)
            frameLayout.typeTextView.text = "一次性"
            frameLayout.amountTextView.text = "¥ ${ (map.get("amount")?.toDouble() ?: 0.0)/100}0"

            binding.container.addView(frameLayout.root)

            val child = binding.container.getChildAt(0)
            child.background = ContextCompat.getDrawable(
                context,  R.drawable.card_border_selected
            )
            currentChoose = map

        }else{
            val map =  HashMap<String,String>()
            map.put("type","按月");//存储key和value
            map.put("amount","${plan?.month_price ?: 0}");
            map.put("period","month_price");
            map.put("plan_id","${plan?.id}");

            currentChoose = map
            val map2 =  HashMap<String,String>()
            map2.put("type","按季");//存储key和value
            map2.put("amount","${plan?.quarter_price ?: 0}");
            map2.put("period","quarter_price");
            map2.put("plan_id","${plan?.id}");

            val map3 =  HashMap<String,String>()
            map3.put("type","半年");//存储key和value
            map3.put("amount","${plan?.half_year_price ?: 0}");
            map3.put("period","half_year_price");
            map3.put("plan_id","${plan?.id}");


            val map4 =  HashMap<String,String>()
            map4.put("type","一年");//存储key和value
            map4.put("amount","${plan?.year_price ?: 0}");
            map4.put("period","year_price");
            map4.put("plan_id","${plan?.id}");

            val list = ArrayList<Map<String,String>>()
            list.add(map)

            if((plan?.quarter_price ?: 0) > 0){
                list.add(map2)
            }

            if((plan?.half_year_price ?: 0) > 0){
                list.add(map3)
            }

            if((plan?.year_price ?: 0) > 0){
                list.add(map4)
            }


            for (i in list.indices) {
                // 设置点击事件和单选逻辑
                val frameLayout =  ActivityPlanItemBinding.inflate(context.layoutInflater, context.root, false)
                val item = list[i]
                frameLayout.typeTextView.text =  item.get("type")
                frameLayout.amountTextView.text ="¥ ${ (item.get("amount")?.toDouble() ?: 0.0)/100}0"




                frameLayout.planitemFrameLayout.setOnClickListener {
                    selectedIndex = i
                    currentChoose = item

                    binding.configorderPlantype2 = item.get("type")
                    binding.configorderPlanamount =  "¥ ${ (item.get("amount")?.toDouble() ?: 0.0)/100}0"

                    for (j in 0 until binding.container.childCount) {
                        val child = binding.container.getChildAt(j)
                        println("selectedIndex: ${selectedIndex}  ${ child.background} ")
                        child.background = ContextCompat.getDrawable(
                            context,
                            if (j == selectedIndex) R.drawable.card_border_selected else R.drawable.card_border
                        )
                    }
                }
                binding.container.addView(frameLayout.root)


                if (i == 0){
                    //默认选中第一个

                    frameLayout.planitemFrameLayout.background = ContextCompat.getDrawable(
                        context,  R.drawable.card_border_selected
                    )

                }

            }
        }

    }

}