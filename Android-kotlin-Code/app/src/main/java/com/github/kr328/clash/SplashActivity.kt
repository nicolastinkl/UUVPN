package com.github.kr328.clash

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.appcompat.app.AppCompatActivity
import com.github.kr328.clash.common.util.intent
import com.github.kr328.clash.design.PreferenceManager
import com.github.kr328.clash.design.databinding.ActivityLoginBinding
import com.github.kr328.clash.design.databinding.ActivitySplashBinding
import com.github.kr328.clash.design.util.root
import com.github.kr328.clash.network.ApiService


class SplashActivity : AppCompatActivity() {



    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val binding = ActivitySplashBinding
            .inflate(this.layoutInflater, this.root, false)

        setContentView(binding.root)
        PreferenceManager.init(this)

        Handler(Looper.getMainLooper()).postDelayed({
            // Hide the loading indicator
            startActivity(LoginActivity::class.intent)
            finish()

        }, 1000) // Simulating a network delay


    }
}
