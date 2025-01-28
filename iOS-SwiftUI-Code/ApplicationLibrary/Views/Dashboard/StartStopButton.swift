import Library
import Lottie
import NetworkExtension
import SwiftUI
import Libbox
import Library
import SwiftUI

@MainActor
public struct StartStopButton: View {
    @EnvironmentObject private var environments: ExtensionEnvironments

    public init() {}

    public var body: some View {
        viewBuilder {
            if ApplicationLibrary.inPreview {
                #if os(iOS) || os(tvOS)
                    Toggle(isOn: .constant(true)) {
                        Text("Enabled")
                    }
                #elseif os(macOS)
                    Button {} label: {
                        Label("Stop", systemImage: "stop.fill")
                    }
                #endif

            } else if let profile = environments.extensionProfile {
                Button0().environmentObject(profile)
            } else {
                #if os(iOS) || os(tvOS)
                    EmptyView()                
                #elseif os(macOS)
                    Button {} label: {
                        Label("Start", systemImage: "play.fill")
                    }
                    .disabled(true)
                #endif
            }
        }
        .disabled(environments.emptyProfiles)
    }

    private struct Button0: View {
        @EnvironmentObject private var environments: ExtensionEnvironments
        @EnvironmentObject private var profile: ExtensionProfile
        @State private var alert: Alert?
        @State var vpnStatus : NEVPNStatus = .invalid
        var body: some View {
            viewBuilder {
                #if os(iOS) || os(tvOS)
                   /* Toggle(isOn: Binding(get: {
                        profile.status.isConnected
                    }, set: { newValue, _ in
                        Task {
                            await switchProfile(newValue)
                        }
                    })) {
                        Text("Enabled")
                    }*/
                VStack{
                    PowerButton()
                     
                     Label {
                         if vpnStatus == .connected {
                             Text("已连接")
                         }else if vpnStatus == .disconnected {
                             Text("断开连接")
                         }else if vpnStatus == .connecting {
                             Text("连接中...")
                         }else if vpnStatus == .disconnecting {
                             Text("断开中...")
                         }else {
                             Text("切换中...")
                         }
                     
                     } icon: {
                         Image(systemName: vpnStatus.isConnectedStrict ? "checkmark.shield" : "shield.slash")
                     }
                     .font(.system(size: 18, weight: .semibold))
//                     Spacer()
                    
                }
                 
                #elseif os(macOS)
                
                VStack{
                    PowerButton().background(Color.clear)
                     
                     Label {
                         if vpnStatus == .connected {
                             Text("已连接")
                         }else if vpnStatus == .disconnected {
                             Text("断开连接")
                         }else if vpnStatus == .connecting {
                             Text("连接中...")
                         }else if vpnStatus == .disconnecting {
                             Text("断开中...")
                         }else {
                             Text("切换中...")
                         }
                     } icon: {
                         Image(systemName: vpnStatus.isConnectedStrict ? "checkmark.shield" : "shield.slash")
                     }
                     .font(.system(size: 18, weight: .semibold))
                     //Spacer()
                    
                }
                
                /*Button {
                        Task {
                            await switchProfile(!profile.status.isConnectedStrict)
                        }
                    } label: {
                        if !profile.status.isConnected {
                            Label("Start", systemImage: "play.fill")
                        } else {
                            Label("Stop", systemImage: "stop.fill")
                        }
                    }
                */
                #endif
            }
            .disabled(!profile.status.isEnabled)
            .alertBinding($alert)
            .onAppear {
                Task{
                    vpnStatus = profile.status //.isConnected
                }
            }.onChangeCompat(of: profile.status) { newStatus in
                
                vpnStatus = newStatus
//                if newStatus == .connected {
//                    Task {
//                        await doReloadSystemProxy()
//                    }
//                }
            }
        }
        
        @ViewBuilder
        func PowerButton()->some View{
            
            Button {
               
                Task {
                    if self.vpnStatus.isConnected {
                        await switchProfile(false)
                    }else{
                        await switchProfile(true)
                    }
                    
                }
          
                
                
            } label: {

                ZStack{
                  
                    ZStack{
                        #if os(iOS) || os(tvOS)
                        #endif
                        if vpnStatus == .connected {
                            LottieView(animationFileName: "51a05581" , loopMode: .playOnce).scaleEffect(0.5)
                        }else  if (vpnStatus == .connecting || vpnStatus == .disconnecting) {
                           LottieView(animationFileName: "65ea130a" , loopMode: .loop)
                        }  else{
                           LottieView(animationFileName: "1d2a0fe5" , loopMode: .playOnce).scaleEffect(0.2)
                        }
                        
                    }

                }
                // Max Frame...
                .frame(width: 190,height: 190)
                .background(
                   
                    ZStack{
                        
                        // Rings....
                        Circle()
                            .trim(from: vpnStatus.isConnected ? 0 : 0.3, to: vpnStatus.isConnected ? 1 : 0.5)
                            .stroke(
                            
                                LinearGradient(colors: [
                                
                                    Color(vpnStatus.isConnected ? "Ring1" : "gray"),
                                    Color(vpnStatus.isConnected ? "Ring1" : "gray")
                                        .opacity(0.5),
                                    Color(vpnStatus.isConnected ? "Ring1" : "gray")
                                        .opacity(0.3),
                                    Color(vpnStatus.isConnected ? "Ring1" : "gray")
                                        .opacity(0.1),
                                    
                                ], startPoint: .leading, endPoint: .trailing),
                                
                                style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round)
                            )
                        // Shadows...
                            .shadow(color: Color(vpnStatus.isConnected ? "Ring1" : "gray"), radius: 5, x: 1, y: -4)
                        
                        Circle()
                            .trim(from: vpnStatus.isConnected ? 0 : 0.3, to: vpnStatus.isConnected ? 1 : 0.55)
                            .stroke(
                            
                                LinearGradient(colors: [
                                
                                    Color(vpnStatus.isConnected ? "Ring2" : "gray2"),
                                    Color(vpnStatus.isConnected ? "Ring2" : "gray2")
                                        .opacity(0.5),
                                    Color(vpnStatus.isConnected ? "Ring2" : "gray2")
                                        .opacity(0.3),
                                    Color(vpnStatus.isConnected ? "Ring2" : "gray2")
                                        .opacity(0.1),
                                    
                                ], startPoint: .leading, endPoint: .trailing),
                                
                                style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round)
                            )
                        // Shadows...
                            .shadow(color: Color(vpnStatus.isConnected ? "Ring2" : "gray2"), radius: 5, x: 1, y: -4)
                            .rotationEffect(.init(degrees: 160))
                        
                        // Main Little Ring...
                        Circle()
                            .stroke(
                            
                                Color("Ring1")
                                    .opacity(0.01),
                                lineWidth: 11
                            )
                        // Toggling Shadow when button is Clicked...
                            .shadow(color: Color("Ring2").opacity(vpnStatus.isConnected ? 0.04 : 0), radius: 5, x: 1, y: -4)
                    }
                    
                    
                )
 
            }.padding()
//            .padding(.top,UIScreen.main.bounds.height < 750 ? 30 : 100)
            

        }
        
         
        private nonisolated func switchProfile(_ isEnabled: Bool) async {
            do {
                if isEnabled  {
                    try await profile.start()
                    await environments.logClient.connect()
                    
                } else {
                    try await profile.stop()
                }
            } catch {
                await MainActor.run {
                    alert = Alert(error)
                }
            }
        }
        
        /*private nonisolated func doReloadSystemProxy() async {
          do {
              
              let status = try LibboxNewStandaloneCommandClient()!.getSystemProxyStatus()
              await MainActor.run {
                  
              }
          } catch {
              await MainActor.run {
                  alert = Alert(error)
              }
          }
      }*/
        
    }
    
    
}

#if os(iOS) || os(tvOS)
struct LottieView: UIViewRepresentable {
    
    var animationFileName: String
    let loopMode: LottieLoopMode
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        let animationView = LottieAnimationView(name: animationFileName)
        animationView.loopMode = loopMode
        animationView.play()
        animationView.contentMode = .scaleAspectFit
        
        return animationView
    }
}
#elseif os(macOS)
struct LottieView: NSViewRepresentable {
    
    var animationFileName: String
    let loopMode: LottieLoopMode
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        let animationView = LottieAnimationView(name: animationFileName)
        animationView.loopMode = loopMode
        animationView.play()
        animationView.contentMode = .scaleAspectFit
        
        // Add the Lottie animation view as a subview of the NSView
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        // Set up constraints to fill the parent view
        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        // Optionally implement updates to the NSView
    }
}

#endif

