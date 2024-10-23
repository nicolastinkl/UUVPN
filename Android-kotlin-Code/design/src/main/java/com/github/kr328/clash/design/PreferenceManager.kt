package com.github.kr328.clash.design

import android.content.Context
import android.content.SharedPreferences
import androidx.lifecycle.LiveData

object PreferenceManager {
    private const val PREF_NAME = "app_preferences"


     private lateinit var prefs: SharedPreferences

    fun init(context: Context) {
        prefs = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE)
    }

     var selectnodeName: String
        get() = prefs.getString("selectnodeName", "") ?: "自动选择"
        set(value) {
            prefs.edit().putString("selectnodeName", value).apply()
        }
}



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