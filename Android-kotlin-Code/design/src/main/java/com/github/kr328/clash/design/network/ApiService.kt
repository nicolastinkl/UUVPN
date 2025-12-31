package com.github.kr328.clash.network

import android.content.Context
import com.google.gson.annotations.SerializedName
import kotlinx.coroutines.time.withTimeout
import kotlinx.coroutines.withTimeout
import okhttp3.RequestBody
import retrofit2.Response
import retrofit2.http.Body
import retrofit2.http.GET
import retrofit2.http.Header
import retrofit2.http.POST
import retrofit2.http.Query
import java.io.IOException
import java.io.Serializable
import java.util.concurrent.TimeoutException

/// 所有网络接口
interface ApiService {

    @GET("config")
    suspend fun getConfig(): Response<ConfigResponse>

    @POST("passport/auth/login")
    suspend fun loginUser(@Body request: LoginRequest): Response<LoginResponse>

    @POST("passport/auth/register")
    suspend fun registerUser(@Body request: LoginRequest): Response<LoginResponse>

    @GET("user/info")
    suspend fun getUserData(@Header("Authorization") auth_data: String): Response<UserInfoResponse>

    @GET("user/getSubscribe")
    suspend fun getSubscribe(@Header("Authorization") auth_data: String): Response<SubscribeResponse>

    @GET("user/plan/fetch")
    suspend fun getplans(@Header("Authorization") auth_data: String): Response<PlansResponse>

    @GET("user/order/fetch")
    suspend fun getOrders(@Header("Authorization") auth_data: String): Response<OrdersResponse>

    @POST("user/order/save") //period=half_year_price&plan_id=2&coupon_code=
    suspend fun saveOrder(@Header("Authorization") auth_data: String,@Body request: SaveOrderRequest): Response<SubmitOrderResponse>

    @GET("user/order/detail") //period=half_year_price&plan_id=2&coupon_code=
    suspend fun getOrderdetail(@Header("Authorization") auth_data: String, @Query("trade_no") trade_no: String): Response<QueryOrderResponse>

    @GET("user/order/getPaymentMethod")
    suspend fun getPaymentList(@Header("Authorization") auth_data: String): Response<PaymentResponse>

    @POST("user/order/checkout")
    suspend fun checkoutOrder(@Header("Authorization") auth_data: String,@Body request: CheckoutrderRequest): Response<PublicResponse>

    @GET("user/invite/fetch")
    suspend fun getinviteList(@Header("Authorization") auth_data: String) :Response<InviteResponse>

    @GET("user/invite/save")
    suspend fun saveinvite(@Header("Authorization") auth_data: String) :Response<SaveInviteCodeResponse>

    @GET("user/ticket/fetch")
    suspend fun getTickets(@Header("Authorization") auth_data: String): Response<TicketsResponse>

    @GET("user/ticket/fetch")
    suspend fun getTicketsByTID(@Header("Authorization") auth_data: String, @Query("id") ticketID: Int): Response<TicketDetailResponse>

    @POST("user/ticket/close")
    suspend fun closeTicket(@Header("Authorization") auth_data: String,@Body request: Map<String, Int>): Response<PublicResponse>

    @POST("user/ticket/save")
    suspend fun saveTicket(@Header("Authorization") auth_data: String,@Body request: MutableMap<String, String>): Response<PublicResponse>

    @POST("user/ticket/reply")
    suspend fun replyTicket(@Header("Authorization") auth_data: String,@Body request: MutableMap<String, String>): Response<PublicResponse>

}


data class SaveInviteCodeResponse(
    val `data`: Any?,

    val message: String?,
    val status: String?
)

data class TicketDetailResponse(
    val `data`: TicketDetailData?,
    val message: String?,
    val status: String?
)

data class TicketDetailData(
    val created_at: Int?,
    val id: Int?,
    val level: Int?,
    val message: List<TicketMessage>?,
    val reply_status: Int?,
    val status: Int?,
    val subject: String?,
    val updated_at: Int?,
    val user_id: Int?
)

data class TicketMessage(
    val created_at: Long?,
    val id: Int?,
    val is_me: Boolean?,
    val message: String?,
    val ticket_id: Int?,
    val updated_at: Long?
)

data class TicketsResponse(
    val `data`: List<TicketsData>?,
    val message: String?,
    val status: String?
)

data class TicketsData(
    val created_at: Long?,
    val id: Int?,
    val level: Int?,
    val message: Any?,
    val reply_status: Int?,
    val status: Int?,
    val subject: String?,
    val updated_at: Long?,
    val user_id: Int?
)


suspend fun <T> safeApiCall(
    apiCall: suspend () -> Response<T>
): T? {
    return try {
        val response = withTimeout(13000) {
            apiCall()
        }

        if (response.isSuccessful) {
            response.body()
        } else {
            println("请求失败，错误码: ${response.code()}")
            null
        }
    } catch (e: TimeoutException) {
        println("请求超时，请检查网络连接: ${e.message}")
        null
    } catch (e: IOException) {
        println("网络错误，请检查网络连接: ${e.message}")
        null
    } catch (e: Exception) {
        println("未知错误: ${e.message}")
        null
    }
}



suspend fun <T> safeApiRequestCall(
    apiCall: suspend () -> Response<T>
): Response<T>? {
    return try {
        val response = withTimeout(13000) {
            apiCall()
        }
        if (response.isSuccessful) {
            response
        } else {
            println("请求失败，错误码: ${response.code()}")
            response
        }
    } catch (e: TimeoutException) {
        println("请求超时，请检查网络连接: ${e.message}")
        null
    } catch (e: IOException) {
        println("网络错误，请检查网络连接: ${e.message}")
        null
    } catch (e: Exception) {
        println("未知错误: ${e.message}")
        null
    }
}




data class InviteResponse(
    val `data`: InviteData?,
    val error: Any?,
    val message: String?,
    val status: String?
)

data class InviteData(
    val codes: List<InviteCode>?,
    val stat: List<Int>?
)

data class InviteCode(
    val code: String?,
    val created_at: Int?,
    val pv: Int?,
    val status: Int?,
    val updated_at: Int?,
    val user_id: Int?
)
data class CheckoutrderRequest(
    val trade_no: String,
    val method: Int
)

data class PaymentResponse(
    val `data`: List<PaymentData>?,
    val message: String?,
    val status: String?
)

data class PaymentData(
    val handling_fee_fixed: Any?,
    val handling_fee_percent: String?,
    val icon: Any?,
    val id: Int?,
    val name: String?,
    val payment: String?
)
//
data class  QueryOrderRequest(
    val  trade_no: String
)


data class QueryOrderResponse(
    val `data`: QueryOrderData?,
    val message: String?,
    val status: String?
)

data class QueryOrderData(
    val actual_commission_balance: Any?,
    val balance_amount: Any?,
    val callback_no: Any?,
    val commission_balance: Int?,
    val commission_status: Int?,
    val coupon_code: Any?,
    val coupon_id: Any?,
    val created_at: Int?,
    val discount_amount: Any?,
    val handling_amount: Int?,
    val id: Int?,
    val invite_user_id: Any?,
    val paid_at: Any?,
    val payment_id: Int?,
    val period: String?,
    val plan: PlanData?,
    val plan_id: Int?,
    val refund_amount: Any?,
    val site_id: Any?,
    val status: Int?,
    val surplus_amount: Any?,
    val surplus_order_ids: Any?,
    val tixianstatus: Any?,
    val total_amount: Int?,
    val trade_no: String?,
    val try_out_plan_id: Int?,
    val type: Int?,
    val updated_at: Int?,
    val user_id: Int?
){
    // status 对应的中文描述
    val statusZh: String
        get() = when (status) {
            0 -> "待支付"
            1 -> "已支付"
            2 -> "已取消"
            3 -> "已支付"
            else -> "未知"
        }
    // period 对应的中文描述
    val periodZh: String
        get() = when (period) {
            "month_price" -> "月付"
            "quarter_price" -> "季付"
            "half_year_price" -> "半年付"
            "year_price" -> "年付"
            "two_year_price" -> "两年付"
            "three_year_price" -> "三年付"
            "onetime_price" -> "一次性付"
            else -> ""
        }
}

data class SaveOrderRequest(
//    period=half_year_price&plan_id=2&coupon_code=

val  period: String,
val  plan_id: Int,
val  coupon_code: String?

)


data class PublicResponse(
    val data: String?,
    val message: String?,
    val status: String?
)

data class SubmitOrderResponse(
    val data: String?,
    val message: String?,
    val status: String?
)


data class ConfigResponse (
    val baseURL: String,
    val baseDYURL: String,
    val mainregisterURL: String,
    val paymentURL: String,
    val telegramurl: String,
    val kefuurl: String,
    val websiteURL: String,
    val crisptoken: String,
    val banners: List<String>,
    val message: String,
    val code: Int
)

data class RegisterRequest(val username: String, val password: String)
data class RegisterResponse(val success: Boolean, val message: String)

data class LoginRequest(val email: String, val password: String ,val captchaData: String = "")

data class LoginResponse(val message: String?, val data: LoginData?)


data class LoginData (
    val token: String?,
    val isAdmin: Int?,
    val auth_data: String?
)



data class SubscribeResponse (
    val data: SubscribeData
)


data class SubscribeData  (

    @SerializedName("plan_id") val plan_id : Int?,
    @SerializedName("token") val token : String,
    @SerializedName("expired_at") val expired_at : Long?,
    @SerializedName("u") val u : Long,
    @SerializedName("d") val d : Long,
    @SerializedName("transfer_enable") val transfer_enable : Long?,
    @SerializedName("email") val email : String,
    @SerializedName("uuid") val uuid : String,
    @SerializedName("plan") val plan : PlanData?,
    @SerializedName("subscribe_url") val subscribe_url : String,
    @SerializedName("reset_day") val reset_day : String?

)

data class PlanData (
    @SerializedName("id") val id : Int,
    @SerializedName("group_id") val group_id : Int?,
    @SerializedName("transfer_enable") val transfer_enable : Long?,
    @SerializedName("name") val name : String,
    @SerializedName("speed_limit") val speed_limit : Long?,
    @SerializedName("show") val show : Int?,
    @SerializedName("sort") val sort : Int?,
    @SerializedName("renew") val renew : Int?,
    @SerializedName("content") val content : String,
    @SerializedName("month_price") val month_price : Long?,
    @SerializedName("quarter_price") val quarter_price : Long?,
    @SerializedName("half_year_price") val half_year_price : Long?,
    @SerializedName("year_price") val year_price : Long?,
    @SerializedName("two_year_price") val two_year_price : Long?,
    @SerializedName("three_year_price") val three_year_price : Long?,
    @SerializedName("onetime_price") val onetime_price : Int?,
    @SerializedName("reset_price") val reset_price : Long?,
    @SerializedName("reset_traffic_method") val reset_traffic_method : String?,
    @SerializedName("capacity_limit") val capacity_limit : Long?,
    @SerializedName("created_at") val created_at : Long?,
    @SerializedName("updated_at") val updated_at : Long?
) : Serializable // 添加 Serializable 接口



data class UserInfoResponse (
    val data: UserInfoData
)

data class UserInfoData (
    val email: String,
    val transferEnable: Long?,
    val lastLoginAt: Long,
    val createdAt: Long?,
    val banned: Long?,
    val remindExpire: Long?,
    val remindTraffic: Long?,
    val expiredAt: Long?,
    val balance: Long?,
    val commissionBalance: Long?,
    val uuid: String,
    val avatarURL: String?
)

 data class PlansResponse(
    val data: List<PlanData>?,

    val message: String?,
    val status: String?
)


data class OrdersResponse(
    val `data`: List<OrderData>?,

    val message: String?,
    val status: String?
)

data class OrderData(
    val actual_commission_balance: Any?,
    val balance_amount: Any?,
    val callback_no: Any?,
    val commission_balance: Int?,
    val commission_status: Int?,
    val coupon_code: Any?,
    val coupon_id: Any?,
    val created_at: Long?,
    val discount_amount: Any?,
    val handling_amount: Int?,
    val invite_user_id: Any?,
    val paid_at: Any?,
    val payment_id: Int?,
    val period: String?,
    val plan: PlanData?,
    val plan_id: Int?,
    val refund_amount: Any?,
    val site_id: Any?,
    val status: Int?,
    val surplus_amount: Any?,
    val surplus_order_ids: Any?,
    val tixianstatus: Any?,
    val total_amount: Int?,
    val trade_no: String?,
    val type: Int?,
    val updated_at: Long?
){
    // status 对应的中文描述
    val statusZh: String
        get() = when (status) {
            0 -> "待支付"
            1 -> "已支付"
            2 -> "已取消"
            3 -> "已支付"
            else -> "未知"
        }

    // period 对应的中文描述
    val periodZh: String
        get() = when (period) {
            "month_price" -> "月付"
            "quarter_price" -> "季付"
            "half_year_price" -> "半年付"
            "year_price" -> "年付"
            "two_year_price" -> "两年付"
            "three_year_price" -> "三年付"
            "onetime_price" -> "一次性付"
            else -> ""
        }
}
