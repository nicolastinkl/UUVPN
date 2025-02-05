package com.github.kr328.clash.design.util
import android.content.Context
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.view.LayoutInflater
import androidx.appcompat.app.AlertDialog
import com.github.kr328.clash.design.databinding.CustomDialogBinding

fun Context.showCustomDialog(
    title: String,
    message: String,
    positiveButtonText: String = "确定",
    negativeButtonText: String = "取消",
    onPositiveClick: (() -> Unit)? = null,
    onNegativeClick: (() -> Unit)? = null
) {
    // 使用 ViewBinding 加载自定义布局

    val binding = CustomDialogBinding.inflate(LayoutInflater.from(this))

    // 设置标题和消息
    binding.dialogTitle.text = title
    binding.dialogMessage.text = message
    binding.positiveButton.text = positiveButtonText
    binding.negativeButton.text = negativeButtonText

    // 创建 AlertDialog
    val dialog = AlertDialog.Builder(this).setView(binding.root).create()

    // 去除默认背景
    dialog.window?.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))

    // 设置按钮点击事件
    binding.positiveButton.setOnClickListener {
        onPositiveClick?.invoke()
        dialog.dismiss()
    }
    binding.negativeButton.setOnClickListener {
        onNegativeClick?.invoke()
        dialog.dismiss()
    }

    // 显示对话框
    dialog.show()
}
