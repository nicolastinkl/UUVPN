package com.github.kr328.clash.design

import android.content.Context
import android.net.Uri
import android.view.View
import android.view.inputmethod.InputMethodManager
import android.widget.Toast
import androidx.core.content.ContextCompat.getSystemService
import com.github.kr328.clash.design.MainDesign.Request
import com.github.kr328.clash.design.databinding.DesignSettingsCommonBinding
import com.github.kr328.clash.design.preference.NullableTextAdapter
import com.github.kr328.clash.design.preference.TextAdapter
import com.github.kr328.clash.design.preference.category
import com.github.kr328.clash.design.preference.clickable
import com.github.kr328.clash.design.preference.editableText
import com.github.kr328.clash.design.preference.editableTextMap
import com.github.kr328.clash.design.preference.preferenceScreen
import com.github.kr328.clash.design.preference.tips
import com.github.kr328.clash.design.ui.ToastDuration
import com.github.kr328.clash.design.util.applyFrom
import com.github.kr328.clash.design.util.bindAppBarElevation
import com.github.kr328.clash.design.util.layoutInflater
import com.github.kr328.clash.design.util.root
import com.github.kr328.clash.network.ApiClient
import com.github.kr328.clash.network.ApiService
import com.github.kr328.clash.network.LoginRequest
import com.github.kr328.clash.network.PublicResponse
import com.github.kr328.clash.network.safeApiRequestCall
import com.github.kr328.clash.utity.LoadingDialog
import com.google.gson.Gson
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.net.URLEncoder

class HelpDesign(
    context: Context,
    openLink: (Uri) -> Unit,
) : Design<HelpDesign.Request>(context) {
    private val binding = DesignSettingsCommonBinding
        .inflate(context.layoutInflater, context.root, false)

    enum class Request {
        CommitSuccess,
    }

    fun request(request: HelpDesign.Request) {
        requests.trySend(request)
    }



    override val root: View
        get() = binding.root

    init {
        binding.surface = surface

        binding.activityBarLayout.applyFrom(context)

        /*
             binding.scrollRoot.bindAppBarElevation(binding.activityBarLayout)


             data class ConfigurationOverride(

                  var title: String? = null,
                  var content: String? = null

             )
             val  configuration = ConfigurationOverride()

             val screen = preferenceScreen(context) {



                   editableText(
                     value = configuration::title,
                     adapter = NullableTextAdapter.String,
                     title = R.string.name,
                     placeholder = R.string.name,
                     empty = R.string.default_
                 )

                 editableText(
                     value = configuration::content,
                     adapter = NullableTextAdapter.String,
                     title = R.string.more,
                     placeholder = R.string.more,
                     empty = R.string.default_
                 )

                   tips(R.string.tips_help)


                   clickable(
                       title = R.string.github_issues,
                       summary = R.string.github_issues_zeus
                   ) {
                       clicked {
                           openLink(Uri.parse("https://github.com/nicolastinkl"))
                       }
                   }



                              category(R.string.document)


                              clickable(
                                  title = R.string.clash_wiki,
                                  summary = R.string.clash_wiki_url
                              ) {
                                  clicked {
                                      openLink(Uri.parse(context.getString(R.string.clash_wiki_url)))
                                  }
                              }



                              clickable(
                                  title = R.string.clash_meta_wiki,
                                  summary = R.string.clash_meta_wiki_url
                              ) {
                                  clicked {
                                      openLink(Uri.parse(context.getString(R.string.clash_meta_wiki_url)))
                                  }
                              }

                              category(R.string.sources)

                              clickable(
                                  title = R.string.clash_meta_core,
                                  summary = R.string.clash_meta_core_url
                              ) {
                                  clicked {
                                      openLink(Uri.parse(context.getString(R.string.clash_meta_core_url)))
                                  }
                              }

                              clickable(
                                  title = R.string.clash_meta_for_android,
                                  summary = R.string.meta_github_url
                              ) {
                                  clicked {
                                      openLink(Uri.parse(context.getString(R.string.meta_github_url)))
                                  }
                              }
             }

             binding.content.addView(screen.root) */

        binding.gongdanButton.setOnClickListener {
            val gondanSubText = binding.gondanSubText.text.toString()
            val gondanSubContent = binding.gondanSubContent.text.toString()


            if (gondanSubText.isEmpty() || gondanSubContent.isEmpty()) {
                Toast.makeText(context, "请输入工单标题和内容", Toast.LENGTH_SHORT).show()
            }  else {

                // Hide the keyboard
                val inputMethodManager = context.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
                val currentFocusView = binding.root
                if (currentFocusView != null) {
                    inputMethodManager.hideSoftInputFromWindow(currentFocusView.windowToken, 0)
                }
                performLogin(gondanSubText, gondanSubContent)
            }
        }

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

    private fun performLogin(email: String, password: String) {
        // Perform login logic here, possibly calling an API

        // Show the loading indicator with a custom message
        LoadingDialog.show(context, "正在提交...")

        val apiServiceApp = ApiClient.retrofit.create(ApiService::class.java)

        //获取 Config 数据
        CoroutineScope(Dispatchers.IO).launch {
            val fieldMap = mutableMapOf<String, String>()
            val email1 = encodeString(email)
            val password1 =encodeString(password)
            fieldMap.put("subject",""+email1)
            fieldMap.put("level","1")
            fieldMap.put("message",""+password1)

            safeApiRequestCall {
                apiServiceApp.saveTicket(PreferenceManager.loginauthData, request = fieldMap)}.let {
                withContext(Dispatchers.Main) {
                    LoadingDialog.hide()
                }
                if (it != null &&  it.isSuccessful) {
                    showToast("提交成功",ToastDuration.Long)
                    requests.trySend(Request.CommitSuccess)
                }else{
                    val errorinfo = it?.errorBody()?.string()

                    if (errorinfo != null){
                        //解析错错误信息

                        val gson = Gson()
                        val submitResponse = gson.fromJson(errorinfo, PublicResponse::class.java)

                        if (submitResponse?.message != null){
                            withContext(Dispatchers.Main) {
                                Toast.makeText(context, "提交失败: ${submitResponse.message}",  Toast.LENGTH_SHORT).show()
                            }
                        }
                    }else{
                        withContext(Dispatchers.Main) {
                            Toast.makeText(context, "提交失败",  Toast.LENGTH_SHORT).show()
                        }
                    }


                }
            }
        }
    }

}