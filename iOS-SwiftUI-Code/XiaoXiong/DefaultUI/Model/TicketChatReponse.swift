//
//  TicketChatReponse.swift
//  SFI
//
//  Created by Mac on 2024/10/20.
//

import Foundation

// MARK: - TicketChatReponse
struct TicketChatReponse: Codable {
    let status, message: String?
    let data: TicketChatReponseDataClass?
}

// MARK: - DataClass
struct TicketChatReponseDataClass: Codable {
    
    
    let id,   level, replyStatus, status: Int
    let subject: String
    let message: [Message]
    let createdAt, updatedAt, userID: Int

    enum CodingKeys: String, CodingKey {
        case id
        case  level
        case replyStatus = "reply_status"
        case status, subject, message
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userID = "user_id"
    }
}

struct Message: Codable ,Identifiable,Equatable {
    var id = UUID().uuidString
    let idold, ticketID: Int
    let isMe: Bool
    let message: String
    let photo:String?
    let createdAt, updatedAt: Int
    let   profilePic : String?

    enum CodingKeys: String, CodingKey {
        case idold = "id"
        case ticketID = "ticket_id"
        case isMe = "is_me"
        case message
        case photo
        case profilePic
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

