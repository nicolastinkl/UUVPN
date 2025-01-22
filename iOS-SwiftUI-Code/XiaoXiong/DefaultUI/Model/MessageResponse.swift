//
//  File.swift
//  SFI
//
//  Created by Mac on 2024/10/13.
//

import Foundation

struct MessageResponse: Codable {
    let message: String
    let status: String?
    let errors: MessageResponseErrors?

}

// MARK: - Errors
struct MessageResponseErrors: Codable {
    let email: [String]
}
