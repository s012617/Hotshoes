package com.example.gb.iris

import android.annotation.SuppressLint
import android.app.AlertDialog
import android.content.Context
import android.content.DialogInterface
import android.os.Bundle
import android.view.View
import android.webkit.JsResult
import android.webkit.WebChromeClient
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.appcompat.app.AppCompatActivity
import kotlinx.android.synthetic.main.activity_redirect_web.*
import me.leolin.shortcutbadger.ShortcutBadger


class RedirectWebActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_redirect_web)
        val sharedUrl =
            getSharedPreferences(getString(R.string.redirectUrlKey), Context.MODE_PRIVATE)
        val url = sharedUrl.getString(getString(R.string.redirectUrlKey), "")
        if (!url.isNullOrEmpty()) {
            setUpWebView(url, this)
            textView_redirect.visibility = View.INVISIBLE
        } else
            textView_redirect.visibility = View.VISIBLE
    }

    @SuppressLint("SetJavaScriptEnabled")
    private fun setUpWebView(url: String, ctx: Context) {
        webView_redirect.loadUrl(url)
        webView_redirect.settings.javaScriptEnabled = true
        webView_redirect.webViewClient = WebViewClient()
        webView_redirect.webChromeClient = object : WebChromeClient() {
            override fun onJsAlert(
                view: WebView,
                url: String?,
                message: String?,
                result: JsResult
            ): Boolean {
                if (!message.isNullOrEmpty()) {
                    val dialog: AlertDialog =
                        AlertDialog.Builder(view.context).setTitle("Oops !").setMessage(message)
                            .setPositiveButton("OK",
                                DialogInterface.OnClickListener { _, _ ->
                                }).create()
                    if (message.contains("badge:")) {
                        val bCount = message.substring(6).toInt()
                        if (bCount == 0)
                            ShortcutBadger.removeCount(ctx)
                        else
                            ShortcutBadger.applyCount(ctx, bCount)
                    } else
                        dialog.show()
                }
                result.confirm()
                return true
            }
        }
    }
}
