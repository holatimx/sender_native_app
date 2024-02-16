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
public class Movement {
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

public class MovementProduct {
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

public class Product {
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

### DATOS A ESPERAR EN LAS RESPUESTAS

#### **OK**
```json
{
  "products": [
    {
      "id": 3870,
      "movementId": 3563,
      "productId": 2,
      "price": 120,
      "discount": 0,
      "amount": 10,
      "total": 1200,
      "multiplier": 1,
      "iva": 0,
      "addedAt": "2024-02-16T19:44:19.875Z",
      "isGas": true,
      "businessId": 160,
      "clientId": 166,
      "magneticCardId": null,
      "hexColor": "008000"
    }
  ],
  "redemptionsUsed": null,
  "station": {
    "id": 26,
    "businessId": 160,
    "stateId": 26,
    "stationNumber": "E55555",
    "denomination": "Los Mochis",
    "latitude": 25.79668422408994,
    "longitude": -108.99415165185928,
    "publicIp": null,
    "multiplier": 1,
    "address": "JAVIER MINA 240 NTE.",
    "status": 0,
    "phone": "6688181483",
    "contact": "Ernesto",
    "email": "eurias@gmail.com",
    "useGasToPoints": true,
    "useNotGasToPoints": false,
    "pointsLogic": {
      "useGasToPoints": true,
      "useNotGasToPoints": false
    }
  },
  "business": {
    "profile": null,
    "businessSettings": {
      "id": 2,
      "businessId": 160,
      "labelPoints": "GTCoins",
      "pointsSelector": 1,
      "pointsCanExpire": true,
      "days": 365,
      "redemptionMultiplier": 0.01,
      "contactEmail": "trabajadoreejemplo@holati.mx",
      "contactName": "Trabajador ejemplo",
      "contactPhone": "1234567890",
      "maxCardsPerClient": 1,
      "clientsCanRequestAccountStatus": true,
      "defaultPointsForCards": 1000,
      "defaultDesignCardId": 2,
      "canCreatePublicMagCards": true,
      "validateIfMagCardStartsWith": "33103400",
      "validateIfMagCardEndsWith": "",
      "redemptionsCanGeneratePoints": false
    },
    "workersPermission": null,
    "workerSettings": null,
    "stationData": null,
    "id": 160,
    "businessId": null,
    "username": "Demo IMP",
    "userType": 2,
    "picture": "https://holagas.mx/HolaGasApp/Imagenes/c22738bb-dbfb-4bfd-995a-fafe9b300c07_fidelity_one.png",
    "isEnabled": true,
    "enabled": true,
    "createdAt": "2022-06-16T23:02:21Z",
    "dateTimeCreated": "2022-06-16T23:02:21Z",
    "verifiedAt": "2023-03-28T00:06:25Z",
    "dateTimeVerified": "2023-03-28T00:06:25Z",
    "isVerified": true,
    "verified": true,
    "isDeleted": false,
    "isPrivate": false,
    "deletedAt": null
  },
  "transferredFromStation": null,
  "user": {
    "profile": {
      "id": 22679,
      "userId": 166,
      "countryId": 1,
      "firstName": "Fernando Alberto",
      "lastName": "Lerma Sarabia",
      "email": "fiernandoalberto@gmail.com",
      "phone": "6681247366",
      "birthdayDateTime": "1998-11-03T00:00:00",
      "birthday": {
        "year": 1998,
        "month": 11,
        "day": 3
      },
      "genre": 1
    },
    "businessSettings": null,
    "workersPermission": null,
    "workerSettings": null,
    "stationData": null,
    "id": 166,
    "businessId": null,
    "username": "fiernandoalberto@gmail.com",
    "userType": 4,
    "picture": "https://holagas.mx/HolaGasApp/Imagenes/7605a865-659c-43ad-857e-66e0d84080a8.jpg",
    "isEnabled": true,
    "enabled": true,
    "createdAt": "2022-06-16T23:02:21Z",
    "dateTimeCreated": "2022-06-16T23:02:21Z",
    "verifiedAt": "2023-03-28T00:06:25Z",
    "dateTimeVerified": "2023-03-28T00:06:25Z",
    "isVerified": true,
    "verified": true,
    "isDeleted": false,
    "isPrivate": false,
    "deletedAt": null
  },
  "magneticCard": null,
  "pointsGenerated": 1200,
  "pointsAvailable": 1200,
  "subtotalNoGas": 0,
  "subtotalGas": 1200,
  "ivaTotal": 0,
  "total": 1200,
  "magneticsCardOfClient": [],
  "id": 3563,
  "stationId": 26,
  "userId": 166,
  "magneticCardId": null,
  "businessId": 160,
  "ticket": 99999999,
  "userAuthedBy": 0,
  "createdAt": "2024-02-16T19:54:14.2315332Z",
  "dateTimeCreated": "2024-02-16T19:54:14.2315332Z",
  "transactedAt": "2024-02-16T19:44:19.875Z",
  "transactionDateTime": "2024-02-16T19:44:19.875Z",
  "mustGeneratePoints": true,
  "generatePoints": true,
  "transferredFromStationId": null,
  "transferredAt": null,
  "pumpNumber": 1,
  "terminal": "Pruebas",
  "dispatcher": "Pedrito",
  "originalPrinted": true,
  "printsAmount": 2,
  "paymentMethod": "Efectivo",
  "pointsBeforeMovement": 27912.68,
  "pointsAfterMovement": 29112.68,
  "hexColor": "008000",
  "usersMagneticCardsSerializable": null
}
```
#### **CANCELED**
```json
{
  "error": "ESTO ES UN STRING"
}
```

### EN CASO DE HABER APLICADO UNA REDENCIÓN
```json
"redemptionsUsed": {
    "pointsUsedForRedemptions": 2484,
    "moneyUsedForRedemptions": 24.84,
    "remainingAmount": 0
}
```

