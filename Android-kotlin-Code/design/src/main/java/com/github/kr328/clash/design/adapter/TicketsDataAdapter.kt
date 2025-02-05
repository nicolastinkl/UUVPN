package com.github.kr328.clash.design.adapter

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.github.kr328.clash.common.util.intent
import com.github.kr328.clash.design.R
import com.github.kr328.clash.design.util.showCustomDialog
import com.github.kr328.clash.network.TicketsData
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

//class

class TicketsDataAdapter( private val onItemClick: (plan: TicketsData) -> Unit  , private val onCloseItemClick: (plan: TicketsData) -> Unit  ) : RecyclerView.Adapter<TicketViewHolder>() {

    private val subscriptions = mutableListOf<TicketsData>()

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): TicketViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.activity_gondan_item, parent, false)
        return TicketViewHolder(view)
    }

    override fun onBindViewHolder(holder: TicketViewHolder, position: Int) {
        val subscription = subscriptions[position]
        holder.bind(subscription)
        holder.itemView.setOnClickListener {
            onItemClick(subscription) // 将点击的 position 传递给回调函数
        }
        holder.viewButton.setOnClickListener {
            onItemClick(subscription) // 将点击的 position 传递给回调函数
        }
        holder.closeButton.setOnClickListener {
            onCloseItemClick(subscription)
        }

    }

    override fun getItemCount(): Int {
        return subscriptions.size
    }

    @SuppressLint("NotifyDataSetChanged")
    fun setData(newData: List<TicketsData>) {
        subscriptions.clear()
        subscriptions.addAll(newData)
        notifyDataSetChanged()
    }


    @SuppressLint("NotifyDataSetChanged")
    fun addData(newData: List<TicketsData>) {
        subscriptions.addAll(newData)
        notifyDataSetChanged()
    }
}

class TicketViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

    private val titleTextView: TextView = itemView.findViewById(R.id.titleTextView)
    private val creationTimeTextView: TextView = itemView.findViewById(R.id.creationTimeTextView)
    private val statusTextView: TextView = itemView.findViewById(R.id.statusTextView)
      val closeButton: Button = itemView.findViewById(R.id.closeButton)
      val viewButton: TextView = itemView.findViewById(R.id.viewButton)

    fun formatTimestamp(timestamp: Long): String {
        val dateFormat = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault())  // 定义格式
        val date = Date(timestamp*1000L)  // 将时间戳转为 Date 对象
        return dateFormat.format(date)  // 格式化为字符串
    }
    fun bind(data: TicketsData) {
        // 绑定数据
        titleTextView.text = "#${data.id ?: 0} - ${data.subject ?: ""}"

        creationTimeTextView.text = "创建时间： ${formatTimestamp(data.created_at ?: 0)}"
        if (data.status == 0){
            statusTextView.text = "当前状态： 待回复"
            closeButton.visibility = View.VISIBLE

        }else{
            statusTextView.text = "当前状态： 已关闭"
            closeButton.visibility = View.GONE
        }

        //// 如果需要加载图片，可以使用图像加载库，如 Glide 或 Picasso
        //        Glide.with(itemView.context)
        //            .load(subscription.planImageUrl)
        //            .into(planImage)
    }
}

