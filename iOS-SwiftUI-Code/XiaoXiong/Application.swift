import Foundation
import Library
import SwiftUI

 
@main
struct Application: App {
    @UIApplicationDelegateAdaptor private var appDelegate: ApplicationDelegate
    @StateObject private var environments = ExtensionEnvironments()
    
    @State private var isLoggedIn = UserManager.shared.isUserLoggedIn()
    
    var body: some Scene {
        WindowGroup { 
            if isLoggedIn {
                //MainView().environmentObject(environments)
                HomeView(isLoggedIn: $isLoggedIn).environmentObject(environments)
            }else{
                LoginContentView(isLoggedIn: $isLoggedIn)
            }             
        }
    }
}
