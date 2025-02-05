package com.github.kr328.clash.design

import android.view.View

import android.content.Context
import android.content.res.ColorStateList
import android.graphics.Color
import android.graphics.RenderEffect
import android.graphics.Shader
import android.os.Build
import com.github.kr328.clash.core.bridge.Bridge
import com.github.kr328.clash.design.MainDesign.Request
import com.github.kr328.clash.design.databinding.ActivityProfileBinding

import com.github.kr328.clash.design.databinding.DesignProfilesBinding
import com.github.kr328.clash.design.network.APIGlobalObject
import com.github.kr328.clash.design.util.applyFrom
import com.github.kr328.clash.design.util.bindAppBarElevation
import com.github.kr328.clash.design.util.layoutInflater
import com.github.kr328.clash.design.util.resolveThemedColor
import com.github.kr328.clash.design.util.root
import com.github.kr328.clash.network.ConfigResponse
import com.github.kr328.clash.network.SubscribeData
import com.github.kr328.clash.network.SubscribeResponse
import com.github.kr328.clash.service.model.Profile
import com.google.gson.Gson
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class ProfileDesign (context: Context) : Design<ProfileDesign.Request>(context) {

    enum class Request {
        OpenBuyPlan,
        OpenMyOrders,
        OpenMyBlance,
        OpenMyInvites,
        OpenCustomView,
        OpenMyGongdan,
        OpenLogout,
        OpenGSettings,
        OpenCustomViewIPtest,
        OpenCustomViewSpeed
    }

    private  var  subData: SubscribeData? = null

    private val binding = ActivityProfileBinding
        .inflate(context.layoutInflater, context.root, false)

    override val root: View
        get() = binding.root


    init {
        binding.self = this

        binding.activityBarLayout.applyFrom(context)

//        binding.viewAccountinfo.setBackgroundColor(Color.parseColor("#FFFFFF")) // Semi-transparent white color
//        binding.viewAccountinfo2.setBackgroundColor(Color.parseColor("#FFFFFF")) // Semi-transparent white color
//        binding.viewAccountinfo3.setBackgroundColor(Color.parseColor("#FFFFFF")) // Semi-transparent white color
//        binding.viewAccountinfo4.setBackgroundColor(Color.parseColor("#FFFFFF")) // Semi-transparent white color

    }

    fun request(request: Request) {
        requests.trySend(request)
    }
    fun formatTimestamp(timestamp: Long): String {
        val dateFormat = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault())  // 定义格式
        val date = Date(timestamp)  // 将时间戳转为 Date 对象
        return dateFormat.format(date)  // 格式化为字符串
    }

    fun queryVersion(version: String){
        binding.textVersion.text = version
    }

    suspend fun requestdataDisible() {

        if ( APIGlobalObject.subData == null){
            val gson = Gson()
            val cached_userSubscritedata =  gson.fromJson(PreferenceManager.cached_userSubscritedata, SubscribeResponse::class.java)
            APIGlobalObject.subData =  cached_userSubscritedata.data
        }
        binding.accountEmail = PreferenceManager.loginemail


        if ((APIGlobalObject.subData?.plan?.id ?:0) > 0){

            binding.accountPlanname =  APIGlobalObject.subData?.plan?.name ?: ""
            if ( APIGlobalObject.subData?.expired_at == null){
                binding.accountPlantime = "该订阅长期有效"
            }else{
                binding.accountPlantime = "到期时间：${ formatTimestamp((APIGlobalObject.subData?.expired_at ?: 0) * 1000L)}"
            }
            val total = APIGlobalObject.subData?.plan?.transfer_enable ?: 0
            val upmb = (APIGlobalObject.subData?.d ?: 0.00).toDouble().div(1024).div(1024).div(1024)
            val downmb = (APIGlobalObject.subData?.u ?: 0.00).toDouble().div(1024).div(1024).div(1024)
            val usd =  upmb + downmb
            binding.accountPlanuseinfo = "已用 ${String.format("%.2f", usd)}GB/总计 ${total}GB"

            if (total>0 && usd>0) {
                binding.accountProgressValue = (usd /total.toDouble()  * 100).toInt()
                if(usd > total){
                    binding.useedprogressBar.progressTintList =  ColorStateList.valueOf(
//                        context.resolveThemedColor(R.attr.colorOnPrimary)
                        Color.parseColor("#ce665e")
                    )
                }else{

                }
            }else{
                binding.accountProgressValue = 0
            }
            binding.accountBlance = "${ APIGlobalObject.subData?.transfer_enable }"
        }else{
            binding.accountPlanname = "未订阅任何套餐"
            binding.accountPlantime = "已过期"
            binding.accountPlanuseinfo = "已用 0GB/总计 0GB"
        }

    }



}