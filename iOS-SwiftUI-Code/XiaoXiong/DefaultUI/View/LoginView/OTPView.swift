//
//  OTPView.swift
//  LoginKit
//
//  Created by Balaji on 04/08/23.
//

import SwiftUI

struct OTPView: View {
    @Binding var otpText: String
    /// Environment Properties
    @Environment(\.dismiss) private var dismiss
    var onButtonClick: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            /// Back Button
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundStyle(.gray)
            })
            .padding(.top, 15)
            
            Text("输入验证码")
                .font(.largeTitle)
                //.fontWeight(.heavy)
                .padding(.top, 5)
            
            Text("一个 6 位数的验证码已发送至您的电子邮件。")
                .font(.caption)
                //.fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25) {
                /// Custom OTP TextField
                OTPVerificationView(otpText: $otpText)
                
                /// SignUp Button
                GradientButton(title: "下一步", icon: "arrow.right") {
                    /// YOUR CODE
                    onButtonClick?()
                }
                .hSpacing(.trailing)
                /// Disabling Until the Data is Entered
                .disableWithOpacity(otpText.isEmpty)
            }
            .padding(.top, 20)
            
            Spacer(minLength: 0)
        })
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        /// Since this is going to be a Sheet.
        .interactiveDismissDisabled()
    }
}
 
