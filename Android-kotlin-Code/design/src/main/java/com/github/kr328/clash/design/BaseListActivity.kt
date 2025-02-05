package com.github.kr328.clash.design

import android.annotation.SuppressLint
import android.content.res.Configuration
import android.os.Build
import android.os.Bundle
import android.view.View
import android.view.WindowManager
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout
import com.github.kr328.clash.common.compat.isAllowForceDarkCompat
import com.github.kr328.clash.common.compat.isLightNavigationBarCompat
import com.github.kr328.clash.common.compat.isLightStatusBarsCompat
import com.github.kr328.clash.common.compat.isSystemBarsTranslucentCompat
import com.github.kr328.clash.design.adapter.OrdersDataAdapter
import com.github.kr328.clash.design.adapter.PlanDataAdapter
import com.github.kr328.clash.design.adapter.TicketDetailAdapter
import com.github.kr328.clash.design.adapter.TicketsDataAdapter
import com.github.kr328.clash.design.databinding.ActivityBaseListBinding
import com.github.kr328.clash.design.databinding.DesignSettingsCommonBinding
import com.github.kr328.clash.design.ui.DayNight
import com.github.kr328.clash.design.ui.Surface
import com.github.kr328.clash.design.util.applyFrom
import com.github.kr328.clash.design.util.layoutInflater
import com.github.kr328.clash.design.util.resolveThemedBoolean
import com.github.kr328.clash.design.util.resolveThemedColor
import com.github.kr328.clash.design.util.root
import com.github.kr328.clash.design.util.setOnInsertsChangedListener
import com.github.kr328.clash.design.view.ActivityBarLayout
import com.github.kr328.clash.network.OrderData
import com.github.kr328.clash.network.PlanData
import com.github.kr328.clash.network.TicketMessage
import com.github.kr328.clash.network.TicketsData
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

// 这是一个通用的 Activity 用于加载和刷新列表数据
abstract class BaseListActivity<T> : AppCompatActivity() {

    private var dayNight: DayNight = DayNight.Day

    val surface = Surface()

    private lateinit var recyclerView: RecyclerView
    lateinit var swipeRefreshLayout: SwipeRefreshLayout
    private lateinit var adapter: RecyclerView.Adapter<*>

    private var currentPage = 1
    private var isLoading = false
    // 子类需要实现这些方法
    abstract fun createAdapter(): RecyclerView.Adapter<*>
    abstract suspend fun loadData(page: Int, callback: (List<T>?, Throwable?) -> Unit)


    abstract  fun onCreate()

    var mainBinding: ActivityBaseListBinding? = null

    private var onRightClick: (() -> Unit)? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        applyDayNight()


        val binding = ActivityBaseListBinding
            .inflate(this.layoutInflater, this.root, false)

        binding.activityBarLayout.applyFrom(this)

        setContentView(binding.root)

        binding.surface = surface

        mainBinding = binding

        recyclerView = binding.baseRecyclerView
        swipeRefreshLayout =binding.baseSwipeRefreshLayout

        recyclerView.layoutManager = LinearLayoutManager(this)
        adapter = createAdapter()
        recyclerView.adapter = adapter


        onCreate()

        this.window.decorView.setOnInsertsChangedListener {
            if (surface.insets != it) {
                surface.insets = it
            }
        }


        swipeRefreshLayout.setOnRefreshListener {

            CoroutineScope(Dispatchers.IO).launch {
                withContext(Dispatchers.Main) {
                    swipeRefreshLayout.isRefreshing = true
                }
                loadData(1) { data, error ->
                    swipeRefreshLayout.isRefreshing = false
                    if (error != null) {
                        showError(error)
                    } else {
                        swipeRefreshLayout.isRefreshing = false
                        initList(data)
                    }
                }
            }
        }
        refereshData()

    }

    fun requestRightClick(){
        // 使用安全调用，确保在 onRightClick 不为 null 时执行
        println("requestRightClick...")
        onRightClick?.invoke()
        println("requestRightClick invoke()...")
    }

    fun setRightButtonVisible(onRightClickEvent: (() -> Unit) ){

        println("setRightButtonVisible...")
        mainBinding?.rightButton?.visibility = View.VISIBLE
        onRightClick = onRightClickEvent
        mainBinding?.rightButton?.setOnClickListener {
            requestRightClick()
        }
    }

    fun refereshData(){
        CoroutineScope(Dispatchers.IO).launch {
            // 加载数据

            withContext(Dispatchers.Main) {
                swipeRefreshLayout.isRefreshing = true
            }
            loadData(currentPage) { data, error ->
                if (error != null) {
                    swipeRefreshLayout.isRefreshing = false
                    showError(error)
                } else {
                    swipeRefreshLayout.isRefreshing = false
                    initList(data)
                }
            }
        }
    }


    fun referTitle(tit: String){
        title = tit
        mainBinding?.activityBarLayout?.applyFrom(this)
    }
    private fun applyDayNight(config: Configuration = resources.configuration) {
        // val dayNight =  theme.applyStyle(R.style.AppThemeLight, true) //默认白天模式

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

    @SuppressLint("NotifyDataSetChanged")
    private fun initList(data: List<T>?) {

        if (data.isNullOrEmpty()) {
            runOnUiThread {
                Toast.makeText(this, "没有更多数据", Toast.LENGTH_SHORT).show()
            }
        } else {
            // 更新列表
            runOnUiThread {
                // 更新适配器的数据

                when (adapter) {
                    is PlanDataAdapter -> {
                        // 使用 PlanDataAdapter 类型进行操作
                        val planDataAdapter = adapter as  PlanDataAdapter
                        // 执行 PlanDataAdapter 的操作
                        planDataAdapter.setData(data as List<PlanData>)
                    }


                    is OrdersDataAdapter -> {
                        // 使用 PlanDataAdapter 类型进行操作
                        val ordersDataAdapter = adapter as  OrdersDataAdapter
                        // 执行 PlanDataAdapter 的操作
                        ordersDataAdapter.setData(data as List<OrderData>)

                    }

                    is TicketsDataAdapter->{
                        val ordersDataAdapter = adapter as  TicketsDataAdapter
                        ordersDataAdapter.setData(data as List<TicketsData>)
                    }

                    is TicketDetailAdapter ->{

                        val ordersDataAdapter = adapter as  TicketDetailAdapter
                        ordersDataAdapter.setData(data as List<TicketMessage>)

                    }
                    else -> {
                        // 处理不匹配的适配器类型
                        println( "Unknown adapter type.")
                    }
                }


                val subscriptionAdapter = adapter as? PlanDataAdapter

                if ( subscriptionAdapter != null ){
                    subscriptionAdapter.setData(data as List<PlanData>)  // 假设你实现了一个 setData 方法来更新适配器的数据
                }

                adapter.notifyDataSetChanged()
            }
        }

    }

    @SuppressLint("NotifyDataSetChanged")
    private fun updateList(data: List<T>?) {

            if (data.isNullOrEmpty()) {
                runOnUiThread {
                    Toast.makeText(this, "没有更多数据", Toast.LENGTH_SHORT).show()
                }
            } else {
                // 更新列表
                runOnUiThread {
                    // 更新适配器的数据
                   // adapter.addData(data)  // 假设你实现了一个 setData 方法来更新适配器的数据

                    adapter.notifyDataSetChanged()
                }
            }

    }

    private fun showError(error: Throwable) {
        runOnUiThread {
            Toast.makeText(this, "加载失败: ${error.message}", Toast.LENGTH_SHORT).show()
        }
    }

    // 调用此方法来处理列表项点击
//    fun onListItemClicked(item: T) {
//        onItemClicked(item)
//    }
}
