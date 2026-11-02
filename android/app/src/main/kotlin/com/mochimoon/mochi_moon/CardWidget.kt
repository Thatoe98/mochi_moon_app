package com.mochimoon.mochi_moon

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.BitmapFactory
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray
import org.json.JSONException
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/** Opens the Deck; Flutter hands the path of this URI to the Dart router. */
private const val DECK_URI = "mochimoon://widget/deck"

/** Key under which Dart stores the JSON list of days (see home_widget_publisher.dart). */
private const val DAYS_KEY = "days"

/** Key under which Dart stores the widget theme id (see widget_theme.dart). */
private const val THEME_KEY = "theme"

/**
 * Shows today's card: the short text and a thumbnail. Dart stocks the next two
 * weeks, so choosing today's entry here is all it takes to change at midnight.
 */
abstract class CardWidget(private val layout: Int) : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val today = todayEntry(widgetData)
        val theme = widgetData.getString(THEME_KEY, null)
        for (id in appWidgetIds) {
            val views = RemoteViews(context.packageName, layout)
            views.setTextViewText(
                R.id.widget_text,
                today?.text ?: context.getString(R.string.widget_fallback_text),
            )

            val thumbnail = today?.imagePath?.let { BitmapFactory.decodeFile(it) }
            if (thumbnail != null) {
                views.setImageViewBitmap(R.id.widget_thumbnail, thumbnail)
                views.setViewVisibility(R.id.widget_thumbnail, View.VISIBLE)
            } else {
                views.setViewVisibility(R.id.widget_thumbnail, View.GONE)
            }

            applyTheme(context, views, theme)

            views.setOnClickPendingIntent(
                R.id.widget_root,
                HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    Uri.parse(DECK_URI),
                ),
            )
            appWidgetManager.updateAppWidget(id, views)
        }
    }

    /** Cream is the layout's own look; the Premium themes swap the background and text color. */
    private fun applyTheme(context: Context, views: RemoteViews, theme: String?) {
        val (background, text) = when (theme) {
            "lavender" -> R.drawable.widget_background_lavender to R.color.widget_text_lavender
            "peach" -> R.drawable.widget_background_peach to R.color.widget_text_peach
            "midnight" -> R.drawable.widget_background_midnight to R.color.widget_text_midnight
            else -> return
        }
        views.setInt(R.id.widget_root, "setBackgroundResource", background)
        views.setTextColor(R.id.widget_text, context.getColor(text))
    }

    private class Entry(val text: String, val imagePath: String?)

    /** The entry for the device's local date, or null when Dart has not stocked one. */
    private fun todayEntry(widgetData: SharedPreferences): Entry? {
        val json = widgetData.getString(DAYS_KEY, null) ?: return null
        val today = SimpleDateFormat("yyyy-MM-dd", Locale.US).format(Date())
        try {
            val days = JSONArray(json)
            for (i in 0 until days.length()) {
                val day = days.getJSONObject(i)
                if (day.getString("date") == today) {
                    return Entry(day.getString("text"), day.optString("image").ifEmpty { null })
                }
            }
        } catch (_: JSONException) {
            // Unreadable data: fall back to the gentle default text.
        }
        return null
    }
}

class CardWidgetSmall : CardWidget(R.layout.widget_card_small)

class CardWidgetWide : CardWidget(R.layout.widget_card_wide)
