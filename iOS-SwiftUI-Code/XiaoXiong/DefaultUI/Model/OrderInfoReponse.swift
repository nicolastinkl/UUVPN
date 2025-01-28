//
//  File.swift
//  SFI
//
//  Created by Mac on 2024/10/21.
//

import Foundation

// MARK: - OrderInfoReponse
struct OrderInfoReponse: Codable {
    let status, message: String?
    let data: [OrderInfoDatum]?
}

struct OrderInfoSingleReponse: Codable {
    let status, message: String?
    let data: OrderInfoDatum?
}


// MARK: - Datum
struct OrderInfoDatum: Codable ,Identifiable {
    var id = UUID().uuidString
    let inviteUserID: String?
    let planID: Int?
    let siteID, couponID: String?
    let type: Int
    let period: String
    let couponCode: String?
    let tradeNo: String
    let callbackNo: String?
    let totalAmount: Double
    let handlingAmount, discountAmount, surplusAmount, refundAmount: Double?
    let balanceAmount, surplusOrderIDS,paymentID: Int?
    let status: Int
    let actualCommissionBalance, paidAt: String?
    let createdAt, updatedAt: Int
    let commissionStatus, commissionBalance: Int?
    let tixianstatus: String?
    let plan: PlanOrder
    
    var status_zh: String {
        switch status {
        case 0:
            return "待支付"
        case 1:
            return "已支付"
        case 2:
            return "已取消"
        default:
            return "未知"
        }
    }
    
    var period_zh: String {
        switch period {
        case "month_price":
            return "月付"
        case "quarter_price":
            return "季付"
        case "half_year_price":
            return "半年付"
        case "year_price":
            return "年付"
        default:
            return "月付"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case inviteUserID = "invite_user_id"
        case planID = "plan_id"
        case siteID = "site_id"
        case couponID = "coupon_id"
        case paymentID = "payment_id"
        case type, period
        case couponCode = "coupon_code"
        case tradeNo = "trade_no"
        case callbackNo = "callback_no"
        case totalAmount = "total_amount"
        case handlingAmount = "handling_amount"
        case discountAmount = "discount_amount"
        case surplusAmount = "surplus_amount"
        case refundAmount = "refund_amount"
        case balanceAmount = "balance_amount"
        case surplusOrderIDS = "surplus_order_ids"
        case status
        case commissionStatus = "commission_status"
        case commissionBalance = "commission_balance"
        case actualCommissionBalance = "actual_commission_balance"
        case paidAt = "paid_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case tixianstatus, plan
    }
}

// MARK: - Plan
struct PlanOrder: Codable {
    let id: Int
    let name: String
    let speedLimit: Int?
    let show, sort, renew, groupID, transferEnable: Int?
    let content: String
    let monthPrice, quarterPrice, halfYearPrice, yearPrice: Int?
    let twoYearPrice, threeYearPrice, onetimePrice, resetPrice: Double?
    let resetTrafficMethod: Int?
    let capacityLimit: Int?
    let createdAt, updatedAt: Int

    enum CodingKeys: String, CodingKey {
        case id
        case groupID = "group_id"
        case transferEnable = "transfer_enable"
        case name
        case speedLimit = "speed_limit"
        case show, sort, renew, content
        case monthPrice = "month_price"
        case quarterPrice = "quarter_price"
        case halfYearPrice = "half_year_price"
        case yearPrice = "year_price"
        case twoYearPrice = "two_year_price"
        case threeYearPrice = "three_year_price"
        case onetimePrice = "onetime_price"
        case resetPrice = "reset_price"
        case resetTrafficMethod = "reset_traffic_method"
        case capacityLimit = "capacity_limit"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
 
