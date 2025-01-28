import Libbox
import Network
import Library
import SwiftUI

@MainActor
public struct GroupItemView: View {
    private let _group: Binding<OutboundGroup>
    private var group: OutboundGroup {
        _group.wrappedValue
    }

    private let item: OutboundGroupItem
    
    public init(_ group: Binding<OutboundGroup>, _ item: OutboundGroupItem) {
        _group = group
        self.item = item
    }

    @State private var alert: Alert?

    
    /* old style
    public var body: some View {
        Button {
            if group.selectable, group.selected != item.tag {
                Task {
                    await selectOutbound()
                    UserDefaults.standard.setValue("\(item.tag)", forKey: "selectedNode")
                }
            }
        } label: {
            HStack {
                VStack {
                    HStack {
                        Text(item.tag)
                            .font(.subheadline)
                            .foregroundStyle(.foreground)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Spacer(minLength: 0)
                    }
                    Spacer(minLength: 8)
                    HStack {
                        Text(item.displayType)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer(minLength: 0)
                    }
                }
                Spacer(minLength: 0)
                VStack {
                    if group.selected == item.tag {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color.accentColor)
                    }
                    Spacer(minLength: 0)
                    if item.urlTestDelay > 0 {
                        Text(item.delayString)
                            .font(.caption)
                            .foregroundColor(item.delayColor)
                    }
                }
            }
        }
        #if !os(tvOS)
        .buttonStyle(.borderless)
        .padding(EdgeInsets(top: 10, leading: 13, bottom: 10, trailing: 13))
        .background(backgroundColor)
        .cornerRadius(10)
        #endif
        .alertBinding($alert)
    }
     */
    
    
    func testPing(to server: String, port: Int, completion: @escaping (TimeInterval?) -> Void) {
        let startTime = Date()
            
            let connection = NWConnection(host: NWEndpoint.Host(server), port: NWEndpoint.Port(rawValue: UInt16(port))!, using: .tcp)
            
            connection.stateUpdateHandler = { state in
                switch state {
                case .ready:
                    // 连接成功，计算响应时间
                    let pingTime = Date().timeIntervalSince(startTime)
                    completion(pingTime)
                    connection.cancel() // 连接完成后取消
                case .failed(_):
                    completion(nil)
                    connection.cancel()
                default:
                    break
                }
            }
            
            // 启动连接
            connection.start(queue: .global())
    }


    
    public var body: some View {
        Button {
            print("\(group.selectable) group.selected - item.tag: >>> "+group.selected + "  "  + item.tag)
          //  print(item.toString)
            
            if group.selectable, group.selected != item.tag {
             
                
               // var item = _group.wrappedValue.items[index] // Make a mutable copy of the item
                   
                Task {
                    
                    
                    if let server =  item.server  ,let port = item.server_port{
                        //说明是第一次查看节点列表 然后  点击列表
                            
                            testPing(to: server, port: port) { pingTime in
                                if let ping = pingTime {
                                    print("Ping 时间: \(ping) 秒")
                                    
                                    Task{
                                        await pingOutbound(tag: item.tag,pingtime: UInt16((pingTime ?? 0)*1000))
                                    }
                                    
                                    
                                } else {
                                    print("连接超时")
                                }
                            }
                        
                        UserDefaults.standard.setValue("\(item.tag)", forKey: "selectedNode")
                        await selectOutbound()
                        
                    }else{
                        
                        await selectOutbound()
                        
                        UserDefaults.standard.setValue("\(item.tag)", forKey: "selectedNode")
                        
                        //切换节点后重启服务
                        
                        await restartVPNServer()
                    }
                        
                }
                
            }
        } label: {
            VStack(spacing: 2) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
//                        Image(server.name)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 20, height: 20)

                            Text(item.tag)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }

                        Label {
                            Text(item.type)
                           // Text(item.urlTestDelay <= 3000 ? "在线可用" : "不可用")
                        } icon: {
                           // Image(systemName: item.urlTestDelay <= 3000  ? "checkmark" : "xmark")
                        }  .foregroundColor(.gray)
//                        .foregroundColor(item.urlTestDelay <= 3000  ?.green : .red)
                        .font(.caption2)
                    }

                    Spacer(minLength: 10)

                    // Change Server Button...
                     
                    VStack {
                        if group.selected == item.tag {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.accentColor)
                        }
                        Spacer(minLength: 0)
                        if item.urlTestDelay > 0 {
                            Text(item.delayString)
                                .font(.caption)
                                .foregroundColor(item.delayColor)
                        }else{
                            //正在测速
                            Text("...")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .frame(height: 50)
                .padding(.horizontal)

                Divider()
            }
        }
        #if !os(tvOS)
        .buttonStyle(.borderless)
//        .padding(EdgeInsets(top: 10, leading: 13, bottom: 10, trailing: 13))
//        .background(backgroundColor)
//        .cornerRadius(10)
        #endif
        .alertBinding($alert)
    }
    
    
    private nonisolated func   pingOutbound(tag: String,pingtime: UInt16) async {
        let newGroup = await group
        
        let newitems = newGroup.items.map { item in
            var mutableItem = item
            if (item.tag == tag) {
                mutableItem.urlTestDelay = pingtime
            }
            return mutableItem
        }
        
        let newOut = OutboundGroup(tag: newGroup.tag, type: newGroup.type, selected:tag, selectable: newGroup.selectable, isExpand: newGroup.isExpand, items: newitems)
        
        await MainActor.run { [newOut] in
            _group.wrappedValue = newOut
        }
        
    }
    
    private nonisolated func selectOutbound() async {
        do {
            try await LibboxNewStandaloneCommandClient()!.selectOutbound(group.tag, outboundTag: item.tag)
            var newGroup = await group
            newGroup.selected =  item.tag
            await MainActor.run { [newGroup] in
                _group.wrappedValue = newGroup
            }
        } catch {
            await MainActor.run {
                alert = Alert(error)
            }
        }
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
    
    
    private nonisolated func restartVPNServer() async {
        do {  
            try   LibboxNewStandaloneCommandClient()!.serviceReload()
            
        } catch {
            await MainActor.run {
                alert = Alert(error)
            }
        }
    }

    private var backgroundColor: Color {
        #if os(iOS)
            return Color(uiColor: .secondarySystemGroupedBackground)
        #elseif os(macOS)
            return Color(nsColor: .textBackgroundColor)
        #elseif os(tvOS)
            return Color.black
        #endif
    }
}
