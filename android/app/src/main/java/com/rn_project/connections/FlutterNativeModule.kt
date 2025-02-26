package com.rn_project.connections

import android.content.Intent
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel

class FlutterNativeModule(reactContext: ReactApplicationContext) :
    ReactContextBaseJavaModule(reactContext) {


    override fun getName(): String {
        return "FlutterNativeModule"
    }

    fun openCommSDk() {
        val intent = FlutterActivity.withCachedEngine("my_engine_id").build(reactApplicationContext)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        reactApplicationContext.startActivity(intent)
    }


    @ReactMethod
    fun showToast() {
        val methodChannel: MethodChannel = MethodChannel(
            FlutterEngineCache.getInstance().get("my_engine_id")!!.dartExecutor.binaryMessenger,
            "com.flutter.module.channel"
        )




        methodChannel.setMethodCallHandler { call, result ->
            run {
                if (call.method.equals("openSDK")) {
                    openCommSDk()
                }
            }

        }

        methodChannel.let {
            currentActivity?.runOnUiThread {
                run {
                    methodChannel.invokeMethod("showToast", null)
                }
            }
        }
    }
}
