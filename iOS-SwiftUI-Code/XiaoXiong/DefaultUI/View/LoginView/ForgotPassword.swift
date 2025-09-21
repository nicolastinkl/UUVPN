//
//  ForgotPassword.swift
//  LoginKit
//
//  Created by zues on 04/08/23.
//

import SwiftUI

struct ForgotPassword: View {
    @Binding var showResetView: Bool
    /// View Properties
    //@State private var emailID: String = ""
    @Binding  var emailID: String 
    /// Environment Properties
    @Environment(\.dismiss) private var dismiss
    
    @State private var askOTP: Bool = false
    //@State private var otpText: String = ""
    
    @Binding var otpText: String
    
    @State private var isLoading = false
    @State private var errorMessage: String?
    
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
            .padding(.top, 10)
            
            Text("忘记密码?")
                .font(.largeTitle)
                //.fontWeight(.heavy)
                .padding(.top, 5)
            
            Text("请输入您的电子邮件，以便我们可以发送验证码。")
                .font(.caption)
                //.fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            
            
            VStack(spacing: 25) {
                /// Custom Text Fields
                CustomTF(sfIcon: "at", hint: "输入邮箱", value: $emailID)
                
                if isLoading {
                      ProgressView()
                  }
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .bold()
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center) // 确保多行文本居中
                        .padding()
                }
                
                /// SignUp Button
                GradientButton(title: "发送验证码", icon: "arrow.right") {
                    /// YOUR CODE
                    /// After the Link sent
                    Task {
                       await sendemail(email:emailID)
                    }
                    
                    
                }
                .hSpacing(.trailing)
                /// Disabling Until the Data is Entered
                .disableWithOpacity(emailID.isEmpty || isLoading)
            }
            .padding(.top, 20)
            
            Spacer(minLength: 0)
        })/// OTP Prompt
        .sheet(isPresented: $askOTP, onDismiss: {
            /// YOUR CODE
            /// Reset OTP if You Want
            // otpText = ""
        }, content: {
            if #available(iOS 16.4, *) {
                /// Since I wanted a Custom Sheet Corner Radius
                OTPView(otpText: $otpText,onButtonClick: {
                    print(otpText)
                    Task {
                        dismiss()
                       // try? await Task.sleep(for: .seconds(0))
                        /// Showing the Reset View
                        showResetView = true
                    }
                })
                    .presentationDetents([.height(350)])
                    .presentationCornerRadius(30)
            } else {
                if #available(iOS 16.0, *) {
                    OTPView(otpText: $otpText,onButtonClick: {
                        print(otpText)
                        Task {
                           dismiss()
                           // try? await Task.sleep(for: .seconds(0))
                            /// Showing the Reset View
                            showResetView = true
                        }
                    }).presentationDetents([.height(350)])
                } else {
                    OTPView(otpText: $otpText,onButtonClick: {
                        print(otpText)
                        Task {
                            dismiss()
                           // try? await Task.sleep(for: .seconds(0))
                            /// Showing the Reset View
                            showResetView = true
                        }
                    })
                    // Fallback on earlier versions
                }
            }
        })
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        /// Since this is going to be a Sheet.
        .interactiveDismissDisabled()
    }
    
    
    
    @MainActor
    public func  sendemail(email: String) async {
        
            isLoading = true
            errorMessage = nil

        
        let userInfoUrl = URL(string: "\(UserManager.shared.baseURL())passport/comm/sendEmailVerify?email=\(email)&recaptcha_data=")!
        var request = URLRequest(url: userInfoUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(UserManager.shared.getAutoData(), forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = "验证码发送失败: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "验证码发送失败：数据返回空"
                    return
                }
            
                // Parse the user info response
               if let message = try? JSONDecoder().decode(MessageResponse.self, from: data) {
                   dump(message)
                   if let _  = message.errors{
                       self.errorMessage = message.message
                   }else{
                       askOTP.toggle()
                   }
               }
            }
        }

        task.resume()
        
        
    }
    
}
 
