package com.github.kr328.clash

import android.graphics.Color
import android.graphics.Rect
import android.provider.Settings.Global
import android.view.Gravity
import android.view.View
import android.widget.Button
import android.widget.EditText
import android.widget.FrameLayout
import android.widget.LinearLayout
import android.widget.Toast
import androidx.core.content.ContextCompat
import androidx.core.view.ViewCompat
import androidx.recyclerview.widget.RecyclerView
import com.github.kr328.clash.design.BaseListActivity
import com.github.kr328.clash.design.PreferenceManager
import com.github.kr328.clash.design.adapter.TicketDetailAdapter
import com.github.kr328.clash.design.adapter.TicketsDataAdapter
import com.github.kr328.clash.design.ui.ToastDuration
import com.github.kr328.clash.network.ApiClient
import com.github.kr328.clash.network.ApiService
import com.github.kr328.clash.network.PublicResponse
import com.github.kr328.clash.network.TicketMessage
import com.github.kr328.clash.network.safeApiRequestCall
import com.google.gson.Gson
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.net.URLEncoder

class TicketDetailActivity  : BaseListActivity<TicketMessage>() {

    override fun createAdapter(): RecyclerView.Adapter<*> {
        return TicketDetailAdapter(){ planData ->
            // 在这里处理 item 点击事件
        }
    }
    override fun onCreate() {

    }

    fun encodeString(input: String): String {
        val encoded = StringBuilder()

        input.forEach { char ->
            when {
                char.isWhitespace() -> {
                    // 编码空格为 %20
                    encoded.append("")
                }
                char.isLetterOrDigit() || char.toInt() in 0x4E00..0x9FFF -> {
                    // 保留字母、数字和中文字符
                    encoded.append(char)
                }
                else -> {
                    // 其他字符使用 URLEncoder 编码
                    encoded.append(URLEncoder.encode(char.toString(), "UTF-8"))
                }
            }
        }

        return encoded.toString()
    }


    fun onCreateInputView() {


        // 将 dp 转换为 px 的实用函数
        fun dpToPx(dp: Int): Int {
            return (dp * resources.displayMetrics.density).toInt()
        }

        // 创建顶部分割线
        val topDivider = View(this).apply {
            layoutParams = FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                dpToPx(1) // 设置分割线高度为 1dp
            ) .apply {
                gravity = Gravity.TOP // 将分割线置于顶部
            }
            setBackgroundColor(ContextCompat.getColor(this@TicketDetailActivity, android.R.color.darker_gray)) // 设置分割线颜色
        }

        val rootLayout = FrameLayout(this).apply {
            layoutParams = FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT
            )
            addView(topDivider) // 将分割线添加到根布局

        }

        // Create the input container layout programmatically
        // Create the input container layout programmatically
        val inputContainer = LinearLayout(this).apply {
            orientation = LinearLayout.HORIZONTAL
            setPadding(8, 8, 8, 8)
//            setBackgroundColor(ContextCompat.getColor(this@TicketDetailActivity, android.R.color.white))
            layoutParams = FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.WRAP_CONTENT,
                Gravity.BOTTOM // Aligns the input container to the bottom
            )
            setBackgroundColor(ContextCompat.getColor(this@TicketDetailActivity, R.color.white))
        }

        // Create the EditText for message input
        val editText = EditText(this).apply {
            hint = "输入内容回复工单..."
            setHintTextColor(ContextCompat.getColor(this@TicketDetailActivity, R.color.gray)) // Set the placeholder color
            // Utility function to convert dp to pixels
            fun dpToPx2(dp: Int): Int {
                return (dp * resources.displayMetrics.density).toInt()
            }
            textSize = 14f

            // Set other EditText properties
            setTextColor(Color.BLACK) // Text color
            inputType = android.text.InputType.TYPE_TEXT_FLAG_MULTI_LINE
            setTextColor(ContextCompat.getColor(this@TicketDetailActivity, R.color.black))
            maxLines = 1
            // background = ContextCompat.getDrawable(this@TicketDetailActivity, R.drawable.rounded_button_background)

            // 设置内边距为 4dp（上下左右）
            // val padding = dpToPx(8)
            //  setPadding(padding,0 ,  padding, 0)
            layoutParams = LinearLayout.LayoutParams(
                0,
                LinearLayout.LayoutParams.WRAP_CONTENT,
                1f // Weight to make it fill available width
            )
        }

        // Create the Send Button

        val sendButton = Button(this).apply {
            text = "回复"
            setTextColor(ContextCompat.getColor(this@TicketDetailActivity, android.R.color.white)) // Set text color for better contrast

            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            )
        }

        // Set the background tint programmatically
        ViewCompat.setBackgroundTintList(
            sendButton,
            ContextCompat.getColorStateList(this, R.color.blue)
        )


        // Add EditText and Button to the input container
        inputContainer.addView(editText)
        inputContainer.addView(sendButton)


        sendButton.setOnClickListener {
            val message =  editText.text.toString()
            if (message.isNullOrEmpty()){

            }else{
                val fieldMap = mutableMapOf<String, String>()
                val messageProperty1 = encodeString(message)
                val ticketid = intent.getIntExtra("ticketid",0)
                fieldMap.put("message",""+messageProperty1)
                fieldMap.put("id",""+ticketid)

                GlobalScope.launch {

                    val apiService = ApiClient.retrofit.create(ApiService::class.java)
                    safeApiRequestCall { apiService.replyTicket(PreferenceManager.loginauthData, fieldMap)}.let {
                        if (it != null && it.isSuccessful) {
                            withContext(Dispatchers.Main) {
                                Toast.makeText(this@TicketDetailActivity, "回复成功",  Toast.LENGTH_SHORT).show()
                                editText.setText("")
                            }
                            refereshData()

                        }else{
                            val errorinfo = it?.errorBody()?.string()

                            if (errorinfo != null){
                                //解析错错误信息

                                val gson = Gson()
                                val submitResponse = gson.fromJson(errorinfo, PublicResponse::class.java)

                                if (submitResponse?.message != null){
                                    withContext(Dispatchers.Main) {
                                        Toast.makeText(this@TicketDetailActivity, "回复失败: ${submitResponse.message}",  Toast.LENGTH_SHORT).show()
                                    }
                                }
                            }else{
                                withContext(Dispatchers.Main) {
                                    Toast.makeText(this@TicketDetailActivity, "回复失败",  Toast.LENGTH_SHORT).show()
                                }
                            }

                        }
                    }
                }
            }
        }


        // 将分割线添加到输入容器顶部


        rootLayout.addView(inputContainer)
        // rootLayout.addView(topDivider) // 将分割线添加到根布局
        // Add the input container to the root layout
        mainBinding?.mainview?.addView(rootLayout)

        rootLayout.viewTreeObserver.addOnGlobalLayoutListener {
            val rect = Rect()
            rootLayout.getWindowVisibleDisplayFrame(rect)
            val screenHeight = rootLayout.rootView.height
            val keypadHeight = screenHeight - rect.bottom

            val params = inputContainer.layoutParams as FrameLayout.LayoutParams
            if (keypadHeight > screenHeight * 0.15) {
                // Keyboard is visible; adjust inputContainer to stay above it
                params.bottomMargin = keypadHeight
            } else {
                // Keyboard is hidden; reset inputContainer to bottom
                params.bottomMargin = 0
            }
            inputContainer.layoutParams = params
        }

    }
    override suspend fun loadData(page: Int, callback: (List<TicketMessage>?, Throwable?) -> Unit) {
        val ticketid = intent.getIntExtra("ticketid",0)
        val apiService = ApiClient.retrofit.create(ApiService::class.java)
        safeApiRequestCall { apiService.getTicketsByTID(PreferenceManager.loginauthData,ticketid)}.let {
            if (it != null && it.isSuccessful) {
                withContext(Dispatchers.Main) {

                    referTitle(it.body()?.data?.subject ?: "")
                }
                if(it.body()?.data?.status == 0){
                    withContext(Dispatchers.Main) {
                        onCreateInputView()
                    }
                }
                callback(it.body()?.data?.message,null)

            }else{
                callback(null, Throwable("请求失败"))
            }
        }
    }

}
