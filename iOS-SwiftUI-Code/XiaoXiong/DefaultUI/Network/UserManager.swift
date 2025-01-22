//
//  File.swift
//  LoginKit
//
//  Created by Mac on 2024/10/12.
//

import Foundation
import Foundation


// 创建一个全局的 UserManager 类，负责从 UserDefaults 中读取和存储用户信息及登录状态
class UserManager {
    static let shared = UserManager()  
    
    public let configURL = "https://ios-xiaoxiong.oss-cn-beijing.aliyuncs.com/config.json"
        
    public let appversion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String ?? "1.0.0"
    
    // UserDefaults keys
    private let loginStatusKey = "isLoggedIn"
    private let userEmailKey = "userEmail"
    private let avatarurlKey = "avatar_url"
    private let autodataKey = "autodata"
    private let subURLDataKey = "subURLData"
    private let baseURLKey = "baseURLKey"
    private let crisptoken = "crisptoken"
     
    // UserDefaults 引用
    private let defaults = UserDefaults.standard

    
    func crispTokenData()-> String{
        return defaults.string(forKey: crisptoken) ?? ""
    }
    
    func baseURL()-> String{
        return defaults.string(forKey: "baseURLKey") ?? ""
    }
    
    func baseDYURL()-> String{
        defaults.string(forKey: "baseDYURL") ?? ""
    }
    
    func mainregisterURL()-> String{
        defaults.string(forKey: "mainregisterURLKey") ?? ""
    }
    func paymentURL()-> String{
        defaults.string(forKey: "paymentURLKey") ?? ""
    }
    func telegramUrl()-> String{
        defaults.string(forKey: "telegramUrlKey") ?? ""
    }
    func kefuUrl()-> String{
        defaults.string(forKey: "kefuUrlKey") ?? ""
    }
    func websiteURL()-> String{
        defaults.string(forKey: "websiteURLKey") ?? ""
    }
    
    
    
    func storeCrispTokenData (data: String) {
        defaults.set(data, forKey: crisptoken)
        defaults.synchronize()
    }
    
    //存储 URL 相关信息
    func storebaseURLData(data: String) {
        defaults.set(data, forKey: "baseURLKey")
        defaults.synchronize()
    }
    
    func storemainregisterURLData(data: String) {
        defaults.set(data, forKey: "mainregisterURLKey")
        defaults.synchronize()
    }
    
    func storepaymentURLData(data: String) {
        defaults.set(data, forKey: "paymentURLKey")
        defaults.synchronize()
    }
    
    func storetelegramUrlData(data: String) {
        defaults.set(data, forKey: "telegramUrlKey")
        defaults.synchronize()
    }
    
    func storekefuUrlData(data: String) {
        defaults.set(data, forKey: "kefuUrlKey")
        defaults.synchronize()
    }
    func storewebsiteURLData(data: String) {
        defaults.set(data, forKey: "websiteURLKey")
        defaults.synchronize()
    }
    
    func storebaseDYURL(data:String){
        defaults.setValue(data, forKey: "baseDYURL")
        defaults.synchronize()
    }
    
    
    
    // 更新登录状态
    func updateLoginStatus(_ loggedIn: Bool) {
        defaults.set(loggedIn, forKey: loginStatusKey)
        defaults.synchronize()
    }
    
    func saveUserInfoToLocal(userInfo: UserInfo) {
        do {
            let data = try JSONEncoder().encode(userInfo)
            defaults.set(data, forKey: "userInfo")
            defaults.synchronize()
        } catch {
             
        }
    }
    
    // 检查是否已登录
    func isUserLoggedIn() -> Bool {
        return defaults.bool(forKey: loginStatusKey)
    }

    // 存储用户信息
    func storeUserInfo(email: String, avator: String) {
        defaults.set(email, forKey: userEmailKey)
        defaults.set(avator, forKey: avatarurlKey) // 假设 info 是 JSON 字符串
        defaults.synchronize()
    }

    // 读取用户信息
    func getUserInfo() -> (email: String, avator: String) {
        let email = defaults.string(forKey: userEmailKey) ?? ""
        let avator = defaults.string(forKey: avatarurlKey) ?? ""
        return (email, avator)
    }
    
    // 存储 autodata
    func storeAutoData(data: String) {
        defaults.set(data, forKey: autodataKey)
        defaults.synchronize()
    }

    // 读取 autodata
    func getSuburlData() -> String {
          return defaults.string(forKey: subURLDataKey) ?? ""
    }    
    
    // 存储 autodata
    func storeSuburlData(data: String) {
        defaults.set(data, forKey: subURLDataKey)
        defaults.synchronize()
    }

    // 读取 autodata
    func getAutoData() -> String {
        return defaults.string(forKey: autodataKey) ?? ""
    }
      
    // 清除所有数据（例如在登出时）
    func clearUserData() {
        defaults.removeObject(forKey: loginStatusKey)
        defaults.removeObject(forKey: userEmailKey)
        defaults.removeObject(forKey: avatarurlKey)
        defaults.removeObject(forKey: autodataKey)
        defaults.removeObject(forKey: subURLDataKey)
         
        defaults.removeObject(forKey: "goGrouptag")
        defaults.removeObject(forKey: "selectedNode")
        defaults.removeObject(forKey: "paymentURLKey")
        defaults.removeObject(forKey: "baseDYURL")
        defaults.removeObject(forKey: "serverData")
        defaults.removeObject(forKey: "lastFetchTime")
        
        let dictionary = defaults.dictionaryRepresentation()
      dictionary.keys.forEach { key in
          defaults.removeObject(forKey: key)
      }
        
        
    }
}
