package com.rn_project.connections

import android.view.View
import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ReactShadowNode
import com.facebook.react.uimanager.ViewManager

class FlutterModulePackage: ReactPackage {
    override fun createNativeModules(context: ReactApplicationContext): MutableList<NativeModule> {
        return mutableListOf(FlutterNativeModule(context))
    }

    override fun createViewManagers(context: ReactApplicationContext): MutableList<ViewManager<View, ReactShadowNode<*>>> {
        return mutableListOf()
    }
}
