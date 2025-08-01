import ApplicationLibrary
import Foundation
import Libbox
import Library
import Network
import UIKit

/// UUVPN应用代理
/// 管理应用生命周期、后台任务和VPN配置
class ApplicationDelegate: NSObject, UIApplicationDelegate {
    /// 配置文件服务器（仅iOS 16+）
    private var profileServer: ProfileServer?

    /// 应用启动完成处理
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // 初始化Libbox VPN框架
        LibboxSetup(FilePath.sharedDirectory.relativePath, FilePath.workingDirectory.relativePath, FilePath.cacheDirectory.relativePath, false)
        setup()
        return true
    }

    /// 配置后台服务
    private func setup() {
        do {
            // 配置后台配置文件更新任务
            try UIProfileUpdateTask.configure()
            NSLog("setup background task success")
        } catch {
            NSLog("setup background task error: \(error.localizedDescription)")
        }
        
        // 执行异步设置任务
        Task {
            if UIDevice.current.userInterfaceIdiom == .phone {
                // 为iPhone设备请求网络权限
                await requestNetworkPermission()
            }
            // 初始化后台配置文件服务器
            await setupBackground()
        }
    }

    /// 设置后台配置文件服务器（仅iOS 16+）
    private nonisolated func setupBackground() async {
      
        if #available(iOS 16.0, *) {
            do {
                let profileServer = try ProfileServer()
                profileServer.start()
                
                // 在主线程更新配置文件服务器引用
                await MainActor.run {
                    self.profileServer = profileServer
                }
                NSLog("started profile server")
            } catch {
                NSLog("setup profile server error: \(error.localizedDescription)")
            }
        }
    }

    /// 为中国设备请求网络权限
     private nonisolated func requestNetworkPermission() async {
           if await SharedPreferences.networkPermissionRequested.get() {
               return
           }
           if !DeviceCensorship.isChinaDevice() {
               await SharedPreferences.networkPermissionRequested.set(true)
               return
           }
           URLSession.shared.dataTask(with: URL(string: "http://captive.apple.com")!) { _, response, _ in
               if let response = response as? HTTPURLResponse {
                   if response.statusCode == 200 {
                       Task {
                           await SharedPreferences.networkPermissionRequested.set(true)
                       }
                   }
               }
           }.resume()
       }
   }
