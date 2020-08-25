package com.example.gb.iris.CloudMessageService

import android.app.Service
import android.content.Intent
import android.os.Handler
import android.os.IBinder
import android.util.Log
import java.util.*

//Not used yet
//Start this service onStop() in your activity lifecycle. With this code:
//startService(new Intent(this, NotificationService.class));

class NotificationService : Service() {
    var timer: Timer? = null
    var timerTask: TimerTask? = null
    var secs = 5


    override fun onBind(arg0: Intent?): IBinder? {
        return null
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        println("Start Notification Service")
        super.onStartCommand(intent, flags, startId)
        startTimer()
        return START_STICKY
    }


    override fun onCreate() {
        println("Notification Service create")
    }

    override fun onDestroy() {
        println("Notification Service destroy")
        stoptimertask()
        super.onDestroy()
    }

    //we are going to use a handler to be able to run in our TimerTask
    val handler: Handler = Handler()


    private fun startTimer() {
        //set a new Timer
        timer = Timer()
        //initialize the TimerTask's job
        initializeTimerTask()
        //schedule the timer, after the first 5000ms the TimerTask will run every 10000ms
        timer!!.schedule(timerTask, 5000, secs.times(1000).toLong()) //
        //timer.schedule(timerTask, 5000,1000); //
    }

    private fun stoptimertask() {
        //stop the timer, if it's not already null
        if (timer != null) {
            timer!!.cancel()
            timer = null
        }
    }

    private fun initializeTimerTask() {
        timerTask = object : TimerTask() {
            override fun run() {
                //use a handler to run a toast that shows the current timestamp
                handler.post(Runnable {
                    println("in function")
                })
            }
        }
    }
}