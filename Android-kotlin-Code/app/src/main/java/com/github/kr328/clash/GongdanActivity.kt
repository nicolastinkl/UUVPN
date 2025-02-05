package com.github.kr328.clash

import android.app.Activity
import android.content.Intent
import android.content.res.ColorStateList
import android.graphics.Color
import android.view.Gravity
import android.widget.Button
import android.widget.FrameLayout
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.content.ContextCompat
import androidx.core.view.ViewCompat
import androidx.recyclerview.widget.RecyclerView
import com.github.kr328.clash.design.BaseListActivity
import com.github.kr328.clash.design.PreferenceManager
import com.github.kr328.clash.design.adapter.TicketsDataAdapter
import com.github.kr328.clash.design.util.showCustomDialog
import com.github.kr328.clash.network.ApiClient
import com.github.kr328.clash.network.ApiService
import com.github.kr328.clash.network.TicketsData
import com.github.kr328.clash.network.safeApiRequestCall
import com.github.kr328.clash.utity.LoadingDialog
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext


class GongdanActivity  : BaseListActivity<TicketsData>() {

    override fun createAdapter(): RecyclerView.Adapter<*> {

        return TicketsDataAdapter(onItemClick = { planData ->
            // 在这里处理 item 点击事件
            val intent = Intent(this, TicketDetailActivity::class.java)
            intent.putExtra("ticketid", planData.id ?: 0)
            startActivity(intent)
        }, onCloseItemClick = { planData ->
            showCustomDialog(
                title = "提示",
                message = "确定关闭当前工单吗？",
                positiveButtonText = "确定",
                negativeButtonText = "取消",
                onPositiveClick = {
                    // 执行确认操作
                    //  startActivity(PlansActivity::class.intent)
                    CoroutineScope(Dispatchers.IO).launch {
                        val apiService = ApiClient.retrofit.create(ApiService::class.java)
                        val fieldMap = mutableMapOf<String, Int>()

                        fieldMap.put("id",planData.id ?: 0)

                        safeApiRequestCall {
                            apiService.closeTicket(
                                PreferenceManager.loginauthData,
                                request = fieldMap
                            )
                        }.let {
                                withContext(Dispatchers.Main) {
                                    LoadingDialog.hide()
                                }
                                if (it != null && it.isSuccessful) {
                                    withContext(Dispatchers.Main) {
                                        Toast.makeText(this@GongdanActivity, "关闭成功", Toast.LENGTH_SHORT).show()

                                    }
                                    refereshData()

                                }else{
                                    withContext(Dispatchers.Main) {
                                        Toast.makeText(
                                            this@GongdanActivity,
                                            "关闭失败",
                                            Toast.LENGTH_SHORT
                                        ).show()
                                    }
                                }
                            }
                    }
                },
                onNegativeClick = {
                    // 执行取消操作
                }
            )
        })
    }

    override fun onCreate() {
        // Create the top-right icon
        val iconView = Button(this)
        iconView.setText("新建工单")
        iconView.layoutParams = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.WRAP_CONTENT,
            FrameLayout.LayoutParams.WRAP_CONTENT,
            Gravity.TOP or Gravity.END
        ).apply {
            marginEnd = 16  // Add margin to the right
            topMargin = 16  // Add margin to the top
        }
        // Set the background tint programmatically
  /*      ViewCompat.setBackgroundTintList(
            iconView,
            ContextCompat.getColorStateList(this, R.color.blue)
        )
*/
        val colorStateList: ColorStateList = ColorStateList(
            arrayOf<IntArray>(intArrayOf(android.R.attr.state_pressed)), intArrayOf(
                R.color.blue
            )
        )
        iconView.setBackgroundTintList(colorStateList)
        iconView.setOnClickListener {
            val intent = Intent(this@GongdanActivity, NewGongdanActivity::class.java)
            //startActivity(intent)
            resultLauncher.launch(intent)

        }
        mainBinding?.activityBarLayout?.addView(iconView)




    }

    private val resultLauncher = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
        if (result.resultCode == Activity.RESULT_OK) {
            val data = result.data
            val resultData = data?.getStringExtra("resultKey")
            // Process the result
            println("registerForActivityResult : resultData : ${resultData} ")
            if (resultData == "shuaxin"){

                refereshData()
            }
        }
    }

    override suspend fun loadData(page: Int, callback: (List<TicketsData>?, Throwable?) -> Unit) {


//        android:backgroundTint="@color/blue"
//        android:background="@drawable/rounded_button_background"



        val apiService = ApiClient.retrofit.create(ApiService::class.java)
        safeApiRequestCall { apiService.getTickets(PreferenceManager.loginauthData)}.let {
            if (it != null && it.isSuccessful) {
                callback(it.body()?.data,null)
            }else{
                callback(null, Throwable("请求失败"))
            }
        }
    }

}
