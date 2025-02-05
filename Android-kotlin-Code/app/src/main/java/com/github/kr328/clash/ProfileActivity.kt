package com.github.kr328.clash
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.os.PersistableBundle
import androidx.appcompat.app.AppCompatActivity
import com.github.kr328.clash.common.util.intent
import com.github.kr328.clash.common.util.ticker
import com.github.kr328.clash.core.bridge.Bridge
import com.github.kr328.clash.design.MainDesign
import com.github.kr328.clash.design.PreferenceManager
import com.github.kr328.clash.design.ProfileDesign
import com.github.kr328.clash.design.ui.ToastDuration
import com.github.kr328.clash.design.util.showCustomDialog
import com.github.kr328.clash.util.stopClashService
import com.github.kr328.clash.util.withProfile
import com.github.kr328.clash.utity.LoadingDialog
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch
import kotlinx.coroutines.selects.select
import kotlinx.coroutines.withContext
import java.util.concurrent.TimeUnit


class ProfileActivity  : BaseActivity<ProfileDesign>()  {

    private suspend fun queryAppVersionName(): String {
        return withContext(Dispatchers.IO) {
            packageManager.getPackageInfo(packageName, 0).versionName //+ "\n" + Bridge.nativeCoreVersion().replace("_", "-")

        }
    }

    override suspend fun main() {

        PreferenceManager.init(this)

        val design = ProfileDesign(this)
        setContentDesign(design)

        design.requestdataDisible()

        val ticker = ticker(TimeUnit.SECONDS.toMillis(1))
        design.queryVersion(queryAppVersionName())
        while (isActive) {
            select<Unit> {
                events.onReceive {
                    println("events  : " + it.name)
                }
                design.requests.onReceive {
                    println("requests  : " + it.name)
                    when (it) {

                        ProfileDesign.Request.OpenBuyPlan -> startActivity(PlansActivity::class.intent)
                        ProfileDesign.Request.OpenMyOrders -> startActivity(MyOrdersActivity::class.intent)
                        ProfileDesign.Request.OpenMyBlance -> startActivity(SubmitOrderActivity::class.intent)
                        ProfileDesign.Request.OpenMyInvites ->startActivity(InvitationActivity::class.intent)
                        ProfileDesign.Request.OpenCustomView ->{ startActivity(H5WebActivity::class.intent) }
                            /*try {


                                withContext(Dispatchers.Main) {
                                    val intent = Intent(Intent.ACTION_VIEW)
                                    intent.addCategory(Intent.CATEGORY_BROWSABLE);
                                    intent.setData(Uri.parse(PreferenceManager.getConfigFromPreferences(this@ProfileActivity)?.telegramurl))
                                    startActivity(intent)
                                }
                            } catch (e: Exception) {
                                design.showToast("当前手机未安装浏览器",ToastDuration.Long)

                            } */

                        ProfileDesign.Request.OpenLogout -> {
                            showCustomDialog(
                                title = "提示",
                                message = "确定要退出吗？",
                                positiveButtonText = "确定",
                                negativeButtonText = "取消",
                                onPositiveClick = {
                                    LoadingDialog.show(this@ProfileActivity, "正在退出...")
                                    // 执行确认操作
                                    stopClashService()
                                    // 清理缓存，清除节点信息，切换界面
                                    launch {
                                        withProfile {
                                            var allProfiles = queryAll()
                                            println(allProfiles)
                                            if (allProfiles.isNotEmpty() && allProfiles.count() > 0) {
                                                allProfiles.forEach {
                                                    delete(it.uuid)
                                                    println("删除节点：${it.source}")
                                                }
                                                //删除所有节点
                                            }
                                        }
                                    }
                                    PreferenceManager.clearData()

                                    //2s 后执行
// 在协程作用域中执行
                                    GlobalScope.launch(Dispatchers.Main) {
                                        delay(2000)  // 协程延迟2000毫秒（2秒）
                                        println("协程中的延迟执行")
                                        LoadingDialog.hide()
                                        startActivity(LoginActivity::class.intent)
                                        finish()

                                    }

                                },
                                onNegativeClick = {
                                    // 执行取消操作
                                }
                            )

                        }
                        ProfileDesign.Request.OpenGSettings -> {
                            //查看是否有更新
                            design.showToast("当前版本是最新版本",ToastDuration.Long)
                        }//  startActivity(NetworkSettingsActivity::class.intent)
                        ProfileDesign.Request.OpenMyGongdan ->startActivity(GongdanActivity::class.intent)
                        ProfileDesign.Request.OpenCustomViewIPtest -> startActivity(H5WebActivity::class.intent.putExtra("url","https://ipcelou.com"))
                        ProfileDesign.Request.OpenCustomViewSpeed ->  startActivity(H5WebActivity::class.intent.putExtra("url","https://fast.com/"))
                    }
                }
            }
        }
    }

}
