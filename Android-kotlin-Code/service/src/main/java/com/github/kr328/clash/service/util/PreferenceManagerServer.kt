package com.github.kr328.clash.service.util

import android.content.Context
import android.content.SharedPreferences



object PreferenceManagerServer {
    private const val PREF_NAME = "app_preferences"

    private lateinit var prefs: SharedPreferences

    fun init(context: Context) {
        prefs = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE or Context.MODE_MULTI_PROCESS)

    }

    var modeName: String
        get() = prefs.getString("modeName", "Rule") ?: "Rule"
        set(value) {
            prefs.edit().putString("modeName", value).apply()
        }

    var selectnodeName: String
        get() = prefs.getString("selectnodeName", "自动选择") ?: "自动选择"
        set(value) {
            prefs.edit().putString("selectnodeName", value).apply()
        }
}
