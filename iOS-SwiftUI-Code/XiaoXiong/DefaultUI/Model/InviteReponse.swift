//
//  InviteReponse.swift
//  SFI
//
//  Created by Mac on 2024/10/21.
//

import Foundation

// MARK: - Welcome
struct InviteReponse: Codable {
    let status, message: String?
    let data: InviteReponseDataClass?
}

// MARK: - DataClass
struct InviteReponseDataClass: Codable {
    let codes: [InviteCode]?
    let stat: [Int]?
}

// MARK: - Code
struct InviteCode: Codable,Identifiable {
    var id = UUID().uuidString
    let userID: Int
    let code: String
    let createdAt:Int

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case code
        case createdAt = "created_at"
    }
}

