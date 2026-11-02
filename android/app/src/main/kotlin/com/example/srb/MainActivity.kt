
package com.example.srb

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.time.LocalDate
import java.time.LocalDateTime

class MainActivity : FlutterActivity() {

    private val channelName = "com.example.srb/widget"
    private var methodChannel: MethodChannel? = null
    private var pendingBrigade: Int? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName
        )

        pendingBrigade?.let { brigade ->
            sendBrigade(brigade)
            pendingBrigade = null
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleWidgetIntent(intent)
    }

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        handleWidgetIntent(intent)
    }

    private fun handleWidgetIntent(intent: Intent?) {
        val brigade = intent?.getIntExtra("brigade", -1) ?: -1
        if (brigade !in 1..4) return

        if (methodChannel == null) {
            pendingBrigade = brigade
        } else {
            sendBrigade(brigade)
        }

        intent?.removeExtra("brigade")
    }

    private fun sendBrigade(brigade: Int) {
        methodChannel?.invokeMethod("openBrigade", brigade)
    }
}
