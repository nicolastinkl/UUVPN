package com.github.kr328.clash.utity
import android.app.Activity
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.ProgressBar
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import com.github.kr328.clash.design.R


object LoadingDialog {
    private var dialog: AlertDialog? = null

    fun show(context: Context, message: String = "请稍等...") {
        if (dialog == null) {
            val inflater = LayoutInflater.from(context)
            val view: View = inflater.inflate(R.layout.loading_dialog, null)
            val progressBar: ProgressBar = view.findViewById(R.id.progressBar)
            val messageTextView: TextView = view.findViewById(R.id.loadingMessage)

            messageTextView.text = message

            dialog = AlertDialog.Builder(context)
                .setCancelable(false)
                .setView(view)
                .create()

            dialog?.show()
        }
    }

    fun hide() {
        dialog?.dismiss()
        dialog = null
    }
}
