package com.github.kr328.clash.design.adapter

import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.github.kr328.clash.core.model.Proxy
import com.github.kr328.clash.design.R
import com.github.kr328.clash.design.component.ProxyPageFactory
import com.github.kr328.clash.design.component.ProxyViewConfig
import com.github.kr328.clash.design.component.ProxyViewState
import com.github.kr328.clash.design.model.ProxyPageState
import com.github.kr328.clash.design.model.ProxyState
import com.github.kr328.clash.design.ui.Surface
import com.github.kr328.clash.design.util.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class ProxyPageAdapter(
    private val surface: Surface,
    private val config: ProxyViewConfig,
    private val adapters: List<ProxyAdapter>,
    private val stateChanged: (Int) -> Unit,
) : RecyclerView.Adapter<ProxyPageFactory.Holder>() { //<ProxyPageAdapter.VPNViewHolder>(){   //
    private val factory = ProxyPageFactory(config)
    private var parent: RecyclerView? = null

    val states = List(adapters.size) { ProxyPageState() }

    suspend fun updateAdapter(
        position: Int,
        proxies: List<Proxy>,
        selectable: Boolean,
        parent: ProxyState,
        links: Map<String, ProxyState>
    ) {
        val states = withContext(Dispatchers.Default) {
            proxies.map {
                val link = if (it.type.group) links[it.name] else null

                ProxyViewState(config, it, parent, link)
            }
        }

        withContext(Dispatchers.Main) {
            adapters[position].apply {
                this.selectable = selectable
                this.swapDataSet(this::states, states, false)
            }

            requestRedrawVisible()
        }
    }

    fun requestRedrawVisible() {
        factory.fromRoot(parent?.firstVisibleView ?: return)
            .recyclerView.invalidateChildren()
    }
    /*
       // ViewHolder class to hold and recycle views for RecyclerView items
       inner class VPNViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
           val flagImageView: ImageView = itemView.findViewById(R.id.flagImageView)
           val vpnInfoTextView: TextView = itemView.findViewById(R.id.vpnInfoTextView)
           val speedTextView: TextView = itemView.findViewById(R.id.speedTextView)
       }

       // This function inflates the item layout and returns the ViewHolder
       override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): VPNViewHolder {
           val view = LayoutInflater.from(parent.context)
               .inflate(R.layout.item_vpn, parent, false)
           return VPNViewHolder(view)
       }

       override fun onBindViewHolder(holder: VPNViewHolder, position: Int) {
           val adapter = adapters[position]

           states[position].bottom = false

          Log.i("onBindViewHolder"," ${ adapter.states.size}")

   //        holder.flagImageView.setImageResource(vpn.countryFlag)
           holder.vpnInfoTextView.text = "xxx"
           holder.speedTextView.text = "xx"
       }
      */

       override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ProxyPageFactory.Holder {
           val holder = factory.newInstance()

           val toolbarHeight = config.context.getPixels(R.dimen.toolbar_height)
           val tabHeight = config.context.getPixels(R.dimen.tab_layout_height)

           holder.recyclerView.bindInsets(surface, toolbarHeight + tabHeight)
           holder.recyclerView.addScrolledToBottomObserver { view, bottom ->
               val position = view.position
               val state = states[position]

               if (state.bottom != bottom) {
                   state.bottom = bottom

                   stateChanged(position)
               }
           }

           return holder
       }

       override fun onBindViewHolder(holder: ProxyPageFactory.Holder, position: Int) {
           val adapter = adapters[position]

           states[position].bottom = false

           holder.recyclerView.apply {
               this.position = position
               this.swapAdapter(adapter, false)
           }
       }

    override fun getItemCount(): Int {
        return adapters.size
    }

    override fun onAttachedToRecyclerView(recyclerView: RecyclerView) {
        this.parent = recyclerView

        recyclerView.isFocusable = false
    }

    override fun onDetachedFromRecyclerView(recyclerView: RecyclerView) {
        this.parent = null
    }


    private var RecyclerView.position: Int
        get() {
            return tag as? Int ?: -1
        }
        set(value) {
            tag = value
        }
}