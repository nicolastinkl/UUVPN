import Foundation
import Library
import SwiftUI

/// UUVPN iOS应用程序入口点
/// 管理应用生命周期和视图路由，根据登录状态显示相应界面
@main
struct Application: App {
    /// 应用代理适配器
    @UIApplicationDelegateAdaptor private var appDelegate: ApplicationDelegate
    
    /// VPN扩展环境管理
    @StateObject private var environments = ExtensionEnvironments()
    
    /// 用户登录状态
    @State private var isLoggedIn = UserManager.shared.isUserLoggedIn()
    
    var body: some Scene {
        WindowGroup { 
            // 根据登录状态显示界面
            if isLoggedIn {
                // 已登录：显示主界面
                HomeView(isLoggedIn: $isLoggedIn).environmentObject(environments)
            } else {
                // 未登录：显示登录界面
                LoginContentView(isLoggedIn: $isLoggedIn)
            }             
        }
    }
}
