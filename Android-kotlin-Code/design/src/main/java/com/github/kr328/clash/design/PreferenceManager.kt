package com.github.kr328.clash.design

import android.content.Context
import android.content.SharedPreferences
import androidx.lifecycle.LiveData
import com.github.kr328.clash.network.ConfigResponse

object PreferenceManager {
    private const val PREF_NAME = "app_preferences"

    private lateinit var prefs: SharedPreferences

    fun init(context: Context) {
        prefs = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE or Context.MODE_MULTI_PROCESS)
    }

    fun clearData(){
        prefs.edit().clear().apply()
    }

    var cached_userSubscritedata: String
        get() = prefs.getString("cached_userSubscritedata", "") ?: ""
        set(value) {
            prefs.edit().putString("cached_userSubscritedata", value).apply()
        }

    var cache_timestamp: Long
        get() = prefs.getLong("cache_timestamp", 0) ?: 0
        set(value) {
            prefs.edit().putLong("cache_timestamp", value).apply()
        }
    var cached_data: String
        get() = prefs.getString("cached_data", "") ?: ""
        set(value) {
            prefs.edit().putString("cached_data", value).apply()
        }

    var selectnodeName: String
        get() = prefs.getString("selectnodeName", "自动选择") ?: "自动选择"
        set(value) {
            prefs.edit().putString("selectnodeName", value).apply()
        }

    var modeName: String
        get() = prefs.getString("modeName", "智能模式") ?: "智能模式"
        set(value) {
            prefs.edit().putString("modeName", value).apply()
        }

    var loginemail: String
        get() = prefs.getString("loginemail", "") ?: ""
        set(value) {
            prefs.edit().putString("loginemail", value).apply()
        }


    var loginToken: String
        get() = prefs.getString("loginToken", "") ?: ""
        set(value) {
            prefs.edit().putString("loginToken", value).apply()
        }

    var loginauthData: String
        get() = prefs.getString("loginauthData", "") ?: ""
        set(value) {
            prefs.edit().putString("loginauthData", value).apply()
        }

    var isLoginin: Boolean
        get() = prefs.getBoolean("isLoginin", false) ?: false
        set(value) {
            prefs.edit().putBoolean("isLoginin", value).apply()
        }

    var baseURL: String
        get() = prefs.getString("baseURL", "") ?: ""
        set(value) {
            prefs.edit().putString("baseURL", value).apply()
        }



    // Save data to prefserences
    fun saveConfigToPreferences( configResponse: ConfigResponse) {
        
        val editor = prefs.edit()

        // Store each field individually
        editor.putString("baseURL", configResponse.baseURL)
        editor.putString("baseDYURL", configResponse.baseDYURL)
        editor.putString("mainregisterURL", configResponse.mainregisterURL)
        editor.putString("paymentURL", configResponse.paymentURL)
        editor.putString("telegramurl", configResponse.telegramurl)
        editor.putString("kefuurl", configResponse.kefuurl)
        editor.putString("websiteURL", configResponse.websiteURL)
        editor.putString("crisptoken", configResponse.crisptoken)
        editor.putString("banners", configResponse.banners.joinToString(","))

        // Apply changes
        editor.apply()
    }

    // Retrieve data from SharedPreferences
    fun getConfigFromPreferences(context: Context): ConfigResponse? {
        

        // Retrieve each field individually
        val baseURL = prefs.getString("baseURL", null) ?: ""
        val baseDYURL = prefs.getString("baseDYURL", null) ?: ""
        val mainregisterURL = prefs.getString("mainregisterURL", null) ?: ""
        val paymentURL = prefs.getString("paymentURL", null) ?: ""
        val telegramurl = prefs.getString("telegramurl", null) ?: ""
        val kefuurl = prefs.getString("kefuurl", null) ?: ""
        val websiteURL = prefs.getString("websiteURL", null) ?: ""
        val crisptoken = prefs.getString("crisptoken", null) ?: ""
        val bannersString = prefs.getString("banners", null) ?: ""
        // If any field is null, return null (you can add your own null-check handling logic)
        // Convert the banners string back into a List
        val banners = bannersString.split(",").map { it.trim() } ?: emptyList()

        return   ConfigResponse(
            baseURL = baseURL,
            baseDYURL = baseDYURL,
            mainregisterURL = mainregisterURL,
            paymentURL = paymentURL,
            telegramurl = telegramurl,
            kefuurl = kefuurl,
            websiteURL = websiteURL,
            crisptoken = crisptoken,
            banners = banners, message = "", code = 1
        )
    }


}


//自动通知监听
class PreferenceLiveData(private val context: Context,) : LiveData<String>() {
    private var pref: SharedPreferences? = null
    private val key: String = "selectnodeName"
    private val defValue: String = "自动选择"
    private var listener = SharedPreferences.OnSharedPreferenceChangeListener { _, key ->
        if (key == this.key) {
            value = pref?.getString(key, defValue)
        }
    }

    override fun onActive() {
        super.onActive()
        pref = context.getSharedPreferences("app_preferences", Context.MODE_PRIVATE)
        pref?.registerOnSharedPreferenceChangeListener(listener)
        value = pref?.getString(key, defValue)
    }

    override fun onInactive() {
        super.onInactive()
        pref?.unregisterOnSharedPreferenceChangeListener(listener)
    }
}