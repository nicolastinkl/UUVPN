//
//  ActiveDashboardViewMACOS.swift
//  ApplicationLibrary
//
//  Created by Mac on 2024/10/22.
//

import Foundation
import Libbox
import Library
import SwiftUI

@MainActor
public struct ActiveDashboardViewMACOS: View {
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
                    OverviewView($profileList, $selectedProfileID, $systemProxyAvailable, $systemProxyEnabled)
                }
            #elseif os(macOS)
                OverviewView($profileList, $selectedProfileID, $systemProxyAvailable, $systemProxyEnabled)
            #endif
        }
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
                    //add profile remote
                    
                    Task {
                        if StoreManager.shared.getSuburlData().count > 5 {
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
            print(error)
        }
        environments.profileUpdate.send()
    }
    
    private nonisolated func createProfileBackground() async throws {
        let nextProfileID = try await ProfileManager.nextID()

        var savePath = ""
        let remoteURL: String = StoreManager.shared.getSuburlData()
        var lastUpdated: Date? = nil
        let remoteContent = try HTTPClient().getString(remoteURL)
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
                print("\(profileOne.path) \n \(profileOne.remoteURL ?? "")  \n \(profileOne.id ?? 0 )")
            }
        #else
            try await ProfileUpdateTask.configure()
        #endif
        
    
    }
    
    
}
