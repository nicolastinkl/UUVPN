import Libbox
import Library
import SwiftUI

@MainActor
public struct DashboardView: View {
    #if os(macOS)
        @Environment(\.controlActiveState) private var controlActiveState
        @State private var isLoading = true
        @State private var systemExtensionInstalled = true
    #endif

    public init() {}
    public var body: some View {
        viewBuilder {
            #if os(macOS)
            HStack{
                    
                
                
                Button {
                    withAnimation{
                       // isUserViewActive.toggle()
                    }
                } label: {
                    
                    Image(systemName: "circle.grid.cross")
                        .font(.title2)
                        .padding(5)
                        .foregroundColor(.white)
                        .background(
                            
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(.white.opacity(0.25),lineWidth: 1)
                        )
                }
                     
                Spacer()
                
                /* Button {
                    withAnimation{
                        isSubscriptionActive.toggle()
                        
                    }
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .font(.title2)
                        .padding(12)
                        .background(
                            
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(.white.opacity(0.25),lineWidth: 1)
                        )
                } */
                
                 
                // Text Bubble
                Button {
                    withAnimation{
                      //  isSubscriptionActive.toggle()
                        
                    }
                } label: {
                        
                    Text("超值折扣")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.orange)
                        )
                        .overlay(
                            TriangleShape()
                                .fill(Color.orange)
                                .frame(width: 10, height: 10)
                                .offset(x: 10)
                            , alignment: .trailing
                        )
                    
                    // Panda Image with VIP Tag
                    HStack(spacing: 10){
                        Text(verbatim: "")
                        Image("applogo") // Replace with actual image asset
                            .resizable()
                            .frame(width: 30, height: 30)
                            .cornerRadius(15)
                        
//                                Text("VIP")
//                                    .font(.caption)
//                                    .fontWeight(.bold)
//                                    .foregroundColor(.yellow)
//                                    .padding(4)
//                                    .background(Color.orange)
//                                    .cornerRadius(4)
                    }
                    
                }
                .padding()
                
                Button {
                    withAnimation{
                       // isKefuActive.toggle()
                    }
                } label: {
                    
                    Image(systemName: "person.fill.questionmark")
                        .font(.title2)
                        .padding(5)
                        .foregroundColor(.white)
                        .background(
                            
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(.white.opacity(0.25),lineWidth: 1)
                        )
                    Text("客服").foregroundColor(.white)
                }
                
            }
            
                if Variant.useSystemExtension {
                    viewBuilder {
                        if !systemExtensionInstalled {
                            FormView {
                                InstallSystemExtensionButton {
                                    await reload()
                                }
                            }
                        } else {
                            DashboardView0()
                        }
                    }.onAppear {
                        Task {
                            await reload()
                        }
                    }
                } else {
                    DashboardView0()
                }
            #else
                DashboardView0()
            #endif
        }
        
        #if os(macOS)
        .onChangeCompat(of: controlActiveState) { newValue in
            if newValue != .inactive {
                if Variant.useSystemExtension {
                    if !isLoading {
                        Task {
                            await reload()
                        }
                    }
                }
            }
        }
        #endif
    }

    
    
    struct TriangleShape: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.closeSubpath()
            return path
        }
    }


    
    #if os(macOS)
        private nonisolated func reload() async {
            let systemExtensionInstalled = await SystemExtension.isInstalled()
            await MainActor.run {
                self.systemExtensionInstalled = systemExtensionInstalled
                isLoading = false
            }
        }
    #endif

    struct DashboardView0: View {
        @EnvironmentObject private var environments: ExtensionEnvironments

        var body: some View {
            if ApplicationLibrary.inPreview {
//                ActiveDashboardView()/
                ActiveDashboardViewMACOS()
            } else if environments.extensionProfileLoading {
                ProgressView()
            } else if let profile = environments.extensionProfile {
                DashboardView1().environmentObject(profile)
            } else {
                FormView {
                    
                    InstallProfileButton { error in 
                        //add profile remote
                         
                        await environments.reload()
                    }
                }
                
                
            }
        } 
    }
    
    
    

    struct DashboardView1: View {
        @EnvironmentObject private var environments: ExtensionEnvironments
        @EnvironmentObject private var profile: ExtensionProfile
        @State private var alert: Alert?

        var body: some View {
            VStack {
//                ActiveDashboardView()
                ActiveDashboardViewMACOS()
            }
            .alertBinding($alert)
            .onChangeCompat(of: profile.status) { newValue in
                if newValue == .disconnecting || newValue == .connected {
                    Task {
                        await checkServiceError()
                    }
                }
            }
        }

        private nonisolated func checkServiceError() async {
            var error: NSError?
            let message = LibboxReadServiceError(&error)
            if error != nil {
                return
            }
            await MainActor.run {
                alert = Alert(title: Text("Service Error"), message: Text(message))
            }
        }
    }
}
