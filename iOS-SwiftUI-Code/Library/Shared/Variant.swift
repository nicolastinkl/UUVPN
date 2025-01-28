import Foundation

public enum Variant {
    #if os(macOS)
        public static var useSystemExtension = false
    #else
        public static let useSystemExtension = false
    #endif

    #if os(iOS)
        public static let applicationName = "小熊加速器"
    #elseif os(macOS)
        public static let applicationName = "小熊加速器"
    #elseif os(tvOS)
        public static let applicationName = "小熊加速器"
    #endif
}
