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
    @SerializedName("ticket") val ticket: Int,  //dbo.despachos.nrotrn                                 
    @SerializedName("transactedAt") val transactedAt: String?, //fecha-hora actual formato YYYY-MM-DDTHH:MM:SST-TIMEZONE  p.e. 2024-02-19T10:47:23.5342682-07:00
    @SerializedName("notificationDetails") val notificationDetails: String?, //string datos informativos de la fecha hora local de la terminal p.e. "con fecha {despachoTask.fechaStr} {despachoTask.HoraStr}"
    @SerializedName("pumpNumber") val pumpNumber: Int, //dbo.despachos.nrobom
    @SerializedName("dispatcher") val dispatcher: String?, //dbo.responsables.den   inner join con dbo.despachos.codres
    @SerializedName("paymentMethod") val paymentMethod: String?,  //string denominacion de la forma de pago p.e. "Efectivo"
    @SerializedName("canRedeemPoints") val canRedeemPoints: Boolean, //false para solo movimiento de acumulación y true para movimiento con aplicación de redeción de puntos
    @SerializedName("movementProducts") val movementProducts: List<MovementProduct>, //lista de MovementProduct
    @SerializedName("requiredAmountOfMxnMoneyToRedeem") val requiredAmountOfMxnMoneyToRedeem: Double? //dinero requerido a redimir
)

data class MovementProduct(
    @SerializedName("price") val price: Double,  //dbo.despachos.pre
    @SerializedName("discount") val discount: Double, //enviar 0 siempre se actualizara por los servicios de FidelityONE®
    @SerializedName("amount") val amount: Double, //dbo.despachos.can
    @SerializedName("iva") val iva: Double, //calculo de IVA del producto
    @SerializedName("total") val total: Double?, // dbo.despachos.mto
    @SerializedName("product") val product: Product //objeto Product
)

data class Product(
    @SerializedName("controlGasCode") val controlGasCode: Int, //si es combustible dbo.productos.cveprv, si es producto dbo.productos.codext inner join dbo.despachos.codprd
    @SerializedName("name") val name: String, // dbo.productos.den inner join dbo.despachos.codprd
    @SerializedName("details") val details: String, //si es combustible dbo.productos.codSAT p.e. "Gasolina regular menor a 91 octanos", si es producto "{item.CodigoProducto} {item.Producto} {item.UnidadMedida}"
    @SerializedName("nomenclature") val nomenclature: String, //dbo.productos.uni inner join dbo.despachos.codprd
    @SerializedName("hexColor") val hexColor: String?, // dbo.productos.rgbcol en hexadecimal de 3 bytes p.e. 008000 
    @SerializedName("isGas") val isGas: Boolean, //true si es combustible y false si es producto.
    @SerializedName("nacsCategory") val nacsCategory: String? //dbo.productos.NACScat inner joing dbo.despachos.codprd
)
```
#### **JAVA**
```java
public class Movement {
    @SerializedName("ticket")
    //dbo.despachos.nrotrn   
    public int ticket;

    @SerializedName("transactedAt")
    //fecha-hora actual formato YYYY-MM-DDTHH:MM:SST-TIMEZONE  p.e. 2024-02-19T10:47:23.5342682-07:00
    public String transactedAt;

    @SerializedName("notificationDetails")
    //string datos informativos de la fecha hora local de la terminal p.e. "con fecha {despachoTask.fechaStr} {despachoTask.HoraStr}"
    public String notificationDetails;

    @SerializedName("pumpNumber")
    //dbo.despachos.nrobom
    public int pumpNumber;

    @SerializedName("dispatcher")
    //dbo.responsables.den   inner join con dbo.despachos.codres
    public String dispatcher;

    @SerializedName("paymentMethod")
    //string denominacion de la forma de pago p.e. "Efectivo"
    public String paymentMethod;

    @SerializedName("canRedeemPoints")
    //false para solo movimiento de acumulación y true para movimiento con aplicación de redeción de puntos
    public boolean canRedeemPoints;

    @SerializedName("movementProducts")
    //lista de MovementProduct
    public List<MovementProduct> movementProducts;

    @SerializedName("requiredAmountOfMxnMoneyToRedeem")
    //dinero requerido a redimir
    public double requiredAmountOfMxnMoneyToRedeem;
}

public class MovementProduct {
    @SerializedName("price") //dbo.despachos.pre
    public double price;

    @SerializedName("discount")
    //enviar 0 siempre se actualizara por los servicios de FidelityONE®
    public double discount;

    @SerializedName("amount") //dbo.despachos.can
    public double amount;

    @SerializedName("iva")
    //calculo de IVA del producto
    public double iva;

    @SerializedName("total") // dbo.despachos.mto
    public Double total;

    @SerializedName("product") //objeto Product
    public Product product;
}

public class Product {
    @SerializedName("controlGasCode")
    //si es combustible dbo.productos.cveprv, si es producto dbo.productos.codext inner join dbo.despachos.codprd
    public int controlGasCode;

    @SerializedName("name")
    // dbo.productos.den inner join dbo.despachos.codprd
    public String name;

    @SerializedName("details")
    //si es combustible dbo.productos.codSAT p.e. "Gasolina regular menor a 91 octanos", si es producto "{item.CodigoProducto} {item.Producto} {item.UnidadMedida}"
    public String details;

    @SerializedName("nomenclature")
    //dbo.productos.uni inner join dbo.despachos.codprd
    public String nomenclature;

    @SerializedName("hexColor")
    // dbo.productos.rgbcol en hexadecimal de 3 bytes p.e. 008000 
    public String hexColor;

    @SerializedName("isGas")
    //true si es combustible y false si es producto.
    public boolean isGas;

    @SerializedName("nacsCategory")
    //dbo.productos.NACScat inner joing dbo.despachos.codprd
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

