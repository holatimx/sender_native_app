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
    private val requestExternalCode = 123
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
                            ///SKIP
                            //OBTENCIÓN DE VALORES MANDADOS DESDE FLUTTER
                            val ticket =
                                call.argument<Int>("ticket")
                                    ?: throw Exception("Ticket inválido")

                            val pumpNumber =
                                call.argument<Int>("pumpNumber")
                                    ?: throw Exception("Número de bomba inválido")

                            val dispatcher =
                                call.argument<String>("dispatcher")
                                    ?: throw Exception("Despachador inválido")

                            val notificationDetails =
                                call.argument<String>("notificationDetails")
                                    ?: throw Exception("Detalle de notificaciones inválido")

                            val paymentMethod = call.argument<String>("paymentMethod")

                            val addProduct = call.argument<Boolean>("addProduct") ?: false

                            val transactedAt =
                                call.argument<String>("transactedAt")
                                    ?: throw Exception("Fecha inválida")

                            //AQUÍ EMPIEZA EL CÓDIGO PARA CONSUMIR EL SERVICIO
                            val intent = Intent()
                            intent.component = ComponentName(
                                "com.holati.hola_gas_android_services_app",
                                "com.holati.hola_gas_android_services_app.MainActivity"
                            )

                            var products = mutableListOf<MovementProduct>(
                                MovementProduct(
                                    22.10,
                                    0.0,
                                    10.0,
                                    0.0,
                                    null, //Si mandan NULL se calcula en la app, pero si mandan el valor, aun que no coinsida se tomará en cuenta
                                    Product(
                                        32011,
                                        "MAGNA",
                                        "Gasolina regular menor a 91 octanos",
                                        "LTR",
                                        "008000",
                                        true,
                                        "010100"
                                    )
                                )
                            )

                            // PUEDES AGREGAR MAS PRODUCTS SI ASÍ LO DESEAN
                            if (addProduct)
                                products.add(
                                    MovementProduct(
                                        65.0,
                                        0.0,
                                        1.0,
                                        0.0,
                                        null, //Si mandan NULL se calcula en la app, pero si mandan el valor, aun que no coinsida se tomará en cuenta
                                        Product(
                                            54,
                                            "ANTICONGELANTE",
                                            "54 ANTICONGELANTE H87",
                                            "H87",
                                            "D5D2D1",
                                            false,
                                            null
                                        )
                                    )
                                )


                            ///SE USA Gson() PARA CONVERTIR LOS OBJETOS A JSONS CODIFICADOS A STRING
                            val gson = Gson()
                            val movement = Movement(
                                ticket,
                                transactedAt,
                                notificationDetails,
                                pumpNumber,
                                dispatcher,
                                paymentMethod,
                                true,
                                products
                            )

                            //SE AGREGA COMO CAMPO AL INTENT
                            intent.putExtra("movement", gson.toJson(movement))

                            //SE MANDA A INICIAR LA ACTIVIDAD DE LA APP DE SERVICIOS
                            startActivityForResult(intent, requestExternalCode)

                        } catch (e: Exception) {
                            result.error(e.message!!, e.message, e.message)
                        }
                        result.success(true)
                    }
                }
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent) {
        super.onActivityResult(requestCode, resultCode, data)
        //ESPERANDO RESPUESTA DESDE LA APP DE SERVICIOS
        if (requestCode == requestExternalCode) {
            if (resultCode == RESULT_OK) {
                methodChannel?.invokeMethod("DATA_RECEIVED", data.getStringExtra("result"))
            } else if (resultCode == RESULT_CANCELED) {
                methodChannel?.invokeMethod("DATA_RECEIVED_ERROR", data.getStringExtra("error"))
            }
        }
    }

}
