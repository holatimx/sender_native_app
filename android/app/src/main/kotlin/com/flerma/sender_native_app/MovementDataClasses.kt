package com.flerma.sender_native_app

import com.google.gson.annotations.SerializedName

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
