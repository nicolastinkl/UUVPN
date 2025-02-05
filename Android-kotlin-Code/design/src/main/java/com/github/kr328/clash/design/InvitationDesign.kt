package com.github.kr328.clash.design

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import android.view.View
import android.widget.Toast
import com.github.kr328.clash.common.util.intent
import com.github.kr328.clash.design.databinding.ActivityInvitationBinding
import com.github.kr328.clash.design.databinding.ActivityInviteItemBinding
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
import com.github.kr328.clash.network.PaymentData
import com.github.kr328.clash.network.PublicResponse
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

class InvitationDesign  (context: Context) : Design<InvitationDesign.Request>(context)  {

    enum class Request {
        SubmitGenNewInviteCpde,
    }

    private var  firstLink:String = ""
    private val binding = ActivityInvitationBinding
        .inflate(context.layoutInflater, context.root, false)

    override val root: View
        get() = binding.root


    init {
        binding.self = this
        binding.activityBarLayout.applyFrom(context)

        binding.CreatenewInvitecodeButton.setOnClickListener {
            LoadingDialog.show(context, "正在生成中...")
            CoroutineScope(Dispatchers.IO).launch {
                val apiService = ApiClient.retrofit.create(ApiService::class.java)
                safeApiRequestCall { apiService.saveinvite(PreferenceManager.loginauthData)}.let {
                    withContext(Dispatchers.Main) {
                        LoadingDialog.hide()
                    }

                    if (it != null && it.isSuccessful) {
                        withContext(Dispatchers.Main) {
                            requestdataDisible()
                        }
                    }else{
                        val errorinfo = it?.errorBody()?.string()

                        if (errorinfo != null){
                            //解析错错误信息

                            val gson = Gson()
                            val submitResponse = gson.fromJson(errorinfo, PublicResponse::class.java)

                            if (submitResponse?.message != null){
                                withContext(Dispatchers.Main) {
                                    Toast.makeText(context, "生成失败: ${submitResponse.message}",  Toast.LENGTH_SHORT).show()
                                }
                            }
                        }else{
                            withContext(Dispatchers.Main) {
                                Toast.makeText(context, "生成失败",  Toast.LENGTH_SHORT).show()
                            }
                        }
                    }

                }
            }
        }

        binding.shareLinkButton.setOnClickListener {

            showDiag(firstLink)
        }
    }


    fun  showDiag(code:String){
        val message = "目前为止我用过最好的梯子，播放Youtube、Netflix高清视频从未如此轻松。\n\n" +
                "下载链接（推荐使用Chrome浏览器访问）：${PreferenceManager.getConfigFromPreferences(context)?.websiteURL}\n\n" +
                "安装后打开填写我的邀请码：${code} 你能多得3天会员!\n"

        context.showCustomDialog(
            title = "推荐文案",
            message = message ,
            positiveButtonText = "立即分享",
            negativeButtonText = "复制推荐文案",
            onPositiveClick = {

                launch {

                    // 创建分享意图
                    val shareIntent = Intent().apply {
                        action = Intent.ACTION_SEND
                        putExtra(Intent.EXTRA_TEXT, message) // 分享的文字内容
                        type = "text/plain"
                    }

                    // 启动分享选择器
                    context.startActivity(Intent.createChooser(shareIntent, "分享给朋友"))
                }

            },
            onNegativeClick = {
                // 清理缓存，清除节点信息，切换界面
                launch {
                    copytoSysString(message)
                }

            }
        )
    }
    fun request(request: Request) {

    }

    fun formatTimestamp(timestamp: Long): String {
        val dateFormat = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault())  // 定义格式
        val date = Date(timestamp)  // 将时间戳转为 Date 对象
        return dateFormat.format(date)  // 格式化为字符串
    }

    private suspend fun copytoSys(code: String ){
        withContext(Dispatchers.Main) {
            showDiag(code)
        }

//        var cm: ClipboardManager =  context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
//        var str:ClipData= ClipData.newPlainText("Label",PreferenceManager.getConfigFromPreferences(context)?.mainregisterURL+code)
//
//        cm.setPrimaryClip(str)
//        showToast("复制成功到剪切板",ToastDuration.Long)
    }

    private suspend fun copytoSysString(code: String ){
        var cm: ClipboardManager =  context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        var str:ClipData= ClipData.newPlainText("Label",code)

        cm.setPrimaryClip(str)
        showToast("复制成功到剪切板",ToastDuration.Long)
    }



    fun  requestdataDisible(){

        LoadingDialog.show(context, "正在获取中...")

        CoroutineScope(Dispatchers.IO).launch {
            val apiService = ApiClient.retrofit.create(ApiService::class.java)
            safeApiRequestCall {  apiService.getinviteList(PreferenceManager.loginauthData)}.let {
                withContext(Dispatchers.Main) {
                    LoadingDialog.hide()
                }

                if (it != null && it.isSuccessful){
                    if (it.body()?.data?.stat != null){
                        val listdata = it.body()?.data?.stat

                        var index = 0

                        listdata?.forEach { item ->
                            withContext(Dispatchers.Main) {
                                if (index == 0) {
                                    binding.inviteZhucenum = "${item}人"
                                } else if (index == 1) {
                                    binding.inviteQuerenzhong = "¥${item}.00"
                                } else if (index == 2) {
                                    binding.inviteZhucenumleiji = "¥${item}.00"
                                } else if (index == 3) {
                                    binding.inviteBili = "${item}%"

                                }
                            }
                            index ++
                        }

                    }

                    val codes = it.body()?.data?.codes

                    withContext(Dispatchers.Main) {
                        binding.container.removeAllViews()
                        var index = 0
                        codes?.forEach { item ->

                            if (index == 0){
                                firstLink = item.code ?: ""
                            }
                                val frameLayout = ActivityInviteItemBinding.inflate(
                                    context.layoutInflater,
                                    context.root,
                                    false
                                )

                                frameLayout.nameTextView.text = item.code
                              //  frameLayout.timeTextView.text =   "${formatTimestamp((item.created_at ?: 0) * 1000L)}"

                                frameLayout.planitemFrameLayout.setOnClickListener {
                                    println("click ${item}")
                                    GlobalScope.launch {
                                        this@InvitationDesign.copytoSys(item.code ?: "")
                                    }

                                }
                                frameLayout.copyInvitecodeButton.setOnClickListener {
                                    GlobalScope.launch {
                                        this@InvitationDesign.copytoSys(item.code ?: "")

                                    }

                                }
                                binding.container.addView(frameLayout.root)
                            index ++

                        }
                    }
                }
            }

        }
    }
}