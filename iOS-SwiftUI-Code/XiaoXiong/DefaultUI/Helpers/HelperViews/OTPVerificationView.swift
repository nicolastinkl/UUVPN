//
//  OTPVerificationView.swift
//  AutoOtpTF
//
//  Created by Balaji on 23/12/22.
//

import SwiftUI

struct OTPVerificationView: View {
    /// - View Properties
    @Binding var otpText: String
    /// - Keyboard State
    @FocusState private var isKeyboardShowing: Bool
    var body: some View {
        HStack(spacing: 0){
            /// - OTP Text Boxes
            /// Change Count Based on your OTP Text Size
            ForEach(0..<6,id: \.self){index in
                OTPTextBox(index)
            }
        }
        .background(content: {
            TextField("", text: $otpText.limit(6))
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                /// - Hiding it Out
                .frame(width: 1, height: 1)
                .opacity(0.001)
                .blendMode(.screen)
                .focused($isKeyboardShowing)
        })
        .contentShape(Rectangle())
        /// - Opening Keyboard When Tapped
        .onTapGesture {
            isKeyboardShowing = true
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Done"){
                    isKeyboardShowing = false
                }
                .tint(.white)
                ////.fontWeight(.heavy)
                .hSpacing(.trailing)
            }
        }
    }
    
    // MARK: OTP Text Box
    @ViewBuilder
    func OTPTextBox(_ index: Int)->some View{
        ZStack{
            if otpText.count > index{
                /// - Finding Char At Index
                let startIndex = otpText.startIndex
                let charIndex = otpText.index(startIndex, offsetBy: index)
                let charToString = String(otpText[charIndex])
                Text(charToString)
            }else{
                Text(" ")
            }
        }
        .frame(width: 45, height: 45)
        .background {
            /// - Highlighting Current Active Box
            let status = (isKeyboardShowing && otpText.count == index)
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .stroke(status ? .main : Color.gray,lineWidth: status ? 3 : 0.5)
                /// - Adding Animation
                .animation(.easeInOut(duration: 0.2), value: isKeyboardShowing)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: Binding <String> Extension
extension Binding where Value == String{
    func limit(_ length: Int)->Self{
        if self.wrappedValue.count > length{
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(length))
            }
        }
        return self
    }
}
