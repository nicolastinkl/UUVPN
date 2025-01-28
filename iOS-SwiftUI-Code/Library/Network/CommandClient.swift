import Foundation
import Libbox

public class CommandClient: ObservableObject {
    public enum ConnectionType {
        case status
        case groups
        case log
        case clashMode
    }

    private let connectionType: ConnectionType
    private let logMaxLines: Int
    private var commandClient: LibboxCommandClient?
    private var connectTask: Task<Void, Error>?

    @Published public var isConnected: Bool
    @Published public var status: LibboxStatusMessage?
    @Published public var groups: [LibboxOutboundGroup]?
    @Published public var logList: [String]
    @Published public var clashModeList: [String]
    @Published public var clashMode: String

    public init(_ connectionType: ConnectionType, logMaxLines: Int = 300) {
        self.connectionType = connectionType
        self.logMaxLines = logMaxLines
        logList = []
        clashModeList = []
        clashMode = ""
        isConnected = false
    }

    public func connect() {
        if isConnected {
            return
        }
        if let connectTask {
            connectTask.cancel()
        }
        connectTask = Task {
            await connect0()
        }
    }

    public func disconnect() {
        if let connectTask {
            connectTask.cancel()
            self.connectTask = nil
        }
        if let commandClient {
            try? commandClient.disconnect()
            self.commandClient = nil
        }
    }

    private nonisolated func connect0() async {
        print("connect0...")
        let clientOptions = LibboxCommandClientOptions()
        switch connectionType {
        case .status:
            print("connectionType = .status")
            clientOptions.command = LibboxCommandStatus
        case .groups:
            print("connectionType = .groups")
            clientOptions.command = LibboxCommandGroup
        case .log:
            print("connectionType = .log")
            clientOptions.command = LibboxCommandLog
        case .clashMode:
            print("connectionType = .clashMode")
            clientOptions.command = LibboxCommandClashMode
        }
        clientOptions.statusInterval = Int64(2 * NSEC_PER_SEC)
        let client = LibboxNewCommandClient(clientHandler(self), clientOptions)!
        do {
            //连接失败时的行为
//            第一个版本：如果连接失败，它将不会重试；它将在捕获错误后尝试断开连接。
//            第二个版本：如果在循环的任何迭代中连接失败，它将进行下一次迭代，在重试连接之前再次休眠。这允许多次尝试连接，每次尝试之间的等待时间逐渐变长
            for i in 0 ..< 2 {
                try await Task.sleep(nanoseconds: UInt64(Double(100 + (i * 50)) * Double(NSEC_PER_MSEC)))
                try Task.checkCancellation()
                do {
                    try client.connect()
                    await MainActor.run {
                        commandClient = client
                    }
                    return
                } catch {}
                try Task.checkCancellation()
            }
            
           
            
             
        } catch {
            try? client.disconnect()
        }
         
        /*
        do {
            try client.connect()
            await MainActor.run {
                commandClient = client
            }
            return
        } catch {
            print("URLTesting... \(error)")
            try? client.disconnect()
        }
        */
    }

    private class clientHandler: NSObject, LibboxCommandClientHandlerProtocol {
        private let commandClient: CommandClient

        init(_ commandClient: CommandClient) {
            self.commandClient = commandClient
        }

        func connected() {
            DispatchQueue.main.async { [self] in
                if commandClient.connectionType == .log {
                    commandClient.logList = []
                }
                commandClient.isConnected = true
            }
        }

        func disconnected(_: String?) {
            DispatchQueue.main.async { [self] in
                commandClient.isConnected = false
            }
        }

        func clearLog() {
            DispatchQueue.main.async { [self] in
                commandClient.logList.removeAll()
            }
        }

        func writeLog(_ message: String?) {
            // print("writeStatus \(String(describing: message))")
            guard let message else {
                return
            }
            DispatchQueue.main.async { [self] in
                if commandClient.logList.count > commandClient.logMaxLines {
                    commandClient.logList.removeFirst()
                }
                commandClient.logList.append(message)
            }
        }

        func writeStatus(_ message: LibboxStatusMessage?) {
          //  print("writeStatus \(String(describing: message?.description))")
            DispatchQueue.main.async { [self] in
                commandClient.status = message
            }
        }

        func writeGroups(_ groups: LibboxOutboundGroupIteratorProtocol?) {
           // print("writeGroups \(String(describing: groups?.next()))")
            guard let groups else {
                return
            }
            var newGroups: [LibboxOutboundGroup] = []
            while groups.hasNext() {
                newGroups.append(groups.next()!)
            }
            DispatchQueue.main.async { [self] in
                commandClient.groups = newGroups
            }
        }

        func initializeClashMode(_ modeList: LibboxStringIteratorProtocol?, currentMode: String?) {
            DispatchQueue.main.async { [self] in
                commandClient.clashModeList = modeList!.toArray()
                commandClient.clashMode = currentMode!
            }
        }

        func updateClashMode(_ newMode: String?) {
            DispatchQueue.main.async { [self] in
                commandClient.clashMode = newMode!
            }
        }
    }
}
