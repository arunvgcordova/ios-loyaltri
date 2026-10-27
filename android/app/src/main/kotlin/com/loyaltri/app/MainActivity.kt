package com.loyaltri.app

import android.os.Bundle
import android.os.Debug
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import android.util.Log
import android.provider.Settings 
import android.annotation.SuppressLint
import android.location.LocationManager
// ------ loyaltri Filed ----- //
import android.os.Build
// ------ loyaltri Filed ----- //

class MainActivity : FlutterActivity(){
    private val CHANNEL = "app.security/checks"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "detectFrida" -> result.success(detectFrida())
                "isDebuggerConnected" -> {
                    val isDebug = Debug.isDebuggerConnected()
                    // Log.d("SecurityCheck", "Debugger connected: $isDebug")
                    result.success(isDebug)
                }
                "isDeviceRooted" -> result.success(isDeviceRooted())
                "isMockLocationEnabled" -> result.success(isMockLocationEnabled()) // NEW
                else -> result.notImplemented()
            }
        }
    }

    private fun detectFrida(): Boolean {
        val suspects = arrayOf("frida-server", "frida-agent", "frida-trace")
        for (process in suspects) {
            val file = File("/system/bin/$process")
            if (file.exists()) return true
        }
        return false
    }

    private fun isDeviceRooted(): Boolean {
        val paths = arrayOf(
            "/system/app/Superuser.apk",
            "/sbin/su",
            "/system/bin/su",
            "/system/xbin/su",
            "/data/local/xbin/su",
            "/data/local/bin/su",
            "/system/sd/xbin/su"
        )
        for (path in paths) {
            if (File(path).exists()) return true
        }
        return false
    }

    @SuppressLint("MissingPermission")
    private fun isMockLocationEnabled(): Boolean {
        val locationManager = getSystemService(LOCATION_SERVICE) as LocationManager
        val providers = locationManager.getProviders(true)

        for (provider in providers) {
            val location = locationManager.getLastKnownLocation(provider)
            if (location != null && location.isFromMockProvider) {
                return true
            }
        }
        return false
    }

    // ------ loyaltri Filed ----- //

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        requestNotificationPermission()
    }

    private fun requestNotificationPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (checkSelfPermission(android.Manifest.permission.POST_NOTIFICATIONS) != android.content.pm.PackageManager.PERMISSION_GRANTED) {
                requestPermissions(arrayOf(android.Manifest.permission.POST_NOTIFICATIONS), 101)
            }
        }
    }
    // ------ loyaltri Filed ----- //
}
