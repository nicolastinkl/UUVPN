//
//  Nodes.swift
//  SFI
//
//  Created by Mac on 2024/10/13.
//

import Foundation
// MARK: - Welcome
struct nodereponse: Codable {
    let data: [nodereponseData]?
    let message: String?
}

// MARK: - Datum
struct nodereponseData: Codable,Identifiable {
//    let id: Int
    var id = UUID().uuidString
    
    let type, name, rate: String
    let id2, isOnline: Int
    let cacheKey: String

    enum CodingKeys: String, CodingKey {
        case   type, name, rate
        case isOnline = "is_online"
        case id2 = "id"
        case cacheKey = "cache_key"
    }
}
