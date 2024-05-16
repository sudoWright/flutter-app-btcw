/*
 * Copyright (c) 2023 Proton AG
 * This file is part of Proton AG and Proton Pass.
 *
 * Proton Pass is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Proton Pass is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Proton Pass.  If not, see <https://www.gnu.org/licenses/>.
 */

package com.example.wallet

import android.content.Intent
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterFragmentActivity() {
    companion object {
        var flutterEngineInstance: FlutterEngine? = null
    }
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        flutterEngineInstance = flutterEngine
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "me.proton.wallet/native.views")
            .setMethodCallHandler { call: MethodCall, result ->
                when (call.method) {
                    "native.navigation.login" -> {
                        val intent = Intent(this, AuthActivity::class.java)
                        intent.putExtra("method", "signin")
                        startActivity(intent)
                    }
                    "native.navigation.signup" -> {
                        val intent = Intent(this, AuthActivity::class.java)
                        intent.putExtra("method", "signup")
                        startActivity(intent)
                    }
                    "native.navigation.restartApp" -> {
                        val context = this
                        val intent = context.packageManager.getLaunchIntentForPackage(context.packageName)
                        intent?.let {
                            it.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_NEW_TASK)
                            context.startActivity(it)
                        }
                        Runtime.getRuntime().exit(0)
                    }
                    "native.navigation.plan.upgrade" -> {
                        val arguments = call.arguments
                        println("Upgrade Plan called with arguments: $arguments")
                    }
                }
            }
    }

}
