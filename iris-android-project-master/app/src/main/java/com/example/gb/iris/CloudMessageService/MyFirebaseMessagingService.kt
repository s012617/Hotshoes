package com.example.gb.iris.CloudMessageService

import android.annotation.SuppressLint
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Build
import android.os.PowerManager
import androidx.core.app.NotificationCompat
import com.example.gb.iris.MainActivity
import com.example.gb.iris.R
import com.example.gb.iris.RedirectWebActivity
import com.google.android.gms.tasks.OnCompleteListener
import com.google.android.gms.tasks.Task
import com.google.firebase.iid.FirebaseInstanceId
import com.google.firebase.iid.InstanceIdResult
import com.google.firebase.messaging.FirebaseMessaging
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import me.leolin.shortcutbadger.ShortcutBadger
import org.jetbrains.anko.intentFor
import java.io.IOException
import java.net.HttpURLConnection
import java.net.URL


class MyFirebaseMessagingService : FirebaseMessagingService() {

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        // Check if message contains a notification payload.
        if (remoteMessage.data.isNotEmpty())
            sendNotification(remoteMessage.data)
    }

    override fun onNewToken(p0: String) {
        super.onNewToken(p0)
        // Get updated InstanceID token
        FirebaseMessaging.getInstance().subscribeToTopic("all").addOnSuccessListener {
            println("all topic subscribe complete")
        }
        FirebaseMessaging.getInstance().subscribeToTopic("android").addOnSuccessListener {
            println("android topic subscribe complete")
        }
        FirebaseInstanceId.getInstance().instanceId
            .addOnCompleteListener(object : OnCompleteListener<InstanceIdResult?> {
                override fun onComplete(task: Task<InstanceIdResult?>) {
                    if (!task.isSuccessful) {
                        println("task: ${task.exception.toString()}")
                        return
                    }
                    // Get new Instance ID token
                    val token: String = task.result!!.token
                    // Log and toast
                    println("get token: $token")
                    val shareToken = getSharedPreferences(
                        getString(R.string.tokenKey),
                        Context.MODE_PRIVATE
                    ).edit()
                    shareToken.putString(getString(R.string.tokenKey), token)
                    shareToken.apply()
                }
            })
    }

    private fun sendNotification(notification: Map<String, String>) {
        //////// Set up notification
        val channelId = "IRISChannel"
        val clickIntent = intentFor<MainActivity>()
        val piClick = PendingIntent.getActivity(
            this,
            R.string.app_name,
            clickIntent,
            PendingIntent.FLAG_UPDATE_CURRENT
        )
        val builder = NotificationCompat.Builder(this, channelId)
        val myNotifyBuilder = builder
            .setContentIntent(piClick)
            .setDefaults(Notification.DEFAULT_ALL)
            .setPriority(NotificationManager.IMPORTANCE_HIGH)
            .setAutoCancel(true)
            .setSmallIcon(R.mipmap.ic_launcher_iris_round)
            .setWhen(System.currentTimeMillis())
            .setContentTitle(notification["title"])
            .setContentText(notification["body"])
            .setBadgeIconType(NotificationCompat.BADGE_ICON_LARGE)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
        if (!notification["subText"].isNullOrEmpty())
            myNotifyBuilder.setSubText(notification["subText"])
        if (!notification["image"].isNullOrEmpty()) {
            val bitmap: Bitmap? = getBitmapFromURL(notification["image"] ?: error(""))
            builder.setStyle(
                NotificationCompat.BigPictureStyle()
                    .bigPicture(bitmap)
                    .bigLargeIcon(null)
            ).setLargeIcon(bitmap)
        }
        if (!notification["redirectUrl"].isNullOrEmpty()) {
            myNotifyBuilder.setSubText(notification["redirectUrl"])
            val notificationIntent = Intent(this, RedirectWebActivity::class.java)
            val shareUrl = getSharedPreferences(
                getString(R.string.redirectUrlKey),
                Context.MODE_PRIVATE
            ).edit()
            shareUrl.putString(getString(R.string.redirectUrlKey), notification["redirectUrl"])
            shareUrl.apply()
            val pendingIntent = PendingIntent.getActivity(
                this, 0,
                notificationIntent, 0
            )
            myNotifyBuilder.setContentIntent(pendingIntent)
        }
        if (!notification["notification_count"].isNullOrEmpty())
            ShortcutBadger.applyCount(
                this,
                (notification["notification_count"] ?: error("0")).toInt()
            )

        val notifyMgr = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationChannel =
                NotificationChannel(channelId, "IRISApp", NotificationManager.IMPORTANCE_HIGH)
            notifyMgr.createNotificationChannel(notificationChannel)
        }
        notifyMgr.notify(R.string.app_name, myNotifyBuilder.build())
        wakeUpScreen()
    }

    @Suppress("DEPRECATION")
    @SuppressLint("InvalidWakeLockTag")
    private fun wakeUpScreen() {
        val pm =
            this.getSystemService(Context.POWER_SERVICE) as PowerManager
        val isScreenOn = pm.isInteractive
        if (!isScreenOn) {
            val wl: PowerManager.WakeLock = pm.newWakeLock(
                PowerManager.FULL_WAKE_LOCK or PowerManager.ACQUIRE_CAUSES_WAKEUP or PowerManager.ON_AFTER_RELEASE,
                "MyLock"
            )
            wl.acquire(10000)
            val wlCpu: PowerManager.WakeLock = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "MyCpuLock")
            wlCpu.acquire(10000)
        }
    }

    private fun getBitmapFromURL(strURL: String): Bitmap? {
        return try {
            val url = URL(strURL)
            val connection = url.openConnection() as HttpURLConnection
            connection.doInput = true
            connection.connect()
            val input = connection.inputStream
            BitmapFactory.decodeStream(input)
        } catch (e: IOException) {
            e.printStackTrace()
            null
        }
    }
}