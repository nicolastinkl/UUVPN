import Foundation
import Libbox
import SwiftUI

public struct OutboundGroup: Codable {
    let tag: String
    let type: String
    var selected: String
    let selectable: Bool
    var isExpand: Bool
    let items: [OutboundGroupItem]
    
    
    
    
    var hashValue: Int {
        var value = tag.hashValue
        (value, _) = value.addingReportingOverflow(selected.hashValue)
        for item in items {
            (value, _) = value.addingReportingOverflow(item.urlTestTime.hashValue)
        }
        return value
    }
    
    public init(tag: String, type: String, selected: String, selectable: Bool,isExpand: Bool,items: [OutboundGroupItem] ) {
        self.tag = tag
        self.type = type
        self.selected = selected
        self.selectable = selectable
        self.isExpand = isExpand
        self.items = items
    }
    
    
}


public extension OutboundGroup {
    
    var newhashValue: Int {
        var value = tag.hashValue
        (value, _) = value.addingReportingOverflow(selected.hashValue)
        for item in items {
            (value, _) = value.addingReportingOverflow(item.urlTestTime.hashValue)
        }
        return value
    }
    
}

public extension OutboundGroup {
    var displayType: String {
        LibboxProxyDisplayType(type)
    }
}
