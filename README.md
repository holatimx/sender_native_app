# sender_native_app

Aplicación de ejemplo para utilizar los servicios HolaGAS

## COMO SE USA

Se debe mandar un string a la actividad principal de nuestra app de servicios

### REALIZAR INTENT

#### **KOTLIN**
```kotlin
val intent = Intent()

intent.component = ComponentName(
    "com.holati.hola_gas_android_services_app",
    "com.holati.hola_gas_android_services_app.MainActivity"
)

intent.putExtra("movement", movimiento_json)

startActivityForResult(intent, requestExternalCode)
```
#### **JAVA**
```java
Intent intent = new Intent();

intent.setComponent(new ComponentName(
    "com.holati.hola_gas_android_services_app",
    "com.holati.hola_gas_android_services_app.MainActivity"
));

intent.putExtra("movement", movimiento_json);

startActivityForResult(intent, requestExternalCode);
```

### DATOS QUE DEBE CONTENER EL MOVIMIENTO

Se generaron modelos de datos para ayudar al correcto manejo de datos

#### **KOTLIN**
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
#### **JAVA**
```java
public static class Movement {
        @SerializedName("ticket")
        public int ticket;

        @SerializedName("transactedAt")
        public String transactedAt;

        @SerializedName("notificationDetails")
        public String notificationDetails;

        @SerializedName("pumpNumber")
        public int pumpNumber;

        @SerializedName("dispatcher")
        public String dispatcher;

        @SerializedName("paymentMethod")
        public String paymentMethod;

        @SerializedName("canRedeemPoints")
        public boolean canRedeemPoints;

        @SerializedName("movementProducts")
        public List<MovementProduct> movementProducts;
}

public static class MovementProduct {
        @SerializedName("price")
        public double price;

        @SerializedName("discount")
        public double discount;

        @SerializedName("amount")
        public double amount;

        @SerializedName("iva")
        public double iva;

        @SerializedName("total")
        public Double total;

        @SerializedName("product")
        public Product product;
}

public static class Product {
        @SerializedName("controlGasCode")
        public int controlGasCode;

        @SerializedName("name")
        public String name;

        @SerializedName("details")
        public String details;

        @SerializedName("nomenclature")
        public String nomenclature;

        @SerializedName("hexColor")
        public String hexColor;

        @SerializedName("isGas")
        public boolean isGas;

        @SerializedName("nacsCategory")
        public String nacsCategory;
}
```

### COMO ESPERAR POR UNA RESPUESTA

Al haber mandado a llamar el startActivityForResult, se debe esperar una respuesta de la sig manera

#### **KOTLIN**
```kotlin
override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent) {
    super.onActivityResult(requestCode, resultCode, data)
    if (requestCode == requestExternalCode) {
        if (resultCode == RESULT_OK) {
            methodChannel?.invokeMethod("DATA_RECEIVED", data.getStringExtra("result"))
        } else if (resultCode == RESULT_CANCELED) {
            methodChannel?.invokeMethod("DATA_RECEIVED_ERROR", data.getStringExtra("error"))
        }
    }
}
```
#### **JAVA**
```java
@Override
protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
    if (requestCode == requestExternalCode) {
        if (resultCode == RESULT_OK) {
            methodChannel.invokeMethod("DATA_RECEIVED", data.getStringExtra("result"));
        } else if (resultCode == RESULT_CANCELED) {
            methodChannel.invokeMethod("DATA_RECEIVED_ERROR", data.getStringExtra("error"));
        }
    }
}
```

Tomando en cuenta el [requestCode], ya sea una respuesta exitosa [RESULT_OK] o alguna
erronea [RESULT_CANCELED], se regresará un mensaje string, ya sea con json codificado o un mensaje
en especifico
