//
//  File.swift
//  SFI
//
//  Created by Mac on 2024/10/12.
//

import Foundation

// MARK: - Welcome
struct SubscribeReponse: Codable {
    let data: SubscribeReponseClass?
    let message: String?
}

// MARK: - DataClass
struct SubscribeReponseClass: Codable {
    let planID: Int?
    let token: String
    
    let u, d, transferEnable: Int
    
    let email, uuid: String
    let plan: Plan?
    let subscribeURL: String
    

    enum CodingKeys: String, CodingKey {
        case planID = "plan_id"
        case token
        case u, d
        case transferEnable = "transfer_enable"
        case email, uuid, plan
        case subscribeURL = "subscribe_url"
    }
}

// MARK: - Plan
struct Plan: Codable {
    let id, groupID: Int
    let name: String
    
    let show,renew: Int
    
    let content: String?
    let monthPrice, quarterPrice, halfYearPrice, yearPrice: Int?
    let onetimePrice: Int?
    let createdAt, updatedAt: Int

    enum CodingKeys: String, CodingKey {
        case id
        case groupID = "group_id"
        
        case name
        
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
