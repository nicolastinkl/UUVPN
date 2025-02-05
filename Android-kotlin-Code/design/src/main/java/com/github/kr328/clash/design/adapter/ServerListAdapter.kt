package com.github.kr328.clash.design.adapter

import android.annotation.SuppressLint
import android.graphics.Color
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.github.kr328.clash.core.model.Proxy
import com.github.kr328.clash.design.R
import com.github.kr328.clash.design.adapter.ProxyAdapter.Holder
import com.github.kr328.clash.design.component.ProxyViewConfig
import com.github.kr328.clash.design.component.ProxyViewState
import com.github.kr328.clash.design.model.ProxyPageState
import com.github.kr328.clash.design.model.ProxyState
import com.github.kr328.clash.design.ui.Surface
import com.github.kr328.clash.design.util.firstVisibleView
import com.github.kr328.clash.design.util.invalidateChildren
import com.github.kr328.clash.design.util.swapDataSet
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.withContext
import okhttp3.internal.filterList

//private val stateChanged: (Int) -> Unit,
class ServerListAdapter(private val surface: Surface,
                        private val config: ProxyViewConfig,
                        private val clicked: (String) -> Unit,) :
    RecyclerView.Adapter<ServerListAdapter.ViewHolder>() {


    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val flag: ImageView = view.findViewById(R.id.country_flag)
        val vpnnodemainid:View =  view.findViewById(R.id.vpnnodemainid)
        val serverInfo: TextView = view.findViewById(R.id.server_info)
        val serverLimit: TextView = view.findViewById(R.id.server_limit)
        val signal: ImageView = view.findViewById(R.id.signal_strength)
        val latency: TextView = view.findViewById(R.id.latency)
    }


    companion object {
        private const val HEADER_VIEW_TYPE = 0
        private const val ITEM_VIEW_TYPE = 1
    }

    override fun getItemViewType(position: Int): Int {
        // 判断是否是第一行，如果是，返回 HEADER_VIEW_TYPE，否则返回 ITEM_VIEW_TYPE
        return if (position == 0) HEADER_VIEW_TYPE else ITEM_VIEW_TYPE
    }

    var urlTesting: Boolean = true

    var servers: List<ProxyViewState> = emptyList()

    var selectable: Boolean = false

    suspend fun updateAdapter(
        position: Int,
        proxies: List<Proxy>,
        selectable: Boolean,
        parent: ProxyState,
        links: Map<String, ProxyState>
    ) {

        var newlistProxy =  mutableListOf<Proxy>()
      //  newlistProxy.add(Proxy("智能连接","智能连接","自动切换速度最快的节点",Proxy.Type.Unknown,0))
        newlistProxy.addAll(proxies)

        val states = withContext(Dispatchers.Default) {
            newlistProxy.map {
                val link = if (it.type.group) links[it.name] else null
                ProxyViewState(config, it, parent, link)
            }
        }

       /* states.forEach {
            println(">>>>> ${it.proxy.title}  ${it.proxy.subtitle}    ${it.proxy.type.name}  ${it.proxy.delay}")
        }*/
        val newstates =  states.filterNot {
            it.proxy.title.uppercase() == "DIRECT"
            || it.proxy.title.uppercase() == "REJECT"
            || it.proxy.subtitle  == "Selector"
            || it.proxy.title.contains("流量")
                    || it.proxy.title.contains("故障转移")
                    || it.proxy.title.contains("套餐到期")
                    || it.proxy.title.contains("节点异常")
            || it.proxy.title.contains("续费")
            || it.proxy.title.contains("充值")
            || it.proxy.title.contains("官网")
            || it.proxy.title.contains("剩余")
        }


        this.swapDataSet(this::servers, newstates, false)

        withContext(Dispatchers.Main) {
            requestRedrawVisible()
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    fun requestRedrawVisible() {
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.server_item_layout, parent, false)
        return ViewHolder(view)
    }

    val countryMap = mapOf(
        "美国" to "us",
        "United States" to "us",
        "中国" to "zh",
        "China" to "zh",
        "香港" to "hk",
        "Hong" to "hk",
        "日本" to "jp",
        "Japan" to "jp",
        "新加坡" to "sg",
        "Singapore" to "sg",
        "越南" to "vn",
        "Vietnam" to "vn",
        "马来西亚" to "my",
        "Malaysia" to "my",
        "泰国" to "th",
        "Thailand" to "th",
        "韩国" to "kr",
        "South Korea" to "kr",
        "巴西" to "br",
        "Brazil" to "br",
        "印度" to "in",
        "India" to "in",
        "智利" to "cl",
        "Chile" to "cl",
        "迪拜" to "ae",
        "United Arab" to "ae",
        "德国" to "de",
        "Germany" to "de",
        "法国" to "fr",
        "France" to "fr",
        "英国" to "gb",
        "Great Britain" to "gb",
        "意大利" to "it",
        "Italy" to "it",
        "澳大利亚" to "au",
        "Australia" to "au",
        "土耳其" to "tr",
        "台湾" to "tw",
        "Turkey" to "tr"
        // 添加其他国家映射
    )

    fun getCountryCodeFromLog(logLine: String): String? {
        // 遍历 countryMap，找到匹配的国家名称
        for ((countryName, countryCode) in countryMap) {
            if (logLine.contains(countryName)) {
                return countryCode
            }
        }
        return "" // 没有匹配的国家名称
    }

    var state: ProxyViewState? = null

    var selectableView: ViewHolder? = null
    var selectableData: ProxyViewState? = null

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {

            val server = servers[position]
            server.update(true)

            holder.apply {
                state = server

            }

            if (server.selected){
                selectableView = holder
                selectableData = server
            }
            val flog_name = getCountryCodeFromLog(server.title) ?: ""
            val resourceId = holder.itemView.context.resources.getIdentifier("country_flag_"+flog_name, "drawable", holder.itemView.context.packageName)

            // 检查资源 ID 是否有效
            if (resourceId != 0) {
                holder.flag.setImageResource(resourceId)
            }else{
                val aiicon = holder.itemView.context.resources.getIdentifier("icon_ai", "drawable", holder.itemView.context.packageName)
                holder.flag.setImageResource(aiicon)
            }

            holder.serverInfo.text = server.title

            holder.serverInfo.text = server.title

            if (server.title == "自动选择"){
                holder.serverLimit.text = "智能匹配最优路线"
            }else{
                holder.serverLimit.text = server.subtitle
            }

            //holder.signal.setImageResource(server.signalRes)

            if ( server.proxy.delay > 5000){
                val resourcelow = holder.itemView.context.resources.getIdentifier("ic_signal_no", "drawable", holder.itemView.context.packageName)
                holder.signal.setImageResource(resourcelow)
            }else if (server.proxy.delay >= 1000  && server.proxy.delay < 5000){
                val resourcelow = holder.itemView.context.resources.getIdentifier("ic_signal_low", "drawable", holder.itemView.context.packageName)
                holder.signal.setImageResource(resourcelow)
            }else if (server.proxy.delay > 500 && server.proxy.delay < 1000){
                val resourcelow = holder.itemView.context.resources.getIdentifier("ic_signal_two", "drawable", holder.itemView.context.packageName)
                holder.signal.setImageResource(resourcelow)
            }else if (server.proxy.delay < 500 && server.proxy.delay > 300){
                val resourcelow = holder.itemView.context.resources.getIdentifier("ic_signal_three", "drawable", holder.itemView.context.packageName)
                holder.signal.setImageResource(resourcelow)
            }else{
                val resourcelow = holder.itemView.context.resources.getIdentifier("ic_signal_center", "drawable", holder.itemView.context.packageName)
                holder.signal.setImageResource(resourcelow)
            }

            if (server.delayText.length > 0){
                holder.latency.text =  " ${server.delayText}ms"
            }else{
                holder.latency.text =  " 0ms"
            }

            if (server.selected)
            {
                holder.serverInfo.setTextColor(Color.parseColor("#2a9843"))
            }else{
                holder.serverInfo.setTextColor(Color.parseColor("#888888"))
            }

            val current = server
            holder.vpnnodemainid.setOnClickListener {
    //            selectable = true
    //            server.selected = true

                if (selectableView != null) {
                    if(selectableView == holder){
                        //do nothing
                        clicked(current.proxy.name)
                    }else{
                        //之前的设置为未选择
                        selectableData?.selected   = false

                        current.selected = true

                        selectableView = holder
                        selectableData = current
                        clicked(current.proxy.name)
                        current.update(true)

                    }
                }else
                {

                    current.selected = true

                    selectableView = holder
                    selectableData = current
                    clicked(current.proxy.name)
                    current.update(true)

                }
            }

    }

    override fun getItemCount(): Int = servers.size
}

