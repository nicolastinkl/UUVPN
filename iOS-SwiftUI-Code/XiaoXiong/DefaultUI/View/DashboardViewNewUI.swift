//
//  DashboardViewNewUI.swift
//  SFI
//
//  Created by Zeus on 2024/10/11.
//

import Foundation
import Libbox
import Library
import SwiftUI
import ApplicationLibrary



struct DashboardViewNewUI: View {
    @EnvironmentObject private var environments: ExtensionEnvironments
    @EnvironmentObject private var profile: ExtensionProfile
    @State private var alert: Alert?

    var body: some View {
        VStack {
            ActiveDashboardViewNewUI()
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
            alert = Alert(title: Text("VPN 服务异常"), message: Text(message))
        }
    }
}
