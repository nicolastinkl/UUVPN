//
//  UserInfo.swift
//  LoginKit
//
//  Created by Mac on 2024/10/12.
//

import Foundation
struct UserInfo: Codable {
    struct Data: Codable {
        let email: String
        let transfer_enable: Int
        let device_limit: Int?
        let last_login_at: Int
        let created_at: Int
        let banned: Int
        let remind_expire: Int
        let remind_traffic: Int
        let expired_at: Int?
        let balance: Int
        let commission_balance: Int
        let plan_id: Int
        let discount: Int?
        let commission_rate: Int?
        let telegram_id: Int?
        let uuid: String
        let avatar_url: String
    }
    let data: Data
}
