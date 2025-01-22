import Foundation
import SwiftUI
#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

public extension Color {
    static var textColor: Color {
        #if canImport(UIKit)
        if #available(iOSApplicationExtension 15.0, *) {
            return Color(uiColor: .label)
        }else{
            return Color.black
        }

        #elseif canImport(AppKit)
            return Color(nsColor: .textColor)
        #endif
    }

    static var linkColor: Color {
        #if canImport(UIKit)
        if #available(iOSApplicationExtension 15.0, *) {
            return Color(uiColor: .link)
        }else{
            return Color.black
        }

        #elseif canImport(AppKit)
            return Color(nsColor: .linkColor)
        #endif
    }
}
