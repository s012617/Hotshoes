package com.example.gb.iris

import android.annotation.SuppressLint
import android.app.AlertDialog
import android.content.Context
import android.content.DialogInterface
import android.content.Intent
import android.content.IntentSender
import android.os.Build
import android.os.Bundle
import android.webkit.JsResult
import android.webkit.WebChromeClient
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.appcompat.app.AppCompatActivity
import com.example.gb.iris.Config.hideKeyboardHandler
import com.example.gb.iris.Model.Register
import com.google.android.material.snackbar.Snackbar
import com.google.android.play.core.appupdate.AppUpdateManager
import com.google.android.play.core.appupdate.AppUpdateManagerFactory
import com.google.android.play.core.install.InstallState
import com.google.android.play.core.install.InstallStateUpdatedListener
import com.google.android.play.core.install.model.AppUpdateType
import com.google.android.play.core.install.model.InstallStatus
import com.google.android.play.core.install.model.UpdateAvailability
import com.google.gson.Gson
import kotlinx.android.synthetic.main.activity_main.*
import me.leolin.shortcutbadger.ShortcutBadger
import okhttp3.*
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.RequestBody.Companion.toRequestBody
import org.jetbrains.anko.alert
import org.jetbrains.anko.design.snackbar
import org.jetbrains.anko.yesButton
import java.io.IOException


class MainActivity : AppCompatActivity() {
    private var backPressedTime: Long = 0
    private val gson = Gson()
    private val FLEXIBLE_REQUEST_CODE = 1029
    private val IMMEDIATE_REQUEST_CODE = 1028

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        val token = getSharedPreferences(getString(R.string.tokenKey), Context.MODE_PRIVATE)
        val tokenString = token.getString(getString(R.string.tokenKey), "")
        ShortcutBadger.removeCount(this)
        hideKeyboardHandler(constrainLayout_main, this)
        setUpWebView(tokenString, this)
    }

    @SuppressLint("SetJavaScriptEnabled")
    private fun setUpWebView(token: String?, ctx: Context) {
        webView.loadUrl("http://app.iris.com.tw")
        webView.settings.javaScriptEnabled = true
        webView.webViewClient = WebViewClient()
//            webView.webChromeClient = WebChromeClient()
        webView.webChromeClient = object : WebChromeClient() {
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
                    if (message.contains("id:")) {
                        if (token!!.isNotEmpty()) {
                            postRegister(
                                "${getString(R.string.apiHost)}/user",
                                Register(message.substring(3), getString(R.string.companyId), token)
                            )
                        }
                    } else if (message.contains("badge:")) {
                        val bCount = message.substring(6).toInt()
                        if (bCount == 0) {
                            ShortcutBadger.removeCount(ctx)
                        } else
                            ShortcutBadger.applyCount(ctx, bCount)
                    } else
                        dialog.show()
                }
                result.confirm()
                return true
            }
        }
    }

    private fun getRegistUrl(data: Register) {
        val apiUrl = ""
        val client = OkHttpClient()
        val request = Request.Builder().url(apiUrl).get().build()
        client.newCall(request).enqueue(object : Callback {
            override fun onResponse(call: Call, response: Response) {
                postRegister(apiUrl, data)
            }
            override fun onFailure(call: Call, e: IOException) {
            }
        })
    }

    private fun postRegister(apiUrl: String, data: Register) {
        val jsonType = "application/json; charset=utf-8".toMediaType()
        val json = gson.toJson(data)
        val body = json.toRequestBody(jsonType)
        val client = OkHttpClient()
        val request = Request.Builder().url(apiUrl).post(body).build()
        client.newCall(request).enqueue(object : Callback {
            override fun onResponse(call: Call, response: Response) {
                println("success")
            }
            override fun onFailure(call: Call, e: IOException) {
                println("fail: $e")
            }
        })
    }

    private fun checkForUpdates(userTriggered: Boolean = false) {
        // Creates instance of the manager.
        val appUpdateManager = AppUpdateManagerFactory.create(this)

        // Returns an intent object that you use to check for an update.
        val appUpdateInfoTask = appUpdateManager.appUpdateInfo

        // Checks that the platform will allow the specified type of update.
        appUpdateInfoTask.addOnSuccessListener { appUpdateInfo ->
            when (appUpdateInfo.updateAvailability()) {
                UpdateAvailability.UPDATE_AVAILABLE -> {
                    if (appUpdateInfo.isUpdateTypeAllowed(AppUpdateType.IMMEDIATE)) {
                        // Immediate, required update
                        appUpdateManager.startUpdateFlowForResult(
                            // Pass the intent that is returned by 'getAppUpdateInfo()'.
                            appUpdateInfo,
                            // Or 'AppUpdateType.FLEXIBLE' for flexible updates.
                            AppUpdateType.IMMEDIATE,
                            // The current activity making the update request.
                            this,
                            // Include a request code to later monitor this update request.
                            IMMEDIATE_REQUEST_CODE
                        )
                    } else if (appUpdateInfo.isUpdateTypeAllowed(AppUpdateType.FLEXIBLE)) {
                        // Flexible, optional update
                        // Create a listener to track request state updates.
                        val listener = { state: InstallState ->
                            // Show module progress, log state, or install the update.
                            when (state.installStatus()) {
                                InstallStatus.DOWNLOADED -> {
                                    // After the update is downloaded, show a notification
                                    // and request user confirmation to restart the app.
                                    val snackbar: Snackbar = Snackbar.make(
                                        constrainLayout_main,
                                        "下載完成",
                                        Snackbar.LENGTH_INDEFINITE
                                    )
                                    snackbar.setAction(
                                        "重新啟動"
                                    ) { _ -> appUpdateManager.completeUpdate() }
                                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                        snackbar.setActionTextColor(
                                            resources.getColor(
                                                R.color.colorAccent,
                                                theme
                                            )
                                        )
                                    }
                                    snackbar.show()
                                }
                                InstallStatus.FAILED -> {
                                    val snackbar: Snackbar = Snackbar.make(
                                        constrainLayout_main,
                                        "下載失敗",
                                        Snackbar.LENGTH_LONG
                                    )
                                    snackbar.setAction(
                                        "重試"
                                    ) { checkForUpdates() }
                                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                        snackbar.setActionTextColor(
                                            resources.getColor(
                                                R.color.colorAccent,
                                                theme
                                            )
                                        )
                                    }
                                    snackbar.show()
                                }
                            }
                        }
                        appUpdateManager.registerListener(listener)
                        appUpdateManager.startUpdateFlowForResult(
                            // Pass the intent that is returned by 'getAppUpdateInfo()'.
                            appUpdateInfo,
                            // Or 'AppUpdateType.FLEXIBLE' for flexible updates.
                            AppUpdateType.FLEXIBLE,
                            // The current activity making the update request.
                            this,
                            // Include a request code to later monitor this update request.
                            FLEXIBLE_REQUEST_CODE
                        )
                        appUpdateManager.unregisterListener(listener)
                    }
                }
                UpdateAvailability.UPDATE_NOT_AVAILABLE -> {
//                    alert("你的程式版本已為最新版", "") {
//                        yesButton {  }
//                    }.show()
                }
                UpdateAvailability.DEVELOPER_TRIGGERED_UPDATE_IN_PROGRESS -> {
                    alert("新版本下載中", "") {
                        yesButton {  }
                    }.show()
                }
                UpdateAvailability.UNKNOWN -> {
                    if (userTriggered) {
                        alert("版本偵測發生了未知錯誤", "") {
                            yesButton {  }
                        }.show()
                    }
                }
            }
        }
    }

    override fun onStart() {
        super.onStart()
        checkForUpdates(true)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == IMMEDIATE_REQUEST_CODE || requestCode == FLEXIBLE_REQUEST_CODE) {
            if (resultCode != RESULT_OK) {
                println("Update flow failed! Result code: $resultCode")
                // If the update is cancelled or fails,
                // you can request to start the update again.
            }
        }
    }

    override fun onBackPressed() {
        if (backPressedTime + 2000 > System.currentTimeMillis()) {
            super.onBackPressed()
            finish()
        } else constrainLayout_main.snackbar("Press back again to exit.")
        backPressedTime = System.currentTimeMillis()
    }
}
