package com.github.kr328.clash

import android.content.Context
import android.content.Intent
import android.content.res.Configuration
import android.os.Build
import android.os.Bundle
import com.github.kr328.clash.common.util.intent
import android.view.View
import android.view.inputmethod.InputMethodManager
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.github.kr328.clash.common.compat.isAllowForceDarkCompat
import com.github.kr328.clash.common.compat.isLightNavigationBarCompat
import com.github.kr328.clash.common.compat.isLightStatusBarsCompat
import com.github.kr328.clash.common.compat.isSystemBarsTranslucentCompat
import com.github.kr328.clash.design.PreferenceManager
import com.github.kr328.clash.design.databinding.ActivityLoginBinding
import com.github.kr328.clash.design.databinding.ActivityProfileBinding
import com.github.kr328.clash.design.databinding.ActivityRegisterBinding
import com.github.kr328.clash.design.ui.DayNight
import com.github.kr328.clash.design.util.layoutInflater
import com.github.kr328.clash.design.util.resolveThemedBoolean
import com.github.kr328.clash.design.util.resolveThemedColor
import com.github.kr328.clash.design.util.root
import com.github.kr328.clash.network.ApiClient
import com.github.kr328.clash.network.ApiClientConfig
import com.github.kr328.clash.network.ApiService
import com.github.kr328.clash.network.ConfigResponse
import com.github.kr328.clash.network.LoginRequest
import com.github.kr328.clash.network.LoginResponse
import com.github.kr328.clash.network.safeApiRequestCall
import com.github.kr328.clash.utity.LoadingDialog
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import org.json.JSONException
import org.json.JSONObject

class RegisterActivity : AppCompatActivity() {

    private lateinit var apiService: ApiService

    private var dayNight: DayNight = DayNight.Day

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val binding = ActivityRegisterBinding
            .inflate(this.layoutInflater, this.root, false)

        setContentView(binding.root)

        applyDayNight()

        PreferenceManager.init(this)

        binding.loginLoginButton.setOnClickListener {
            val email = binding.loginEmailEditText.text.toString()
            val password = binding.loginPasswordEditText.text.toString()
            val password2 = binding.loginPasswordEditText2.text.toString()
            val isAgreementChecked = binding.loginAgreementCheckBox.isChecked

            if (email.isEmpty() || password.isEmpty() || password2.isEmpty()) {
                Toast.makeText(this, "请输入邮箱和密码", Toast.LENGTH_SHORT).show()
            } else if (!isAgreementChecked) {
                Toast.makeText(this, "请同意隐私政策和用户协议", Toast.LENGTH_SHORT).show()
            } else {

                // Hide the keyboard
                val inputMethodManager = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
                val currentFocusView = currentFocus
                if (currentFocusView != null) {
                    inputMethodManager.hideSoftInputFromWindow(currentFocusView.windowToken, 0)
                }

                performLogin(email, password)
            }
        }

        binding.loginForgotPassword.setOnClickListener {
            // Navigate to Forgot Password screen or show dialog
        }

        binding.loginRegister.setOnClickListener {
            // Navigate to Register screen
            finish()
        }

        apiService = ApiClientConfig.retrofit.create(ApiService::class.java)


        //获取 Config 数据
        CoroutineScope(Dispatchers.IO).launch {
            safeApiRequestCall { apiService.getConfig()}.let {
                if (it != null && it.isSuccessful) {

                    val response: ConfigResponse = it.body()  ?: throw Exception("Response body is null")
                    if (response.code == 1 ) {
                        PreferenceManager.saveConfigToPreferences( response)
                        //重新初始化 ApiClint
                    }
                    println("API Response:  ${it.body()}")
                } else {
                    println("API Error: 请求失败")
                }

            }

        }
    }

    /**
     *  withContext(Dispatchers.Main) {
     *             if (response.isSuccessful) {
     *                 val userData = response.body()
     *                 // 更新 UI
     *             } else {
     *                 Toast.makeText(this@MainActivity, "Failed to fetch user data", Toast.LENGTH_SHORT).show()
     *             }
     *         }
     * */

    private fun applyDayNight(config: Configuration = resources.configuration) {
       //val dayNight =  theme.applyStyle(R.style.AppThemeLight, true) //默认白天模式

        /*
        val dayNight =   queryDayNight(config)
        when (dayNight) {
            DayNight.Night -> theme.applyStyle(R.style.AppThemeDark, true)
            DayNight.Day -> theme.applyStyle(R.style.AppThemeLight, true)
        }*/

        window.isAllowForceDarkCompat = false
        window.isSystemBarsTranslucentCompat = true

        window.statusBarColor = resolveThemedColor(android.R.attr.statusBarColor)
        window.navigationBarColor = resolveThemedColor(android.R.attr.navigationBarColor)

        if (Build.VERSION.SDK_INT >= 23) {
            window.isLightStatusBarsCompat = resolveThemedBoolean(android.R.attr.windowLightStatusBar)
        }

        if (Build.VERSION.SDK_INT >= 27) {
            window.isLightNavigationBarCompat = resolveThemedBoolean(android.R.attr.windowLightNavigationBar)
        }

        this.dayNight =  DayNight.Night //dayNight
    }

    private fun performLogin(email: String, password: String) {
        // Perform login logic here, possibly calling an API

        // Show the loading indicator with a custom message
        LoadingDialog.show(this, "正在注册...")

        val apiServiceApp = ApiClient.retrofit.create(ApiService::class.java)

        //获取 Config 数据
        CoroutineScope(Dispatchers.IO).launch {
            safeApiRequestCall {
                apiServiceApp.registerUser(LoginRequest(email,password))}.let {
                withContext(Dispatchers.Main) {
                    LoadingDialog.hide()
                }
                if (it != null &&
                    it.isSuccessful) {
                    println("API Response:  ${it.code()}  ${it.body()}   ${it.raw().body}")
                    val response: LoginResponse = it.body()  ?: throw Exception("Response body is null")
                    if (response.data != null){
                        PreferenceManager.loginemail = email
                        PreferenceManager.loginToken =  response.data?.token ?: ""
                        PreferenceManager.loginauthData =  response.data?.auth_data ?: ""
                        PreferenceManager.isLoginin = true
//                        saveLoginMailToken(this@LoginActivity,email)
//                        saveLoginToken(this@LoginActivity, response.data.token ?: "")
//                        saveLoginAuthData(this@LoginActivity, response.data.auth_data ?: "")
//                        saveLoginStatus(this@LoginActivity,true)
                        //获取用户信息

                        withContext(Dispatchers.Main) {
                            val intent = Intent(this@RegisterActivity, MainActivity::class.java)
                            intent.flags =
                                Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
                            startActivity(intent)
                            finish()  // It
                        }
                    }
                }else{
                    // Handle error response, even if it's 422
                    try {
                        val errorResponse = it?.errorBody()?.string()  ?: ""
                        val errorJson = JSONObject(errorResponse)
                        val message = errorJson.optString("message")
                        // Process the error message or show it to the user
                        if (!message.isNullOrEmpty()) {
                            withContext(Dispatchers.Main) {
                                Toast.makeText(this@RegisterActivity, "注册失败：${message}", Toast.LENGTH_LONG).show()
                            }
                        }
                        println( "Message: $message,  ")
                    } catch (e: JSONException) {
                        // Handle JSON parsing error
                        withContext(Dispatchers.Main) {
                            Toast.makeText(this@RegisterActivity, "注册失败：${e.message}", Toast.LENGTH_LONG).show()
                        }
                    }
                }
            }

        }


    }
}

