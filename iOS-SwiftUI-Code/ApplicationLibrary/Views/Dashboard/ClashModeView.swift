import Libbox
import Library
import SwiftUI

@MainActor
public struct ClashModeView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var commandClient = CommandClient(.clashMode)
    @State private var clashMode = ""
    @State private var alert: Alert?

    public init() {}
    public var body: some View {
        VStack {
          
            if commandClient.clashModeList.count > 1 {
                Picker("", selection: Binding(get: {
                    clashMode
                }, set: { newMode in
                    clashMode = newMode
                    Task {
                        await setClashMode(newMode)
                        await restartVPNServer()
                    }
                }), content: {
                    ForEach(commandClient.clashModeList, id: \.self) { it in
                        /*if it.lowercased() == "rule" {
                            Text("规则模式")
                        }else if it.lowercased() == "direct" {
                            Text("直连模式")
                        }else if it.lowercased() == "global" {
                            Text("全局模式")
                        }else{
                           
                        }*/
                        Text(it)
                        
                    }
                })
                .pickerStyle(.segmented)
                .padding([.top], 8)
            }else{
                //DEBUG
                /*
                let newclashModeList = ["规则模式","直连模式","全局模式"]
                Picker("", selection: Binding(get: {
                    clashMode
                }, set: { newMode in
                                        
                }), content: {
                    ForEach(newclashModeList, id: \.self) { it in
                        /*if it.lowercased() == "rule" {
                            Text("规则模式")
                        }else if it.lowercased() == "direct" {
                            Text("直连模式")
                        }else if it.lowercased() == "global" {
                            Text("全局模式")
                        }else{
                            Text(it)
                        }*/
                        
                        Text(it)
                        
                    }
                })
                .pickerStyle(.segmented)
                .padding([.top], 8)
                 */
            }
            
        }
        .onReceive(commandClient.$clashMode) { newMode in
            clashMode = newMode
        }
        .padding([.leading, .trailing])
        .onAppear {
            commandClient.connect()
        }
        .onDisappear {
            commandClient.disconnect()
        }
        .onChangeCompat(of: scenePhase) { newValue in
            print("\(String(describing: commandClient.status))")
            if newValue == .active {
                commandClient.connect()
            } else {
                commandClient.disconnect()
            }
        }
        .alertBinding($alert)
    }

    private nonisolated func setClashMode(_ newMode: String) async {
        do {
            try LibboxNewStandaloneCommandClient()!.setClashMode(newMode)
        } catch {
            await MainActor.run {
                alert = Alert(error)
            }
        }
    }
    
    private nonisolated func restartVPNServer() async {
        do {
            try   LibboxNewStandaloneCommandClient()!.serviceReload()
            
        } catch {
            await MainActor.run {
                alert = Alert(error)
            }
        }
    }

}
