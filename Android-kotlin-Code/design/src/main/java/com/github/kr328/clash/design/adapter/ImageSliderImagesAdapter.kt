package com.github.kr328.clash.design.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.bumptech.glide.load.resource.bitmap.CircleCrop
import com.bumptech.glide.load.resource.bitmap.RoundedCorners
import com.bumptech.glide.request.RequestOptions
import com.github.kr328.clash.design.R

class ImageSliderImagesAdapter(private val imageUrls: List<String>,
                               private val onItemClick: (Int) -> Unit // 接收点击事件
) :
    RecyclerView.Adapter<ImageSliderImagesAdapter.ImageSliderViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ImageSliderViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_image_slider, parent, false)

        return ImageSliderViewHolder(view)
    }

    override fun onBindViewHolder(holder: ImageSliderViewHolder, position: Int) {
        val imageUrl = imageUrls[position]
        Glide.with(holder.imageView.context)
            .load(imageUrl) // 网络图片的 URL

            .placeholder(R.drawable.placeholder) // 占位图
            .error(R.drawable.placeholder) // 加载失败时的图片
            .into(holder.imageView)
        // 设置点击事件
       // holder.imageView.apply { RequestOptions().transform(RoundedCorners(30)) }// 圆角处理
        holder.imageView.setOnClickListener {
            onItemClick(position)  // 传递当前图片的 URL 或其他数据
        }
    }

    override fun getItemCount(): Int = imageUrls.size

    class ImageSliderViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val imageView: ImageView = view.findViewById(R.id.imageView)
    }
}
