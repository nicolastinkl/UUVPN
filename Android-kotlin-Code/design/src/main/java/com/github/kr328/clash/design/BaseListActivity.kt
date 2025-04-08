package com.github.kr328.clash.design

import android.annotation.SuppressLint
import android.content.res.Configuration
import android.os.Build
import android.os.Bundle
import android.view.View
// import android.view.WindowManager
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
// import com.github.kr328.clash.design.databinding.DesignSettingsCommonBinding
import com.github.kr328.clash.design.ui.DayNight
import com.github.kr328.clash.design.ui.Surface
import com.github.kr328.clash.design.util.applyFrom
// import com.github.kr328.clash.design.util.layoutInflater
import com.github.kr328.clash.design.util.resolveThemedBoolean
import com.github.kr328.clash.design.util.resolveThemedColor
import com.github.kr328.clash.design.util.root
import com.github.kr328.clash.design.util.setOnInsertsChangedListener
// import com.github.kr328.clash.design.view.ActivityBarLayout
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

   
    /**
     * 初始化列表数据。
     * 如果数据为空，显示提示信息；否则，在UI线程上更新适配器数据。
     *
     * @param data 要显示的数据列表，可能为null
     */
    @SuppressLint("NotifyDataSetChanged")
    private fun initList(data: List<T>?) {
        if (data.isNullOrEmpty()) {
            showEmptyDataToast()
        } else {
            updateAdapterDataOnUiThread(data)
        }
    }

    /**
     * 在UI线程上显示"没有更多数据"的Toast提示。
     */
    private fun showEmptyDataToast() {
        runOnUiThread {
            Toast.makeText(this, "没有更多数据", Toast.LENGTH_SHORT).show()
        }
    }

    /**
     * 在UI线程上更新适配器数据。
     * 这个方法作为一个中间层，避免在runOnUiThread的lambda中直接捕获外部变量。
     *
     * @param data 要更新到适配器的数据列表
     */
    private fun updateAdapterDataOnUiThread(data: List<T>) {
        runOnUiThread {
            doUpdateAdapterData(data)
        }
    }

    /**
     * 执行实际的适配器数据更新操作。
     * 根据适配器类型，将数据设置到相应的适配器中，并通知数据集变化。
     *
     * @param data 要更新到适配器的数据列表
     */
    @SuppressLint("NotifyDataSetChanged")
    @Suppress("UNCHECKED_CAST")
    private fun doUpdateAdapterData(data: List<T>) {
        when (adapter) {
            is PlanDataAdapter -> (adapter as PlanDataAdapter).setData(data as List<PlanData>)
            is OrdersDataAdapter -> (adapter as OrdersDataAdapter).setData(data as List<OrderData>)
            is TicketsDataAdapter -> (adapter as TicketsDataAdapter).setData(data as List<TicketsData>)
            is TicketDetailAdapter -> (adapter as TicketDetailAdapter).setData(data as List<TicketMessage>)
            else -> println("Unknown adapter type.")
        }
        adapter.notifyDataSetChanged()
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
