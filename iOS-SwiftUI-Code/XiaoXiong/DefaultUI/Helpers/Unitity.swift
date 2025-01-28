//
//  Unitity.swift
//  SFI
//
//  Created by Mac on 2024/10/20.
//

import Foundation

struct TimestampConverter {
    
    // Function to convert a timestamp to a formatted date string
    static func convertTimestampToDateString(_ timestamp: Int, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let timeInterval = TimeInterval(timestamp)
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
