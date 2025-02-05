package com.github.kr328.clash.design.view

import android.content.Context
import android.graphics.*
import android.util.AttributeSet
import android.view.View

class BottomArcGradientView @JvmOverloads constructor(
    context: Context, attrs: AttributeSet? = null, defStyleAttr: Int = 0
) : View(context, attrs, defStyleAttr) {

    private val paint = Paint(Paint.ANTI_ALIAS_FLAG)

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)

        // 获取视图的宽高
        val width = width.toFloat()
        val height = height.toFloat()

        // 定义渐变的颜色
        val gradientColors = intArrayOf(
//            Color.parseColor("#2066b367"), // 起始颜色（橙色）
//            Color.parseColor("#5066b367"), // 中间颜色（深橙色）
            Color.parseColor("#66b367"), // 中间颜色（深橙色）
            Color.parseColor("#66b367"), // 中间颜色（深橙色）
            Color.parseColor("#66b367")  // 结束颜色（红色）
        )

        // 创建渐变着色器
        val shader = LinearGradient(
            0f, height * 0.5f,  // 渐变起点
            0f, height,         // 渐变终点
            gradientColors,
            null,
            Shader.TileMode.CLAMP
        )

        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            this.shader = shader
        }

        // 创建弧形路径
        val path = Path()
        path.moveTo(0f, height * 0.5f) // 起点（底部的70%位置）
        path.quadTo(
            width / 2f, height * 0.1f, // 控制点（中间凹陷位置）
            width, height * 0.5f       // 终点（右侧底部70%位置）
        )
        path.lineTo(width, height) // 连接到右下角
        path.lineTo(0f, height)    // 连接到左下角
        path.close()

        // 绘制路径
        canvas.drawPath(path, paint)
    }
}
