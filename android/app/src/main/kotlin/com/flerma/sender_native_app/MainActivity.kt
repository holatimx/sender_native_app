package com.flerma.sender_native_app

import android.content.ComponentName
import android.content.Intent
import android.os.Build
import android.os.Bundle
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import com.google.gson.Gson
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import kotlin.concurrent.thread

class MainActivity : FlutterActivity() {
    private val appChannel = "com.example/my_channel"
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        methodChannel = MethodChannel(
            flutterEngine!!.dartExecutor.binaryMessenger,
            appChannel
        )

        methodChannel?.setMethodCallHandler { call, result ->
            thread {
                when (call.method) {
                    "sendDataFromNative" -> {
                        try {
                            val intent = Intent()
                            intent.component = ComponentName(
                                "com.holati.hola_gas_android_services_app",
                                "com.holati.hola_gas_android_services_app.MainActivity"
                            )

                            val gson = Gson()
                            val movement = Movement(
                                1,
                                "2023-09-04T00:00:00-07:00",
                                "prueba hecho desde app externa",
                                1,
                                null,
                                null,
                                true,
                                listOf(
                                    MovementProduct(
                                        100.0,
                                        0.0,
                                        10.0,
                                        0.0,
                                        Product(
                                            1,
                                            "Magna",
                                            "Gasolina verde",
                                            "Litros",
                                            "00FF00",
                                            true,
                                            null
                                        )
                                    )
                                )
                            )
                            intent.putExtra("movement", gson.toJson(movement))
                            startActivity(intent)
                            /*

                                                        val intent =
                                                            Intent("com.holati.hola_gas_android_services_app.CREATE_MOVEMENT")
                                                        intent.putExtra("ticket", "123456789")
                                                        sendBroadcast(intent)*/
                        } catch (e: Exception) {
                            // Manejar la excepción aquí, por ejemplo, mostrando un mensaje de error
                            result.error(e.message!!, e.message, e.message)
                        }
                        result.success(true)
                    }
                }
            }
        }
    }
}
