package com.itfuturz.mygenie_member

import android.os.Bundle
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugins.GeneratedPluginRegistrant
import android.app.NotificationChannel
import android.app.NotificationManager
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build
import io.flutter.app.FlutterPluginRegistry

class MainActivity : FlutterActivity() {
  private val CHANNEL = "com.myjini_member.app"

  override protected fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
      MethodChannel(flutterView, CHANNEL).setMethodCallHandler {
      call, result ->
      if(call.method == "playSoundNotification"){
        //This block is called!!!
        val soundUri: Uri = Uri.parse(
                "android.resource://" +
                        applicationContext.packageName +
                        "/" + R.raw.alert)

        val audioAttributes = AudioAttributes.Builder()
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .setUsage(AudioAttributes.USAGE_ALARM)
                .build()

        val channel = NotificationChannel("noti_push_app_1",
                "noti_push_app",
                NotificationManager.IMPORTANCE_HIGH)
        channel.setSound(soundUri, audioAttributes)
        val notificationManager = getSystemService(NotificationManager::class.java)
        notificationManager.createNotificationChannel(channel)
      }
      else
        if( call.method == "playSilentNotification"){
        val channel = NotificationChannel("noti_push_app_1",
                "noti_push_app",
                NotificationManager.IMPORTANCE_HIGH)
        channel.setSound(null, null)
        val notificationManager = getSystemService(NotificationManager::class.java)
        notificationManager.createNotificationChannel(channel)
      }
      else {
        result.notImplemented();
      }
                }
    }
  }
