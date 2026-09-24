package com.example.actirune

import android.content.Intent
import android.net.Uri
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "actirune/app_settings",
        ).setMethodCallHandler { call, result ->
            if (call.method != "openAppSettings") {
                result.notImplemented()
                return@setMethodCallHandler
            }

            try {
                startActivity(
                    Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                        data = Uri.fromParts("package", packageName, null)
                    },
                )
                result.success(true)
            } catch (error: Exception) {
                result.error("settings_unavailable", error.message, null)
            }
        }
    }
}
