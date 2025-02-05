package com.github.kr328.clash.design

import android.content.Context
import android.net.Uri
import android.os.Build
import android.view.View
import android.webkit.WebChromeClient
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient
import com.github.kr328.clash.design.ProxyDesign.Request
import com.github.kr328.clash.design.databinding.ActivityH5webviewBinding
import com.github.kr328.clash.design.databinding.DesignSettingsCommonBinding
import com.github.kr328.clash.design.util.applyFrom
import com.github.kr328.clash.design.util.layoutInflater
import com.github.kr328.clash.design.util.root


class H5WebViewDesign(
    context: Context,
    openLink: (Uri) -> Unit,
) : Design<H5WebViewDesign.Request>(context) {
    private val binding = ActivityH5webviewBinding
        .inflate(context.layoutInflater, context.root, false)

    enum class Request {
        OpenURL,ReferWebView
    }

    override val root: View
        get() = binding.root

    init {
        binding.surface = surface

        binding.activityBarLayout.applyFrom(context)


        binding.webview.webViewClient= WebViewClient()//目标的网页仍然在当前WebView中显

        binding.webview.settings.apply {
            javaScriptEnabled = true // 启用 JavaScript
            domStorageEnabled = true // 启用 DOM 存储
            loadWithOverviewMode = true
            useWideViewPort = true
            allowContentAccess = true
            allowFileAccess = true
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            binding.webview.settings.mixedContentMode = WebSettings.MIXED_CONTENT_ALWAYS_ALLOW
        }




        binding.webview.canGoBack()
        // 设置 WebChromeClient 以更新加载进度
        binding.webview.webChromeClient = object : WebChromeClient() {
            override fun onProgressChanged(view: WebView?, newProgress: Int) {
                super.onProgressChanged(view, newProgress)

                // 显示进度条
                if (newProgress < 100) {
                    binding.progressBar.visibility = View.VISIBLE
                    binding.progressBar.progress = newProgress
                } else {
                    // 隐藏进度条
                    binding.progressBar.visibility = View.GONE
                }
            }
        }


    }

    fun requestRefereshTesting() {
//        urlTesting = true
        binding.webview.reload()
    }

    fun breaseURL(url: String){

        binding.webview.loadUrl(url)//.将网址传入

    }

    fun refereshApplyFrom(){
        binding.activityBarLayout.applyFrom(context)
    }
}

