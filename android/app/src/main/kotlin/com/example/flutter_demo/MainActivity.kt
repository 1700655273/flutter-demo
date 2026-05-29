package com.example.flutter_demo

import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "okhttp_profiler"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "log" -> {
                        val tag = call.argument<String>("tag") ?: ""
                        val message = call.argument<String>("message") ?: ""
                        Log.v(tag, message)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
