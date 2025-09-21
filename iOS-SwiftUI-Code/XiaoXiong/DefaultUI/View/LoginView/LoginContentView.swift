//
//  ContentView.swift
//  LoginKit
//
//  Created by zues on 04/08/23.
//

import SwiftUI

struct LoginContentView: View {
    
    @Binding var isLoggedIn: Bool
    
    /// View Properties
    @State private var showSignup: Bool = false
    /// Keyboard Status
    @State private var isKeyboardShowing: Bool = false
    var body: some View {
        NavigationView{
            if showSignup {
               // 如果 showSignup 为 true，则显示 SignUp 界面
               SignUp(isLoggedIn: $isLoggedIn,showSignup: $showSignup).onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification), perform: { _ in
                   /// Disabling it for signup view
                   if !showSignup {
                       isKeyboardShowing = true
                   }
               })
               .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification), perform: { _ in
                   isKeyboardShowing = false
               }).background(BackgroundBg())
           } else {
               /// Checking if any Keyboard is Visible
               // 如果 showSignup 为 false，则显示 Login 界面
               Login(isLoggedIn: $isLoggedIn, showSignup: $showSignup).onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification), perform: { _ in
                   /// Disabling it for signup view
                   if !showSignup {
                       isKeyboardShowing = true
                   }
               }) 
               .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification), perform: { _ in
                   isKeyboardShowing = false
               }).background(BackgroundBg())
           }
                
             
        }
        .preferredColorScheme(.dark)
//
//            /// iOS 17 Bounce Animations
//            if #available(iOS 17, *) {
//                /// Since this Project Supports iOS 16 too.
//                CircleView()
//                    .animation(.smooth(duration: 0.45, extraBounce: 0), value: showSignup)
//                    .animation(.smooth(duration: 0.45, extraBounce: 0), value: isKeyboardShowing)
//            } else {
//                CircleView()
//                    .animation(.easeInOut(duration: 0.3), value: showSignup)
//                    .animation(.easeInOut(duration: 0.3), value: isKeyboardShowing)
//            }
//        }
    }     
    
    /// Moving Blurred background
    @ViewBuilder
    func CircleView() -> some View {
        Circle()
            .fill(.linearGradient(colors: [.main, .main2], startPoint: .top, endPoint: .bottom))
            .frame(width: 200, height: 200)
            /// Moving When the Signup Pages Loads/Dismisses
            .offset(x: showSignup ? 90 : -90, y: -90 - (isKeyboardShowing ? 200 : 0))
            .blur(radius: 15)
            .hSpacing(showSignup ? .trailing : .leading)
            .vSpacing(.top)
    }
}
