//
//  PlanResponse.swift
//  SFI
//
//  Created by Mac on 2024/10/12.
//

import Foundation



// MARK: - Welcome
struct PlanResponse: Codable {
    let data: [DatuPlanResponse]?
    let message: String?
}

// MARK: - Datum
struct DatuPlanResponse: Codable,Identifiable {
    var id  = UUID()    
    let idOLD, groupID, transferEnable: Int?
    let name: String
    let deviceLimit: Int?
    let show: Int?
    let renew: Int?
    let content: String?
    let monthPrice, quarterPrice, halfYearPrice, yearPrice: Int?
    let onetimePrice: Int?
    let createdAt, updatedAt: Int?

    enum CodingKeys: String, CodingKey {
        case idOLD = "id"
        case groupID = "group_id"
        case transferEnable = "transfer_enable"
        case name
        case deviceLimit = "device_limit"
        case show,  renew, content
        case monthPrice = "month_price"
        case quarterPrice = "quarter_price"
        case halfYearPrice = "half_year_price"
        case yearPrice = "year_price"
        case onetimePrice = "onetime_price"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
