import Foundation
import Libbox
import SwiftUI

public struct OutboundGroupItem: Codable {
    public let tag: String
    public let type: String
    
    public let urlTestTime: Date
    public var urlTestDelay: UInt16
    
    
    public var server: String? = ""
    public var server_port: Int? = 0
    public var method: String? = ""
    public var password: String? = ""

    //server: String?,server_port: String?,method: String?,serverpassword String?
    
    // 手动定义初始化器
    public init(tag: String, type: String, urlTestTime: Date, urlTestDelay: UInt16) {
        self.tag = tag
        self.type = type
        self.urlTestTime = urlTestTime
        self.urlTestDelay = urlTestDelay
    }
    

    
}

public extension OutboundGroupItem {
    
    mutating func setpingms(pingDelay: UInt16){
        urlTestDelay = pingDelay
    }
    
    var toString: String {
        "\(tag) - \(type)  - \(server ?? "")  - \(server_port ?? 0)  - \(method ?? "")  - \(password ?? "") "
    }
    var displayType: String {
        LibboxProxyDisplayType(type)
    }

    var delayString: String {
        "\(urlTestDelay)ms"
    }

    var delayColor: Color {
        switch urlTestDelay {
        case 0:
            return .gray
        case ..<400:
            return .green
        case ..<800:
            return .yellow
        case 800 ..< 1500:
            return .orange
        default:
            return .red
        }
    }
}
