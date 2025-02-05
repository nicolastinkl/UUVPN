package com.github.kr328.clash.design.adapter

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.RelativeLayout
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.github.kr328.clash.design.R
import com.github.kr328.clash.network.PlanData

class PlanDataAdapter( private val onItemClick: (plan: PlanData) -> Unit  ) : RecyclerView.Adapter<SubscriptionViewHolder>() {

    private val subscriptions = mutableListOf<PlanData>()

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): SubscriptionViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.activity_item_subscription, parent, false)
        return SubscriptionViewHolder(view)
    }

    override fun onBindViewHolder(holder: SubscriptionViewHolder, position: Int) {
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
    fun setData(newData: List<PlanData>) {
        subscriptions.clear()
        subscriptions.addAll(newData)
        notifyDataSetChanged()
    }


    @SuppressLint("NotifyDataSetChanged")
    fun addData(newData: List<PlanData>) {
        subscriptions.addAll(newData)
        notifyDataSetChanged()
    }

}

class SubscriptionViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

    private val planName: TextView = itemView.findViewById(R.id.subscriptionName)
    private val planPrice: TextView = itemView.findViewById(R.id.subscriptionTime)
    private val planDescription: TextView = itemView.findViewById(R.id.subscriptionDescription)

    private val grouponemonth: RelativeLayout =  itemView.findViewById(R.id.grouponemohtthtest)
    private val groupquitytthtest: RelativeLayout =  itemView.findViewById(R.id.groupquitytthtest)
    private val grouphelfyear: RelativeLayout =  itemView.findViewById(R.id.grouphelfyear)
    private val grouponeyear: RelativeLayout =  itemView.findViewById(R.id.grouponeyear)

    private val onemohtthtest: TextView = itemView.findViewById(R.id.onemohtthtest)
    private val onequietythtest: TextView = itemView.findViewById(R.id.onequietythtest)
    private val helfyearthtest: TextView = itemView.findViewById(R.id.helfyearthtest)
    private val oneyearthtest: TextView = itemView.findViewById(R.id.oneyearthtest)


    private val onemonthprice: TextView = itemView.findViewById(R.id.onemonthprice)
    private val onequietyprice: TextView = itemView.findViewById(R.id.onequietyprice)
    private val helfyearprice: TextView = itemView.findViewById(R.id.helfyearprice)
    private val oneyearprice: TextView = itemView.findViewById(R.id.oneyearprice)


    private val onemonthpriceday: TextView = itemView.findViewById(R.id.onemonthpriceday)
    private val onequietypriceday: TextView = itemView.findViewById(R.id.onequietypriceday)
    private val helfyearpriceday: TextView = itemView.findViewById(R.id.helfyearpriceday)
    private val oneyearpriceday: TextView = itemView.findViewById(R.id.oneyearpriceday)


    fun bind(data: PlanData) {
        // 绑定数据
        planName.text = data.name

        if (data.onetime_price == null) {
            planPrice.text = "流量：${data.transfer_enable ?: 0}GB"
            planDescription.text = "¥${(data.month_price ?: 0.00).toDouble()/100}"

            val month_price = (data.month_price ?: 0.00).toDouble()/100
            val quarter_price = (data.quarter_price ?: 0.00).toDouble()/100
            val half_year_price = (data.half_year_price ?: 0.00).toDouble()/100
            val year_price = (data.year_price ?: 0.00).toDouble()/100

            if (month_price > 0.0) {
                onemonthprice.text = "${month_price}"
                onemonthpriceday.text = "${String.format ("%.2f",month_price/30)}元/天"
            }else{
                grouponemonth.visibility = View.GONE
            }

            if (quarter_price > 0.0) {
                onequietyprice.text = "${quarter_price}"
                onequietypriceday.text = "${String.format ("%.2f",quarter_price/90)}元/天"
            }else{
                groupquitytthtest.visibility = View.GONE
            }

            if (half_year_price > 0.0) {
                helfyearprice.text = "${half_year_price}"
                helfyearpriceday.text = "${String.format ("%.2f",half_year_price/180)}元/天"
            }else{
                grouphelfyear.visibility = View.GONE
            }

            if (year_price > 0.0) {
                oneyearprice.text = "${year_price}"
                oneyearpriceday.text = "${String.format ("%.2f",year_price/360)}元/天"
            }else{
                grouponeyear.visibility = View.GONE
            }


        }else{
            onemohtthtest.text = "一次性"
            planPrice.text = "流量：${data.transfer_enable ?: 0}GB 一次性"
            planDescription.text = "¥${(data.onetime_price ?:  0.00).toDouble()/100}"
            val month_price = (data.onetime_price ?: 0.00).toDouble()/100
            val transform = data.transfer_enable ?: 0
            onemonthprice.text = "${month_price}"
            onemonthpriceday.text = "${String.format ("%.2f",month_price/transform)}元/GB"

            groupquitytthtest.visibility = View.GONE
            grouphelfyear.visibility = View.GONE
            grouponeyear.visibility = View.GONE
        }

        //// 如果需要加载图片，可以使用图像加载库，如 Glide 或 Picasso
        //        Glide.with(itemView.context)
        //            .load(subscription.planImageUrl)
        //            .into(planImage)
    }
}
