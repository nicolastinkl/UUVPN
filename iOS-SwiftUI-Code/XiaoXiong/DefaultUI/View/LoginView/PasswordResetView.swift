//
//  PasswordResetView.swift
//  LoginKit
//
//  Created by Balaji on 04/08/23.
//

import SwiftUI

struct PasswordResetView: View {
    /// View Properties
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @Binding var isresetpwdLoading: Bool
    @Binding var resetpwdErrorMessage : String
    
    var onButtonClick: ((String) -> Void)?
    /// Environment Properties
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            /// Back Button
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundStyle(.gray)
            })
            .padding(.top, 10)
            
            Text("重置密码")
                .font(.largeTitle)
                //.fontWeight(.heavy)
                .padding(.top, 5)
            
            VStack(spacing: 25) {
                /// Custom Text Fields
                CustomTF(sfIcon: "lock", hint: "密码", value: $password)
                
                CustomTF(sfIcon: "lock", hint: "再次确认密码", value: $confirmPassword)
                    .padding(.top, 5)
                if isresetpwdLoading {
                    ProgressView()
                }
                
                if !resetpwdErrorMessage.isEmpty {
                    Text(resetpwdErrorMessage)
                        .bold()
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center) // 确保多行文本居中
                        .padding()
                }
                /// SignUp Button
                GradientButton(title: "重置密码", icon: "arrow.right") {
                    /// YOUR CODE
                    /// Reset Password
                    onButtonClick?(password)
                }
                .hSpacing(.trailing)
                /// Disabling Until the Data is Entered
                .disableWithOpacity(password.isEmpty || confirmPassword.isEmpty || confirmPassword != password || isresetpwdLoading)
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
 
