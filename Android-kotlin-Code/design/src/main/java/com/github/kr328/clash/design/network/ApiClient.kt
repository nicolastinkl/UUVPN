package com.github.kr328.clash.network

import android.content.Context
import com.github.kr328.clash.design.PreferenceManager
import com.google.gson.GsonBuilder
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.util.concurrent.TimeUnit


object ApiClient {
    private val okHttpClient = OkHttpClient.Builder()
        .addInterceptor(HttpLoggingInterceptor().apply {
            level = HttpLoggingInterceptor.Level.BODY
        })
        .build()

    // Lazy initialization of configURL
    private val configURL: String by lazy {
        PreferenceManager.baseURL
    }


    // Retrofit initialization
    val retrofit: Retrofit by lazy {
        Retrofit.Builder()
            .baseUrl(configURL)
            .addConverterFactory(GsonConverterFactory.create())
            .client(okHttpClient)
            .build()
    }
}

object ApiClientConfig {
    private const val ConfigURL = "https://api.xxxx.com/api/" // BASE 请求配置文件地址 见说明文档
    //const val ConfigNodeURL = "https://api.xxxx.com/api/parseyamlclash.php?target=clashmeta&url=" //通过香港服务器转接一次Clash转化的订阅地址
    const val ConfigNodeURL = ""

    private val okHttpClient = OkHttpClient.Builder()
        .addInterceptor(HttpLoggingInterceptor().apply {
            level = HttpLoggingInterceptor.Level.BODY
        })
        .build()

    val retrofit: Retrofit = Retrofit.Builder()
        .baseUrl(ConfigURL)
        .addConverterFactory(GsonConverterFactory.create())
        .client(okHttpClient)
        .build()
}
