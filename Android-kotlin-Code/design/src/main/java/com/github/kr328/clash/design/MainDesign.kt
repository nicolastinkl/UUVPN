package com.github.kr328.clash.design

import android.content.Context
import android.content.res.ColorStateList
import android.graphics.Color
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.View
import androidx.appcompat.app.AlertDialog
import com.airbnb.lottie.LottieAnimationView
import com.github.kr328.clash.common.util.ticker
import com.github.kr328.clash.core.Clash
import com.github.kr328.clash.core.model.TunnelState
import com.github.kr328.clash.core.util.trafficTotal
import com.github.kr328.clash.design.databinding.DesignAboutBinding
import com.github.kr328.clash.design.databinding.DesignMainBinding
import com.github.kr328.clash.design.util.layoutInflater
import com.github.kr328.clash.design.util.resolveThemedColor
import com.github.kr328.clash.design.util.root
import com.google.android.material.tabs.TabLayoutMediator
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.coroutines.withTimeout
import java.util.concurrent.TimeUnit

class MainDesign(context: Context) : Design<MainDesign.Request>(context) {
    enum class Request {
        ToggleStatus,
        OpenProxy,
        OpenProfiles,
        OpenProviders,
        OpenLogs,
        OpenSettings,
        OpenHelp,
        OpenAbout,
        OpenSettingsDIY,
        OpenSettingsKEFU,
        OpenModeDirect,
        OpenModeGlobal,
        OpenModeRule,
    }

    private val binding = DesignMainBinding
        .inflate(context.layoutInflater, context.root, false)

    override val root: View
        get() = binding.root

    suspend fun setProfileName(name: String?) {
        withContext(Dispatchers.Main) {
            binding.profileName = name
        }

    }

    suspend fun setSelectNodeName(name: String?) {
        withContext(Dispatchers.Main) {
            binding.selectnodeName = name
        }
    }

    suspend fun setClashRunning(running: Boolean) {
        withContext(Dispatchers.Main) {
            binding.clashRunning = running
            if (running){
                binding.connectionButton.setAnimation("51a05581.json")

            }else{
                binding.connectionButton.setAnimation("1d2a0fe5.json")
            }
        }
    }

    suspend fun setForwarded(value: Long) {
        withContext(Dispatchers.Main) {
            binding.forwarded = value.trafficTotal()
        }
    }

    suspend fun setMode(mode: TunnelState.Mode) {
        withContext(Dispatchers.Main) {
            binding.mode = when (mode) {
                TunnelState.Mode.Direct -> context.getString(R.string.direct_mode)
                TunnelState.Mode.Global -> context.getString(R.string.global_mode)
                TunnelState.Mode.Rule -> context.getString(R.string.rule_mode)
                else -> context.getString(R.string.rule_mode)
            }

            when (mode) {
                TunnelState.Mode.Direct -> binding.modeSelectionbutton1.backgroundTintList =  ColorStateList.valueOf(Color.parseColor("#2b9a45"))
                TunnelState.Mode.Global -> binding.modeSelectionbutton2.backgroundTintList =  ColorStateList.valueOf(Color.parseColor("#2b9a45"))
                TunnelState.Mode.Rule -> binding.modeSelectionbutton3.backgroundTintList =  ColorStateList.valueOf(Color.parseColor("#2b9a45"))
                else -> binding.modeSelectionbutton3.backgroundTintList =  ColorStateList.valueOf(Color.parseColor("#2b9a45"))
            }


        }
    }

    suspend fun setHasProviders(has: Boolean) {
        withContext(Dispatchers.Main) {
            binding.hasProviders = has
        }
    }

    suspend fun showAbout(versionName: String) {
        withContext(Dispatchers.Main) {
            val binding = DesignAboutBinding.inflate(context.layoutInflater).apply {
                this.versionName = versionName
            }

            AlertDialog.Builder(context)
                .setView(binding.root)
                .show()
        }
    }

    init {
        binding.self = this

        binding.colorClashStarted = context.resolveThemedColor(R.attr.colorPrimary)
        binding.colorClashStopped = context.resolveThemedColor(R.attr.colorClashStopped)
    }

    fun request(request: Request) {
        requests.trySend(request)
    }

    suspend fun startAutoScroll(viewPager2: androidx.viewpager2.widget.ViewPager2,nextItem: Int){

        withContext(Dispatchers.Main) {
            viewPager2.setCurrentItem(nextItem, true)
        }
    }

    suspend fun startBannsers() {
        withContext(Dispatchers.Main) {
            //sart ad bannsers
            val viewPager2  = binding.adBanner
            val tabLayout = binding.tabLayout
            // 创建图片资源列表
            val imageList = listOf(
                R.drawable.ad_banner,
                R.drawable.ad_banner2,
                R.drawable.ad_banner3
            )


            // 设置适配器
            val adapter = ImageSliderAdapter(imageList)
            viewPager2.adapter = adapter
            // 设置 TabLayoutMediator 来同步 ViewPager2 和 TabLayout
            TabLayoutMediator(tabLayout, viewPager2) { tab, position ->
                // Tab 的自定义逻辑可以放在这里
            }.attach()


            binding.modeSelection.addOnButtonCheckedListener { group, checkedId, isChecked ->

//                binding.modeSelectionbutton1.setBackgroundColor(Color.parseColor("#383838"))
//                binding.modeSelectionbutton2.setBackgroundColor(Color.parseColor("#383838"))
//                binding.modeSelectionbutton3.setBackgroundColor(Color.parseColor("#383838"))


                // Reset all buttons to default background tint
                binding.modeSelectionbutton1.backgroundTintList = ColorStateList.valueOf(Color.parseColor("#383838"))
                binding.modeSelectionbutton2.backgroundTintList = ColorStateList.valueOf(Color.parseColor("#383838"))
                binding.modeSelectionbutton3.backgroundTintList = ColorStateList.valueOf(Color.parseColor("#383838"))


                when (checkedId) {
                    R.id.modeSelectionbutton1 -> {
                        request(Request.OpenModeDirect)
                        binding.modeSelectionbutton1.backgroundTintList =  ColorStateList.valueOf(Color.parseColor("#2b9a45"))
                    }

                    R.id.modeSelectionbutton2 -> {

                        request(Request.OpenModeGlobal)
                        binding.modeSelectionbutton2.backgroundTintList =  ColorStateList.valueOf(Color.parseColor("#2b9a45"))
                    }

                    R.id.modeSelectionbutton3 -> {
                        request(Request.OpenModeRule)
                        binding.modeSelectionbutton3.backgroundTintList =  ColorStateList.valueOf(Color.parseColor("#2b9a45"))
                    }
                }
            }
        }



    }




}