//
//  TicketsReponse.swift
//  SFI
//
//  Created by Mac on 2024/10/20.
//

import Foundation


// MARK: - Welcome
struct TicketsReponse: Codable {
    let status, message: String?
    let data: [TicketsReponseDatum]?
}

//Message
// MARK: - Datum
struct TicketsReponseDatum: Codable,Identifiable {
    var id = UUID().uuidString
    let idOLD, level, replyStatus, status: Int
    let subject: String
    let message: String?
    let createdAt, updatedAt, userID: Int

    enum CodingKeys: String, CodingKey {
        case idOLD = "id"
        case  level
        case replyStatus = "reply_status"
        case status, subject, message
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userID = "user_id"
    }
}

