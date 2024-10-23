package com.github.kr328.clash.design.adapter

import android.content.Context
import android.graphics.Color
import android.util.Log
import com.github.kr328.clash.design.component.ProxyView
import com.github.kr328.clash.design.component.ProxyViewConfig
/*
class ProxyAdapter(
    private val config: ProxyViewConfig,
    private val clicked: (String) -> Unit,
) : RecyclerView.Adapter<ProxyAdapter.Holder>() {
    class Holder(val view: ProxyView) : RecyclerView.ViewHolder(view)

    var selectable: Boolean = false
    var states: List<ProxyViewState> = emptyList()

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): Holder {
        return Holder(ProxyView(config.context, config))
    }

    override fun onBindViewHolder(holder: Holder, position: Int) {
        val current = states[position]

        holder.view.apply {
            state = current

            setOnClickListener {
                clicked(current.proxy.name)
            }

            val isSelector = selectable

            isFocusable = isSelector
            isClickable = isSelector

            current.update(true)
        }
    }

    override fun getItemCount(): Int {
        return states.size
    }
}
*/
import android.view.LayoutInflater
import android.view.View

import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.github.kr328.clash.design.R
import com.github.kr328.clash.design.component.ProxyViewState
import com.github.kr328.clash.design.databinding.DesignProxyBinding

class ProxyAdapter(
    private val config: ProxyViewConfig,
    private val clicked: (String) -> Unit,
) : RecyclerView.Adapter<ProxyAdapter.Holder>() {

//    class Holder(val binding: DesignProxyBinding) : RecyclerView.ViewHolder(binding.root)
    class Holder(view: View) : RecyclerView.ViewHolder(view) {
        val vpnnodemainid:View =  view.findViewById(R.id.vpnnodemainid)
        val proxyName: TextView = view.findViewById(R.id.proxy_name)
        val proxyLatency: TextView = view.findViewById(R.id.proxy_latency)
        val proxySubName:TextView = view.findViewById(R.id.proxy_subtitle)
        val selectnodeselectImage:ImageView = view.findViewById(R.id.nodeselectImage)


    }

    var selectable: Boolean = false
    var states: List<ProxyViewState> = emptyList()
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ProxyAdapter.Holder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.proxy_view_item, parent, false)

        return Holder(view)
    }

    var selectableView: Holder? = null
    var selectableData: ProxyViewState? = null
    override fun onBindViewHolder(holder: Holder, position: Int) {
        val current = states[position]
        holder.apply {

            proxyName.text = current.proxy.name
            proxySubName.text = current.proxy.subtitle

            if (current.proxy.delay > 10000){
                proxyLatency.text = "超时"
                proxyLatency.setTextColor(Color.parseColor("#e73f31"))
            }else if (current.proxy.delay > 500 && current.proxy.delay < 10000){
                proxyLatency.text = "${current.proxy.delay}ms"
                proxyLatency.setTextColor(Color.YELLOW)
            }else if (current.proxy.delay < 500 && current.proxy.delay > 300){
                proxyLatency.text = "${current.proxy.delay}ms"
                proxyLatency.setTextColor(Color.parseColor("#fab610"))
            }else{
                proxyLatency.text = "${current.proxy.delay}ms"
                proxyLatency.setTextColor(Color.parseColor("#2a9843"))
            }
            // 示例：延迟时间

            vpnnodemainid.setOnClickListener {

                if (selectableView != null) {
                    if(selectableView == holder){
                        //do nothing

                    }else{
                        //之前的设置为未选择
                        selectableData?.selected   = false
                        selectableView?.selectnodeselectImage?.setImageResource( android.R.color.transparent)

                        current.selected = true

                        selectableView = holder
                        selectableData = current
                        clicked(current.proxy.name)
                        current.update(true)
                        selectnodeselectImage.setImageResource((R.drawable.checkmarkcirclefill))


                    }
                }else
                {

                    selectableView?.selectnodeselectImage?.setImageResource( android.R.color.transparent)

                    current.selected = true

                    selectableView = holder
                    selectableData = current
                    clicked(current.proxy.name)
                    current.update(true)
                    selectnodeselectImage.setImageResource((R.drawable.checkmarkcirclefill))

                }

            }
        }

        current.update(true)

        if (current.selected){
            selectableView = holder
            selectableData = current
        }

        holder.selectnodeselectImage.setImageResource(if (current.selected) R.drawable.checkmarkcirclefill else android.R.color.transparent)
    }

    override fun getItemCount(): Int {
        return states.size
    }
}
