# sender_native_app

Aplicación de ejemplo para utilizar los servicios HolaGAS

## COMO SE USA

Se debe mandar un string a la actividad principal de nuestra app de servicios

### REALIZAR INTENT
```kotlin
val intent = Intent()

intent.component = ComponentName(
    "com.holati.hola_gas_android_services_app",
    "com.holati.hola_gas_android_services_app.MainActivity"
)

intent.putExtra("movement", movimiento_json)

startActivityForResult(intent, requestExternalCode)
```

### DATOS QUE DEBE CONTENER EL MOVIMIENTO

Se generaron modelos de datos para ayudar al correcto manejo de datos

```kotlin
data class Movement(
    @SerializedName("ticket") val ticket: Int,
    @SerializedName("transactedAt") val transactedAt: String?,
    @SerializedName("notificationDetails") val notificationDetails: String?,
    @SerializedName("pumpNumber") val pumpNumber: Int,
    @SerializedName("dispatcher") val dispatcher: String?,
    @SerializedName("paymentMethod") val paymentMethod: String?,
    @SerializedName("canRedeemPoints") val canRedeemPoints: Boolean,
    @SerializedName("movementProducts") val movementProducts: List<MovementProduct>
)

data class MovementProduct(
    @SerializedName("price") val price: Double,
    @SerializedName("discount") val discount: Double,
    @SerializedName("amount") val amount: Double,
    @SerializedName("iva") val iva: Double,
    @SerializedName("total") val total: Double?,
    @SerializedName("product") val product: Product
)

data class Product(
    @SerializedName("controlGasCode") val controlGasCode: Int,
    @SerializedName("name") val name: String,
    @SerializedName("details") val details: String,
    @SerializedName("nomenclature") val nomenclature: String,
    @SerializedName("hexColor") val hexColor: String?,
    @SerializedName("isGas") val isGas: Boolean,
    @SerializedName("nacsCategory") val nacsCategory: String?
)
```
