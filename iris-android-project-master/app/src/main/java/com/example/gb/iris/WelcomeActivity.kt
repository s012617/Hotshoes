package com.example.gb.iris

import android.annotation.SuppressLint
import android.os.Bundle
import android.content.Intent
import android.os.Handler
import androidx.appcompat.app.AppCompatActivity


class WelcomeActivity : AppCompatActivity() {

    public override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_welcome)
        mHandler.sendEmptyMessageDelayed(GOTO_MAIN_ACTIVITY, 2000) //2秒跳轉
    }

    private val GOTO_MAIN_ACTIVITY = 0
    private val mHandler = @SuppressLint("HandlerLeak")
    object : Handler() {
        override fun handleMessage(msg: android.os.Message) {
            when (msg.what) {
                GOTO_MAIN_ACTIVITY -> {
                    val intent = Intent()
                    //將原本Activity的換成MainActivity
                    intent.setClass(this@WelcomeActivity, MainActivity::class.java)
                    startActivity(intent)
                    finish()
                }

                else -> {
                }
            }
        }

    }
}
