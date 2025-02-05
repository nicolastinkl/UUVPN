package com.github.kr328.clash.design.adapter

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.HorizontalScrollView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.github.kr328.clash.design.R
import com.github.kr328.clash.network.OrderData
import com.github.kr328.clash.network.PlanData
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class OrdersDataAdapter(private val onItemClick: (plan: OrderData) -> Unit ) : RecyclerView.Adapter<OrdersDataAdapterViewHolder>() {

    private val subscriptions = mutableListOf<OrderData>()

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): OrdersDataAdapterViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.activity_item_subscription, parent, false)
        return OrdersDataAdapterViewHolder(view)
    }

    override fun onBindViewHolder(holder: OrdersDataAdapterViewHolder, position: Int) {
        val subscription = subscriptions[position]
        holder.bind(subscription)
        holder.itemView.setOnClickListener {
            onItemClick(subscription) // 将点击的 position 传递给回调函数
        }
    }

    override fun getItemCount(): Int {
        return subscriptions.size
    }

    @SuppressLint("NotifyDataSetChanged")
    fun setData(newData: List<OrderData>) {
        subscriptions.clear()
        subscriptions.addAll(newData)
        notifyDataSetChanged()
    }


    @SuppressLint("NotifyDataSetChanged")
    fun addData(newData: List<OrderData>) {
        subscriptions.addAll(newData)
        notifyDataSetChanged()
    }

}

class OrdersDataAdapterViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

    private val planName: TextView = itemView.findViewById(R.id.subscriptionName)
    private val planDescription: TextView = itemView.findViewById(R.id.subscriptionDescription)
    private val plantime: TextView = itemView.findViewById(R.id.subscriptionTime)

    private val subscriptionAmount: TextView = itemView.findViewById(R.id.subscriptionAmount)
    private val subscriptionStatus: TextView = itemView.findViewById(R.id.subscriptionStatus)

    private val groups_Scrollview: HorizontalScrollView = itemView.findViewById(R.id.groups_Scrollview)


    fun formatTimestamp(timestamp: Long): String {
        val dateFormat = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault())  // 定义格式
        val date = Date(timestamp)  // 将时间戳转为 Date 对象
        return dateFormat.format(date)  // 格式化为字符串
    }

    fun bind(data: OrderData) {
        // 绑定数据

        planName.text = data.plan?.name + "(" +  data.periodZh + ")"
        planDescription.text = "${data.plan?.transfer_enable ?: 0}GB"
        plantime.text = formatTimestamp((data.created_at ?: 0 ) * 1000L)

        subscriptionStatus.text = data.statusZh
        val formattedAmount =  data.total_amount?.div(100)
        subscriptionAmount.text = " ¥${formattedAmount}"

        groups_Scrollview.visibility = View.GONE


        //// 如果需要加载图片，可以使用图像加载库，如 Glide 或 Picasso
        //        Glide.with(itemView.context)
        //            .load(subscription.planImageUrl)
        //            .into(planImage)
    }
}
