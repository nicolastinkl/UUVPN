package com.github.kr328.clash.design

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.view.View
import androidx.core.content.ContextCompat
import androidx.transition.Visibility
import com.github.kr328.clash.common.util.intent
import com.github.kr328.clash.design.ConfigOrderDesign.Request
import com.github.kr328.clash.design.databinding.ActivityPaymentItemBinding
import com.github.kr328.clash.design.databinding.ActivityPlanItemBinding
import com.github.kr328.clash.design.databinding.ActivitySubmitorderBinding
import com.github.kr328.clash.design.network.APIGlobalObject
import com.github.kr328.clash.design.ui.ToastDuration
import com.github.kr328.clash.design.util.applyFrom
import com.github.kr328.clash.design.util.layoutInflater
import com.github.kr328.clash.design.util.root
import com.github.kr328.clash.design.util.showCustomDialog
import com.github.kr328.clash.network.ApiClient
import com.github.kr328.clash.network.ApiService
import com.github.kr328.clash.network.CheckoutrderRequest
import com.github.kr328.clash.network.PaymentData
import com.github.kr328.clash.network.PublicResponse
import com.github.kr328.clash.network.QueryOrderData
import com.github.kr328.clash.network.QueryOrderRequest
import com.github.kr328.clash.network.SaveOrderRequest
import com.github.kr328.clash.network.SubmitOrderResponse
import com.github.kr328.clash.network.safeApiRequestCall
import com.github.kr328.clash.utity.LoadingDialog
import com.google.gson.Gson
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale


class SubmitOrderViewDesign  (context: Context) : Design<SubmitOrderViewDesign.Request>(context)  {

    enum class Request {
        SubmitPay,
    }


    private  var  currentChoose: PaymentData? = null

    private  var  tradeNo: String = ""


    private val binding = ActivitySubmitorderBinding
        .inflate(context.layoutInflater, context.root, false)

    override val root: View
        get() = binding.root


    fun request(request: Request) {
        if (request == Request.SubmitPay) {
            //提交订单
            LoadingDialog.show(context, "正在结账中...")
            CoroutineScope(Dispatchers.IO).launch {
                val apiService = ApiClient.retrofit.create(ApiService::class.java)
                safeApiRequestCall { apiService.checkoutOrder(PreferenceManager.loginauthData, CheckoutrderRequest(tradeNo,currentChoose?.id ?: 0 ))}.let {
                    withContext(Dispatchers.Main) {
                        LoadingDialog.hide()
                    }

                    if (it != null && it.isSuccessful){
                        if (it.body()?.data != null){
                              val url = it.body()?.data ?: ""
                              if (url.length > 3){

                                  try {
                                      withContext(Dispatchers.Main) {
                                          val intent = Intent(Intent.ACTION_VIEW)
                                          intent.addCategory(Intent.CATEGORY_BROWSABLE);
                                          intent.setData(Uri.parse(url))
                                          context.startActivity(intent)

                                          //弹出支付框
                                          context.showCustomDialog(
                                              title = "温馨提示",
                                              message = "完成支付后若未到账，请重启一下客户端即可同步订阅套餐时长。",
                                              positiveButtonText = "确定",
                                              negativeButtonText = "取消",
                                              onPositiveClick = {
                                                  fetchTradeInfo(tradeNo)

                                                  launch  {

                                                      withContext(Dispatchers.Main) {

                                                      }
                                                  }
                                              },
                                              onNegativeClick = {
                                                  // 执行取消操作
                                              }
                                          )



                                      }
                                  } catch (e: Exception) {
                                      println("当前手机未安装浏览器")
                                  }
                              }
                        }
                        println(it.body())
                    }else{
                        val errorinfo =  (it?.errorBody()?.string())
                        if (errorinfo != null){
                            //解析错错误信息

                            val gson = Gson()
                            val submitResponse = gson.fromJson(errorinfo, PublicResponse::class.java)

                            if (submitResponse?.message != null){
                                withContext(Dispatchers.Main) {
                                    showToast("结算请求失败:${submitResponse.message}", ToastDuration.Long)
                                }
                            }
                        }else{
                            withContext(Dispatchers.Main) {
                                showToast("结算失败:请求数据失败", ToastDuration.Long)
                            }
                        }
                    }
                }
            }

        }
    }
    init {
        binding.self = this
        binding.activityBarLayout.applyFrom(context)

    }

    fun fetchTradeInfo(trade_no: String?){
        tradeNo = trade_no ?: ""
        LoadingDialog.show(context, "请求订单数据...")

        CoroutineScope(Dispatchers.IO).launch {
            val apiService = ApiClient.retrofit.create(ApiService::class.java)
            safeApiRequestCall { apiService.getOrderdetail(PreferenceManager.loginauthData,trade_no?: "")}.let {

                if(it != null && it.isSuccessful){
                    if (it.body()?.data != null){
                        withContext(Dispatchers.Main) {
                            fillData(it.body()?.data)
                            LoadingDialog.hide()
                            // 清空 binding.container 的所有子视图
                            binding.container.removeAllViews()

                        }
                        var selectedIndex = 0

                        //继续获取支付方式
                        safeApiRequestCall { apiService.getPaymentList(PreferenceManager.loginauthData)}.let {
                            if(it != null && it.isSuccessful){
                                println("${it.body()}")
                                withContext(Dispatchers.Main) {
                                    it.body().let {
                                        it?.data.let {
                                            if (it != null) {
                                                for (i in it.indices) {
                                                    // 设置点击事件和单选逻辑
                                                    val frameLayout =
                                                        ActivityPaymentItemBinding.inflate(
                                                            context.layoutInflater,
                                                            context.root,
                                                            false
                                                        )
                                                    val item = it[i]
                                                    frameLayout.typeTextView.text = item.name
                                                    frameLayout.amountTextView.text =  "手续费：${item.handling_fee_percent ?: "0.00"}%"


                                                    frameLayout.planitemFrameLayout.setOnClickListener {
                                                        selectedIndex = i
                                                        currentChoose = item

                                                        for (j in 0 until binding.container.childCount) {
                                                            val child =
                                                                binding.container.getChildAt(j)
                                                            println("selectedIndex: ${selectedIndex}  ${child.background} ")
                                                            child.background =
                                                                ContextCompat.getDrawable(
                                                                    context,
                                                                    if (j == selectedIndex) R.drawable.card_border_selected else R.drawable.card_border
                                                                )
                                                        }
                                                    }
                                                    binding.container.addView(frameLayout.root)



                                                    if (i == 0){
                                                        //默认选中第一个
                                                        currentChoose = it[0]
                                                        //设置手续费显示：

                                                        //binding.configorderPlanFeeAmount =  currentChoose.handling_fee_percent
                                                        frameLayout.planitemFrameLayout.background = ContextCompat.getDrawable(
                                                            context,  R.drawable.card_border_selected
                                                        )

                                                    }



                                                }


                                            }
                                        }
                                    }
                                }
                            }
                        }

                    }
                }else{
                    val errorinfo =  (it?.errorBody()?.string())
                    if (errorinfo != null){
                        //解析错错误信息

                        val gson = Gson()
                        val submitResponse = gson.fromJson(errorinfo, PublicResponse::class.java)

                        if (submitResponse?.message != null){
                            withContext(Dispatchers.Main) {
                                showToast("订单请求失败:${submitResponse.message}", ToastDuration.Long)
                            }
                        }
                    }else{
                        withContext(Dispatchers.Main) {
                            showToast("下单失败:请求数据失败", ToastDuration.Long)
                        }
                    }

                }

                withContext(Dispatchers.Main) {

                    LoadingDialog.hide()
                }
            }
        }

    }


    fun formatTimestamp(timestamp: Long): String {
        val dateFormat = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault())  // 定义格式
        val date = Date(timestamp)  // 将时间戳转为 Date 对象
        return dateFormat.format(date)  // 格式化为字符串
    }

    private fun fillData(data: QueryOrderData?) {
        data.let {
            binding.configorderPlanname  = "商品名称：${data?.plan?.name}"
            binding.configorderTradeno = "订单号：${data?.trade_no}"
            binding.configorderPlanname2 = data?.plan?.name
            val amount = (data?.total_amount?.toDouble() ?: 0.0)/100
            binding.configorderPlanamount =  "¥ ${amount}0"
            binding.configorderPlantype = "类型/周期：${data?.periodZh}"
            binding.configorderPlantransfer =  "商品流量：${data?.plan?.transfer_enable} GB"
            binding.configorderTimer = "创建时间：${ formatTimestamp((data?.created_at ?: 0) * 1000L)}"
            binding.orderDetailsStatus.text = data?.statusZh
            if (data?.status == 0){
                binding.confirmPaymentButton.visibility = View.VISIBLE
            }else{
                binding.confirmPaymentButton.visibility = View.GONE
            }
        }
    }


}