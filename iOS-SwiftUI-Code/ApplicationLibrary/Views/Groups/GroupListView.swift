import Libbox
import Library
import SwiftUI

 

public struct GroupListView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var isLoading = true
    @StateObject private var commandClient = CommandClient(.groups)
    @State private var groups: [OutboundGroup] = []
    
    public init() {
        
    }
     
    public var body: some View {
        VStack {
            if isLoading {
                Spacer().frame(height: 20)                
                Text("请开启VPN后查看节点数据").foregroundColor(.red)
            } else if !groups.isEmpty {
                ScrollView {
                    VStack {
                         
                        ForEach(groups, id: \.hashValue) { it in
                            GroupView(it)
                        }
                    }.padding() //.background(Color.gray.opacity(0.1))
                }
            } else {
                Spacer().frame(height: 20)
                ProgressView()
            }
        }
        .onAppear {
            connect()
        }
        .onDisappear {
            commandClient.disconnect()
        }
        .onChangeCompat(of: scenePhase) { newValue in
            if newValue == .active {
                commandClient.connect()
            } else {
                commandClient.disconnect()
            }
        }
        .onReceive(commandClient.$groups, perform: { groups in
            if let groups {
                setGroups(groups)
            }
        })
    }

    private func connect() {
        if ApplicationLibrary.inPreview {
            groups = [
                OutboundGroup(tag: "my_group", type: "selector", selected: "server", selectable: true, isExpand: true, items: [
                    OutboundGroupItem(tag: "server", type: "Shadowsocks", urlTestTime: .now, urlTestDelay: 12),
                    OutboundGroupItem(tag: "server2", type: "WireGuard", urlTestTime: .now, urlTestDelay: 34),
                    OutboundGroupItem(tag: "auto", type: "URLTest", urlTestTime: .now, urlTestDelay: 100),
                ]),
                OutboundGroup(tag: "group2", type: "urltest", selected: "client", selectable: true, isExpand: false, items:
                    (0 ..< 234).map { index in
                        OutboundGroupItem(tag: "client\(index)", type: "Shadowsocks", urlTestTime: .now, urlTestDelay: UInt16(100 + index * 10))
                    }),
            ]
            isLoading = false
        } else {
            
#if targetEnvironment(simulator)
            groups = [
                OutboundGroup(tag: "my_group", type: "selector", selected: "server", selectable: true, isExpand: true, items: [
                    OutboundGroupItem(tag: "🇭🇰🇭🇰Hong Kong 01", type: "Shadowsocks", urlTestTime: .now, urlTestDelay: 12),
                    OutboundGroupItem(tag: "🇭🇰🇭🇰Hong Kong 03", type: "WireGuard", urlTestTime: .now, urlTestDelay: 34),
                    OutboundGroupItem(tag: "🇭🇰🇭🇰Hong Kong 04", type: "URLTest", urlTestTime: .now, urlTestDelay: 100),
                    OutboundGroupItem(tag: "🇯🇵🇯🇵🇯🇵Japan 01", type: "Shadowsocks", urlTestTime: .now, urlTestDelay: 12),
                    OutboundGroupItem(tag: "🇯🇵🇯🇵Japan Kong 01", type: "Shadowsocks", urlTestTime: .now, urlTestDelay: 112),
                    OutboundGroupItem(tag: "🇯🇵🇯🇵Japan Kong 02", type: "Shadowsocks", urlTestTime: .now, urlTestDelay: 1222),
                    OutboundGroupItem(tag: "🇯🇵🇯🇵Japan Kong 03", type: "Shadowsocks", urlTestTime: .now, urlTestDelay: 4412),
                    OutboundGroupItem(tag: "🇯🇵🇯🇵Japan Kong 04", type: "Shadowsocks", urlTestTime: .now, urlTestDelay: 512),
                ]),
            ]
            isLoading = false
#endif
            commandClient.connect()
        }
    }

    private func setGroups(_ goGroups: [LibboxOutboundGroup]) {
        
        var groups = [OutboundGroup]()
        if let goGroup = goGroups.first {
            goGroup.isExpand = true
            var items = [OutboundGroupItem]()
            let itemIterator = goGroup.getItems()!
            while itemIterator.hasNext() {
                let goItem = itemIterator.next()!
                items.append(OutboundGroupItem(tag: goItem.tag, type: goItem.type, urlTestTime: Date(timeIntervalSince1970: Double(goItem.urlTestTime)), urlTestDelay: UInt16(goItem.urlTestDelay)))
            }
            groups.append(OutboundGroup(tag: goGroup.tag, type: goGroup.type, selected: goGroup.selected, selectable: goGroup.selectable, isExpand: goGroup.isExpand, items: items))
            UserDefaults.standard.setValue("\(goGroup.tag)", forKey: "goGrouptag")
        }
               
        /* 原有的全部显示逻辑
        var groups = [OutboundGroup]()
        for goGroup in goGroups {
            print(goGroup.tag)
            //默认设置为开启
            goGroup.isExpand = true
            var items = [OutboundGroupItem]()
            let itemIterator = goGroup.getItems()!
            while itemIterator.hasNext() {
                let goItem = itemIterator.next()!
                items.append(OutboundGroupItem(tag: goItem.tag, type: goItem.type, urlTestTime: Date(timeIntervalSince1970: Double(goItem.urlTestTime)), urlTestDelay: UInt16(goItem.urlTestDelay)))
            }
            groups.append(OutboundGroup(tag: goGroup.tag, type: goGroup.type, selected: goGroup.selected, selectable: goGroup.selectable, isExpand: goGroup.isExpand, items: items))
        }*/
        self.groups = groups  
        
        isLoading = false
    }
}
