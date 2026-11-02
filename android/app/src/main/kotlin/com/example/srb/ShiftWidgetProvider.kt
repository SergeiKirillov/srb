
package com.example.srb

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.util.Locale

class ShiftWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val now = LocalDateTime.now()
        val date = now.toLocalDate()
        val formatter = DateTimeFormatter.ofPattern(
            "dd.MM.yyyy",
            Locale.getDefault()
        )

        val nightBrigade = ShiftSchedule.nightBrigade(date)
        val dayBrigade = ShiftSchedule.dayBrigade(date)

        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(
                context.packageName,
                R.layout.shift_widget
            )

            views.setTextViewText(
                R.id.widget_date,
                "Сменный справочник — ${date.format(formatter)}"
            )
            views.setTextViewText(
                R.id.widget_night,
                "Ночная смена: бригада № $nightBrigade"
            )
            views.setTextViewText(
                R.id.widget_day,
                "Дневная смена: бригада № $dayBrigade"
            )


            val currentBrigade = ShiftSchedule.currentBrigade(
                LocalDate.now(),
                LocalDateTime.now().hour
            )

            val launchIntent = context.packageManager
                .getLaunchIntentForPackage(context.packageName)
                ?: continue

            launchIntent.putExtra("brigade", currentBrigade)
            launchIntent.addFlags(
                android.content.Intent.FLAG_ACTIVITY_CLEAR_TOP or
                    android.content.Intent.FLAG_ACTIVITY_SINGLE_TOP
            )

            val pendingIntent = android.app.PendingIntent.getActivity(
                context,
                appWidgetId,
                launchIntent,
                android.app.PendingIntent.FLAG_UPDATE_CURRENT or
                    android.app.PendingIntent.FLAG_IMMUTABLE
            )

            views.setOnClickPendingIntent(
                R.id.widget_date,
                pendingIntent
            )
            views.setOnClickPendingIntent(
                R.id.widget_night,
                pendingIntent
            )
            views.setOnClickPendingIntent(
                R.id.widget_day,
                pendingIntent
            )


            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
