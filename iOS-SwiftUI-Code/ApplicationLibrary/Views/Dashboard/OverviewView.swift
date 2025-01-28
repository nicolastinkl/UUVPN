import Foundation
import Libbox
import Library
import SwiftUI

@MainActor
public struct OverviewView: View {
    @Environment(\.selection) private var selection
    @EnvironmentObject private var environments: ExtensionEnvironments
    @EnvironmentObject private var profile: ExtensionProfile
    @Binding private var profileList: [ProfilePreview]
    @Binding private var selectedProfileID: Int64
    @Binding private var systemProxyAvailable: Bool
    @Binding private var systemProxyEnabled: Bool
    @State private var alert: Alert?
    @State private var reasserting = false

    private var selectedProfileIDLocal: Binding<Int64> {
        $selectedProfileID.withSetter { newValue in
            reasserting = true
            Task { [self] in
                await switchProfile(newValue)
            }
        }
    }

    public init(_ profileList: Binding<[ProfilePreview]>, _ selectedProfileID: Binding<Int64>, _ systemProxyAvailable: Binding<Bool>, _ systemProxyEnabled: Binding<Bool>) {
        _profileList = profileList
        _selectedProfileID = selectedProfileID
        _systemProxyAvailable = systemProxyAvailable
        _systemProxyEnabled = systemProxyEnabled
    }

    public var body: some View {
        if profileList.isEmpty
        {
            VStack {
                
                parsePowerButton()
                
            }.alertBinding($alert)
            
        }else{
            VStack {
                #if os(iOS) || os(tvOS)
                    StartStopButton()
                #elseif os(macOS)
                    StartStopButton().buttonStyle(PlainButtonStyle()) // 移除按钮的默认样式
                #endif
                
                if ApplicationLibrary.inPreview || profile.status.isConnected {
                    ClashModeView()
                    ExtensionStatusView()
                    Spacer()
                }
            }.alertBinding($alert)
                .disabled(!ApplicationLibrary.inPreview && (!profile.status.isSwitchable || reasserting))
        }
       
    }
    
    @ViewBuilder
    func parsePowerButton()->some View{
        VStack{
            Button {
                
                
            } label: {
                
                ZStack{
                    
                    ZStack{
                        
                        LottieView(animationFileName: "1d2a0fe5" , loopMode: .playOnce).scaleEffect(0.2)
                       
                    }
                    
                }
                // Max Frame...
                .frame(width: 190,height: 190)
                .background(
                    
                    ZStack{
                        
                        // Rings....
                        Circle()
                            .trim(from: 0.3, to: 0.5)
                            .stroke(
                                
                                LinearGradient(colors: [
                                    
                                    Color("gray"),
                                    Color("gray")
                                        .opacity(0.5),
                                    Color("gray")
                                        .opacity(0.3),
                                    Color( "gray")
                                        .opacity(0.1),
                                    
                                ], startPoint: .leading, endPoint: .trailing),
                                
                                style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round)
                            )
                        // Shadows...
                            .shadow(color: Color( "gray"), radius: 5, x: 1, y: -4)
                        
                        Circle()
                            .trim(from:   0.3, to: 0.55)
                            .stroke(
                                
                                LinearGradient(colors: [
                                    
                                    Color( "gray2"),
                                    Color( "gray2")
                                        .opacity(0.5),
                                    Color("gray2")
                                        .opacity(0.3),
                                    Color( "gray2")
                                        .opacity(0.1),
                                    
                                ], startPoint: .leading, endPoint: .trailing),
                                
                                style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round)
                            )
                        // Shadows...
                            .shadow(color: Color( "gray2"), radius: 5, x: 1, y: -4)
                            .rotationEffect(.init(degrees: 160))
                        
                        // Main Little Ring...
                        Circle()
                            .stroke(
                                
                                Color("Ring1")
                                    .opacity(0.01),
                                lineWidth: 11
                            )
                        // Toggling Shadow when button is Clicked...
                            .shadow(color: Color("Ring2").opacity( 0), radius: 5, x: 1, y: -4)
                    }
                    
                    
                )
                
            }.padding().disabled(true)
            //            .padding(.top,UIScreen.main.bounds.height < 750 ? 30 : 100)
            Text("正在初始化...").font(.system(size: 18, weight: .semibold)).foregroundStyle(.white)
        }

    }
    
    public var bodyOld: some View {
        VStack {
            
            if profileList.isEmpty {
                VStack{
                    LottieView(animationFileName: "8c31d47d" , loopMode: .loop)
                } .aspectRatio(contentMode: .fill)
                  .scaleEffect(0.1).frame(width: 190,height: 190).padding()
//                VStack{
//                    LottieView(animationFileName: "51a05581" , loopMode: .loop)
//                }.padding()
//                Spacer()
                
                //Text("Empty profiles")
                //retry download profiles
                
            } else {
           
                #if os(iOS) || os(tvOS)
                    StartStopButton()
                      /**
                       Picker("Profile", selection: selectedProfileIDLocal, content: {
                           ForEach(profileList, id: \.self) { it in
                               Text(it.name).tag(it.id)
                               
                           }
                       })
                       .pickerStyle(.segmented)
                       .padding([.top], 8)
                       
                       */
                
                      
                
//                        Section("Profile") {
//                           Picker(selection: selectedProfileIDLocal) {
//                               ForEach(profileList, id: \.id) { profile in
//                                   Text(profile.name).tag(profile.id)
//                               }
//                           } label: {}
//                            .pickerStyle(.inline)
//                       }
                       
                        
                #elseif os(macOS)
                    StartStopButton().buttonStyle(PlainButtonStyle()) // 移除按钮的默认样式

                /*if ApplicationLibrary.inPreview || profile.status.isConnectedStrict, systemProxyAvailable {
                        Toggle("HTTP Proxy", isOn: $systemProxyEnabled)
                            .onChangeCompat(of: systemProxyEnabled) { newValue in
                                Task {
                                    await setSystemProxyEnabled(newValue)
                                }
                            }
                    }
                    Section("Profile") {
                        ForEach(profileList, id: \.id) { profile in
                            Picker(profile.name, selection: selectedProfileIDLocal) {
                                Text("").tag(profile.id)
                            }
                        }
                        .pickerStyle(.radioGroup)
                    }*/
                #endif
                /*
                FormView {
                    #if os(iOS) || os(tvOS)
                        StartStopButton()
                        if ApplicationLibrary.inPreview || profile.status.isConnectedStrict, systemProxyAvailable {
                            Toggle("HTTP Proxy", isOn: $systemProxyEnabled)
                                .onChangeCompat(of: systemProxyEnabled) { newValue in
                                    Task {
                                        await setSystemProxyEnabled(newValue)
                                    }
                                }
                        }
                    
                        /*
                         // Profile订阅列表
                         Section("Profile") {
                            Picker(selection: selectedProfileIDLocal) {
                                ForEach(profileList, id: \.id) { profile in
                                    Text(profile.name).tag(profile.id)
                                }
                            } label: {}
                                .pickerStyle(.inline)
                        }*/
                    #elseif os(macOS)
                        if ApplicationLibrary.inPreview || profile.status.isConnectedStrict, systemProxyAvailable {
                            Toggle("HTTP Proxy", isOn: $systemProxyEnabled)
                                .onChangeCompat(of: systemProxyEnabled) { newValue in
                                    Task {
                                        await setSystemProxyEnabled(newValue)
                                    }
                                }
                        }
                        Section("Profile") {
                            ForEach(profileList, id: \.id) { profile in
                                Picker(profile.name, selection: selectedProfileIDLocal) {
                                    Text("").tag(profile.id)
                                }
                            }
                            .pickerStyle(.radioGroup)
                        }
                    #endif
                }
            */
                
                if ApplicationLibrary.inPreview || profile.status.isConnected {
                    ClashModeView()
                    ExtensionStatusView()
                }
            }
        }
        .alertBinding($alert)
        .disabled(!ApplicationLibrary.inPreview && (!profile.status.isSwitchable || reasserting))
    }

    private func switchProfile(_ newProfileID: Int64) async {
        await SharedPreferences.selectedProfileID.set(newProfileID)
        environments.selectedProfileUpdate.send()
        if profile.status.isConnected {
            do {
                try await serviceReload()
            } catch {
                alert = Alert(error)
            }
        }
        reasserting = false
    }

    private nonisolated func serviceReload() async throws {
        try LibboxNewStandaloneCommandClient()!.serviceReload()
    }

    private nonisolated func setSystemProxyEnabled(_ isEnabled: Bool) async {
        do {
            try LibboxNewStandaloneCommandClient()!.setSystemProxyEnabled(isEnabled)
            await SharedPreferences.systemProxyEnabled.set(isEnabled)
        } catch {
            await MainActor.run {
                alert = Alert(error)
            }
        }
    }
}
