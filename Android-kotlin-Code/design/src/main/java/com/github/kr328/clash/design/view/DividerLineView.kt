package com.github.kr328.clash.design.view


import android.content.Context
import android.graphics.Canvas
import android.graphics.Paint
import android.util.AttributeSet
import android.view.View


/*
class DividerLineView @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0
) : View(context, attrs, defStyleAttr) {

    private val paint = Paint().apply {
        color = 0xFFCCCCCC.toInt() // 设置颜色
        strokeWidth = 2f // 设置线宽
    }

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)
        // 绘制横线
        canvas.drawLine(0f, height.toFloat(), width.toFloat(), height.toFloat(), paint)
    }
}

*/

import androidx.annotation.StringRes
import com.github.kr328.clash.design.databinding.DesignDrivderlineBinding
import com.github.kr328.clash.design.databinding.PreferenceCategoryBinding
import com.github.kr328.clash.design.preference.Preference
import com.github.kr328.clash.design.preference.PreferenceScreen
import com.github.kr328.clash.design.preference.addElement
import com.github.kr328.clash.design.util.layoutInflater

fun PreferenceScreen.drividerline(
) {

    val binding = DesignDrivderlineBinding
        .inflate(context.layoutInflater, root, false)


    addElement(object : Preference {
        override val view: View
            get() = binding.root
        override var enabled: Boolean
            get() = binding.root.isEnabled
            set(value) {
                binding.root.isEnabled = value
            }
    })
}
