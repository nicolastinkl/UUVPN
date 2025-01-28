//
//  PaymentReponse.swift
//  SFI
//
//  Created by Mac on 2024/10/21.
//

import Foundation

// MARK: - PaymentReponse
struct PaymentReponse: Codable {
    let status, message: String?
    let data: [PaymentReponseDatum]?
}

// MARK: - Datum
struct PaymentReponseDatum: Codable {
    let id: Int
    let name, payment: String
    let icon,handlingFeePercent,handlingFeeFixed: String?

    enum CodingKeys: String, CodingKey {
        case id, name, payment, icon
        case handlingFeeFixed = "handling_fee_fixed"
        case handlingFeePercent = "handling_fee_percent"
    }
}

