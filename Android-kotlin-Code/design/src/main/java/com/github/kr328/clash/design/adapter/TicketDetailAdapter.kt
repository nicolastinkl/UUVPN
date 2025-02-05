package com.github.kr328.clash.design.adapter

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.github.kr328.clash.design.R
import com.github.kr328.clash.network.TicketMessage
import com.github.kr328.clash.network.TicketsData
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale


class TicketDetailAdapter( private val onItemClick: (plan: TicketMessage) -> Unit  ) : RecyclerView.Adapter<RecyclerView.ViewHolder >() {

    companion object {
        const val VIEW_TYPE_LEFT = 0
        const val VIEW_TYPE_RIGHT = 1
    }


    private val subscriptions = mutableListOf<TicketMessage>()

    override fun getItemViewType(position: Int): Int {
        return if (subscriptions[position].is_me ?: false) VIEW_TYPE_RIGHT else VIEW_TYPE_LEFT
    }


    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder  {

        return if (viewType == VIEW_TYPE_RIGHT) {
            val view = LayoutInflater.from(parent.context).inflate(R.layout.activity_item_message_right, parent, false)
            RightTicketDetailViewHolder(view)
        } else {
            val view = LayoutInflater.from(parent.context).inflate(R.layout.activity_item_message_left, parent, false)
            LeftTicketDetailViewHolder(view)
        }

//        val viewlef = LayoutInflater.from(parent.context).inflate(R.layout.activity_item_message_left, parent, false)
//        return TicketDetailViewHolder(viewlef)
    }

    override fun onBindViewHolder(holder:  RecyclerView.ViewHolder, position: Int) {
        val message = subscriptions[position]
        if (holder is RightTicketDetailViewHolder) {
            holder.bind(message)
        } else if (holder is LeftTicketDetailViewHolder) {
            holder.bind(message)
        }
    }

//    override fun onBindViewHolder(holder: TicketDetailViewHolder, position: Int) {
//        val subscription = subscriptions[position]
//        holder.bind(subscription)
//        holder.itemView.setOnClickListener {
//            onItemClick(subscription) // 将点击的 position 传递给回调函数
//        }
//    }

    override fun getItemCount(): Int {
        return subscriptions.size
    }

    @SuppressLint("NotifyDataSetChanged")
    fun setData(newData: List<TicketMessage>) {
        subscriptions.clear()
        subscriptions.addAll(newData)
        notifyDataSetChanged()
    }


    @SuppressLint("NotifyDataSetChanged")
    fun addData(newData: List<TicketMessage>) {
        subscriptions.addAll(newData)
        notifyDataSetChanged()
    }
}
class LeftTicketDetailViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

    private val titleTextView: TextView = itemView.findViewById(R.id.messageTextView)
    private val creationTimeTextView: TextView = itemView.findViewById(R.id.timeTextView)
    fun formatTimestamp(timestamp: Long): String {
        val dateFormat = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault())  // 定义格式
        val date = Date(timestamp*1000L)  // 将时间戳转为 Date 对象
        return dateFormat.format(date)  // 格式化为字符串
    }
    fun bind(data: TicketMessage) {
        // 绑定数据
        titleTextView.text = "${data.message ?: ""}"

        creationTimeTextView.text = "${formatTimestamp(data.created_at ?: 0)}"
    }
}

class RightTicketDetailViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

    private val titleTextView: TextView = itemView.findViewById(R.id.messageTextView)
    private val creationTimeTextView: TextView = itemView.findViewById(R.id.timeTextView)
    fun formatTimestamp(timestamp: Long): String {
        val dateFormat = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault())  // 定义格式
        val date = Date(timestamp*1000L)  // 将时间戳转为 Date 对象
        return dateFormat.format(date)  // 格式化为字符串
    }
    fun bind(data: TicketMessage) {
        // 绑定数据
        titleTextView.text = "${data.message ?: ""}"

        creationTimeTextView.text = "${formatTimestamp(data.created_at ?: 0)}"
    }
}