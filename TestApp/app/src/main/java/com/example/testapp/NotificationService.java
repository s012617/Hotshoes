package com.example.testapp;

import android.app.Service;
import android.content.Intent;
import android.os.Handler;
import android.os.IBinder;
import android.util.Log;

import androidx.annotation.Nullable;

import com.google.firebase.messaging.RemoteMessage;

import java.util.Timer;
import java.util.TimerTask;

public class NotificationService extends Service {
    Timer t = null;
    TimerTask timerTask = null;
    Timer secs = new Timer(String.valueOf(5));




    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        System.out.print("Fuck you");
        super.onStartCommand(intent, flags, startId);
        startTimer();
        return START_STICKY;
    }

    @Override
    public void onCreate() {
        System.out.println("yaaaa");
    }

    @Override
    public void onDestroy() {
        System.out.println("onDestroy");
        stoptimertask();
        super.onDestroy();
    }

    Handler h = new Handler();

    private void startTimer(){
        t = new Timer();
        initializeTimerTask();
        t.schedule(timerTask, 5000, 1000);}

    private void initializeTimerTask() {
        TimerTask obj = new TimerTask() {
            @Override
            public void run() {
                h.post(new Runnable() {
                    @Override
                    public void run() {
                        System.out.println("FF");
                    }
                });
            }
        };
    }

            private void stoptimertask() {
                if (t != null) {
                    t.cancel();
                    t = null;
                }
            }
}