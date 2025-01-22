//
//  Signup.swift
//  LoginKit
//
//  Created by Balaji on 04/08/23.
//

import SwiftUI

struct SignUp: View {
    
    @Binding var isLoggedIn: Bool
    @Binding var showSignup: Bool
    
    
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    /// View Properties
    @State private var emailID: String = ""
    @State private var fullName: String = ""
    @State private var password: String = ""
    /// Optional, Present If you want to ask OTP for Signup
    @State private var askOTP: Bool = false
    @State private var otpText: String = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            
          
//            HStack{
//                Spacer()
//                Image("applogo").resizable().frame(width: 100, height: 100).cornerRadius(20)
//                Spacer()
//            }
            
            
            Text("注册")
                .font(.largeTitle)
                //.fontWeight(.heavy)
                .padding(.top, 25)
            
            Text("请按注册按钮继续")
                .font(.callout)
                //.fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25) {
                /// Custom Text Fields
                CustomTF(sfIcon: "at", hint: "Email", value: $emailID)
                
                CustomTF(sfIcon: "lock", hint: "密码", isPassword: true, value: $password)
                    .padding(.top, 5)
                
                CustomTF(sfIcon: "person", hint: "邀请人（可不填）", value: $fullName)
                    .padding(.top, 5)
                
                
                Text("通过注册，你同意我们的[条款和条件](https://minipanda.soccertt.com/teams.html)和[隐私政策](https://minipanda.soccertt.com/privacy.html)")
                    .font(.caption)
                    .tint(.white)
                    .foregroundStyle(.gray)
                    .frame(height: 50)
                
                
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
                GradientButton(title: "注册", icon: "arrow.right") {
                    /// YOUR CODE
                    //askOTP.toggle()
                    Task{
                        await logupUser()
                    }
                }
                .hSpacing(.trailing)
                /// Disabling Until the Data is Entered  || fullName.isEmpty
                .disableWithOpacity(emailID.isEmpty || password.isEmpty || isLoading)
            }
            .padding(.top, 20)
            
            Spacer(minLength: 0)
            
            HStack(spacing: 6) {
                Text("已经有账号?")
                    .foregroundStyle(.gray)
                
                Button("登录") {
                    showSignup = false
                }
                //.fontWeight(.bold)
                .tint(.white)
            }
            .font(.callout)
            .hSpacing()
            
        })
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        //.toolbar(.hidden, for: .navigationBar)
        /// OTP Prompt
        .sheet(isPresented: $askOTP, onDismiss: {
            /// YOUR CODE
            /// Reset OTP if You Want
            // otpText = ""
        }, content: {
            if #available(iOS 16.4, *) {
                /// Since I wanted a Custom Sheet Corner Radius
                OTPView(otpText: $otpText)
                    .presentationDetents([.height(350)])
                    .presentationCornerRadius(30)
            } else {
                OTPView(otpText: $otpText)
                   // .presentationDetents([.height(350)])
            }
        })
    }
    
    
    // MARK: - Networking Logic

    func logupUser() async {
        isLoading = true
        errorMessage = nil

        let loginUrl = URL(string: "\(UserManager.shared.baseURL())passport/auth/register")!
        var request = URLRequest(url: loginUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let loginData = ["email": emailID, "password": password, "captchaData": "","email_code":"","invite_code":fullName]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: loginData) else {
            self.errorMessage = "Invalid login data"
            self.isLoading = false
            return
        }
        
        request.httpBody = httpBody

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = "注册失败: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "注册失败：数据返回空"
                    return
                }
               
                // Parse the login response and get the authorization token
             
                
                if let jsonResponse = try? JSONDecoder().decode(LoginResponseSuccess.self, from: data){
                    
                    
                    if  let authData = jsonResponse.data?.authData {
                        
                        UserManager.shared.updateLoginStatus(true)
                        UserManager.shared.storeAutoData(data: authData)
                                                
                        
                        self.isLoggedIn = true
                    }else{

                        if let message = jsonResponse.message {
                            self.errorMessage = "\(message)"
                        }
                    }
                    
                    
                    
                }else{
                    self.errorMessage = "注册失败: 返回JSON格式错误"
                }
                

            }
        
        }

        task.resume()
    }
}


/***
 {
     "status": "success",
     "message": "\u64cd\u4f5c\u6210\u529f",
     "data": {
         "token": "56ffc6d0465212eca2856aa25dc1644e",
         "is_admin": null,
         "auth_data": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MTU0MDMsInNlc3Npb24iOiJiYzk3N2RhOTczN2RjZWVlM2FiNDc2NzAzMjBjOTI2OCJ9.WUPCzTlgsOMGM-DrsSMRrfBqgAB8GEysDyAofq6TgVo"
     },
     "error": null
 }
 
 */
 
