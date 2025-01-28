//
//  ActiveDashboardViewNewUI.swift
//  SFI
//
//  Created by Zeus on 2024/10/11.
//

import Foundation

import Foundation
import Libbox
import Library
import SwiftUI
import ApplicationLibrary

@MainActor
public struct ActiveDashboardViewNewUI: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.selection) private var parentSelection
    @EnvironmentObject private var environments: ExtensionEnvironments
    @EnvironmentObject private var profile: ExtensionProfile
    @State private var isLoading = true
    @State private var profileList: [ProfilePreview] = []
    @State private var selectedProfileID: Int64 = 0
    @State private var alert: Alert?
    @State private var selection = DashboardPage.overview
    @State private var systemProxyAvailable = false
    @State private var systemProxyEnabled = false
 
    @State private var alerthandleXufei = false
    @State private var tixingdingyueEnabled = false
    
    public init() {}
    public var body: some View {
        if isLoading {
            ProgressView().onAppear {
                Task {
                    await doReload()
                }
            }
        } else {
            if ApplicationLibrary.inPreview {
                body1
            } else {
                body1
                    .onAppear {
                        Task {
                            await doReloadSystemProxy()
                        }
                    }
                    .onChangeCompat(of: profile.status) { newStatus in
                        if newStatus == .connected {
                            Task {
                                await doReloadSystemProxy()
                            }
                        }
                    }
            }
        }
    }

    private var body1: some View {
        VStack {
            #if os(iOS) || os(tvOS)
                if ApplicationLibrary.inPreview || profile.status.isConnectedStrict {
                   /* Picker("Page", selection: $selection) {
                        ForEach(DashboardPage.allCases) { page in
                            page.label
                        }
                    }
                    .pickerStyle(.segmented)
                    #if os(iOS)
                        .padding([.leading, .trailing])
                        .navigationBarTitleDisplayMode(.inline)
                    #endif
                    TabView(selection: $selection) {
                        ForEach(DashboardPage.allCases) { page in
                            page.contentView($profileList, $selectedProfileID, $systemProxyAvailable, $systemProxyEnabled)
                                .tag(page)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    */
                    OverviewView($profileList, $selectedProfileID, $systemProxyAvailable, $systemProxyEnabled)
                } else {
                    if tixingdingyueEnabled  {
                        XufeiTixingButton {
                            alerthandleXufei = true
                        }.alert(Text("续费提醒"), isPresented: $alerthandleXufei) {
                            Button("续费"){
                                environments.opentixingSubnodes.send()
                            }
                        } message: {
                            Text("您的账户已经过期，请续费后继续体验畅快感受；如果您刚购买完请耐心等待，会员时长会在1分钟内到账。")
                        }

                    }else{
                        OverviewView($profileList, $selectedProfileID, $systemProxyAvailable, $systemProxyEnabled)
                    }
                    
                }
            #elseif os(macOS)
                OverviewView($profileList, $selectedProfileID, $systemProxyAvailable, $systemProxyEnabled)
            #endif
        }.onReceive(environments.updateTixingdingyueEnabled, perform: { _ in
            tixingdingyueEnabled = false
        })
        .onReceive(environments.profileUpdate) { _ in
            
            Task {
                await doReload()
            }
        }
        .onReceive(environments.selectedProfileUpdate) { _ in
            Task {
                selectedProfileID = await SharedPreferences.selectedProfileID.get()
                if profile.status.isConnected {
                    await doReloadSystemProxy()
                }
            }
        }
        .alertBinding($alert)
    }

     
    
    private func doReload() async {
        defer {
            isLoading = false
        }
        if ApplicationLibrary.inPreview {
            profileList = [
                ProfilePreview(Profile(id: 0, name: "profile local", type: .local, path: "")),
                ProfilePreview(Profile(id: 1, name: "profile remote", type: .remote, path: "", lastUpdated: Date(timeIntervalSince1970: 0))),
            ]
            systemProxyAvailable = true
            systemProxyEnabled = true
            selectedProfileID = 0

        } else {
            do {
                profileList = try await ProfileManager.list().map { ProfilePreview($0) }
                if profileList.isEmpty {
                    print("profileList.isEmpty 是否提醒续费\(tixingdingyueEnabled), \(UserManager.shared.getSuburlData().count)")
                    //add profile remote
                    if   tixingdingyueEnabled {
                        return
                    }
                    Task {
                        if UserManager.shared.getSuburlData().count > 5 {
                            await createProfile()
                        }
                    }
                    
                    await environments.reload()
                    
                    return
                }
                selectedProfileID = await SharedPreferences.selectedProfileID.get()
                if profileList.filter({ profile in
                    profile.id == selectedProfileID
                })
                .isEmpty {
                    selectedProfileID = profileList[0].id
                    await SharedPreferences.selectedProfileID.set(selectedProfileID)
                }
                
                
//                try await ProfileManager.list().forEach { p in
//                    await ProfileManager.update(p)
//                }
                
                
            } catch {
                alert = Alert(error)
                return
            }
        }
        environments.emptyProfiles = profileList.isEmpty
    }

    private nonisolated func doReloadSystemProxy() async {
        do {
            let status = try LibboxNewStandaloneCommandClient()!.getSystemProxyStatus()
            await MainActor.run {
                systemProxyAvailable = status.available
                systemProxyEnabled = status.enabled
            }
        } catch {
            await MainActor.run {
                alert = Alert(error)
            }
        }
    }
    
    
    private func createProfile() async {
        do {
            try await createProfileBackground()
        } catch {
        
            print("createProfile : \(error)")
        }
        environments.profileUpdate.send()
    }
    
    private nonisolated func createProfileBackground() async throws {
        print("正在创建 profile")
         
        let nextProfileID = try await ProfileManager.nextID()
        
        var savePath = ""
        let remoteURL: String = UserManager.shared.getSuburlData()
        var lastUpdated: Date? = nil
        var remoteContent = try HTTPClient().getString(remoteURL)
        print("第一次订阅URL的内容 remoteContent: \(remoteContent.count)")
        if(remoteContent.count < 3 && UserManager.shared.paymentURL().count < 3){
            //TODO：  苹果审核(当当前用户没有续费时，随便注册账号，且在苹果审核的时候注册安装后,直接给默认流量地址)
            //节点数据为空，那么直接去订阅一个默认小流量的节点位置，免费的
            remoteContent = try HTTPClient().getString(UserManager.shared.baseDYURL())
            print("请求服务器的议定 remoteContent: \(remoteContent.count)")
            
        }else{
            if(remoteContent.count < 3){
                
                //提醒续费，正常用户
                print("提醒续费，正常用户")
                await MainActor.run {
                    tixingdingyueEnabled = true
                }
            }else{
                print("正常有订阅的付费客户")
                //正常有订阅的付费客户
                await MainActor.run {
                    tixingdingyueEnabled = false
                }
            }
        }
        
        
        if remoteContent.isEmpty {
            return
        }
        var error: NSError?
        LibboxCheckConfig(remoteContent, &error)
        if let error {
            
            throw error
             
        }
        let profileConfigDirectory = FilePath.sharedDirectory.appendingPathComponent("configs", isDirectory: true)
        try FileManager.default.createDirectory(at: profileConfigDirectory, withIntermediateDirectories: true)
        let profileConfig = profileConfigDirectory.appendingPathComponent("config_\(nextProfileID).json")
        try remoteContent.write(to: profileConfig, atomically: true, encoding: .utf8)
        savePath = profileConfig.relativePath
        
        lastUpdated = .now
        
        try await ProfileManager.create(Profile(
            name: "VPN",
            type: ProfileType.remote,
            path: savePath,
            remoteURL: remoteURL,
            autoUpdate: true,
            autoUpdateInterval: 60,
            lastUpdated: lastUpdated
        ))
        
        #if os(iOS) || os(tvOS)
            try  UIProfileUpdateTask.configure()
            let list = try await ProfileManager.list()
            list.forEach { profileOne in
                print("createProfileBackground 查询到所有订阅节点：{ \n \(profileOne.id ?? 0 ) \(profileOne.path) \n \(profileOne.remoteURL ?? "")  }")
            }
            await MainActor.run {
                  environments.openProfileGetSuccess.send()
            }
        #else
            try await ProfileUpdateTask.configure()
        #endif
        
    
    }
    
    
}
