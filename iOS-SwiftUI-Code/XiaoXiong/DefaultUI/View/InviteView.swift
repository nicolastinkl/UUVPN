//
//  InviteView.swift
//  SFI
//
//  Created by Mac on 2024/10/12.
//

import Foundation
import SwiftUI

struct InviteView: View {
    @Binding var isPresented: Bool
    
    @State  private var inviteCode: String = "" // This can be dynamically updated.
    @State private var alert: Alert?

    
    var body: some View {
        ZStack(){
            
            LinearGradient(colors: [
                           Color("BG1"),
                           Color("BG1"),
                           Color("BG2"),
                           Color("BG2"),
                       ], startPoint: .top, endPoint: .bottom)
            
            VStack(spacing: 20) {
                Spacer().frame(height: 30)
                // Invitation code section
                HStack {
                    Text("我的邀请码:")
                        .font(.headline)
                        .foregroundColor(.black)
                    Text(inviteCode)
                        .font(.headline)
                        .foregroundColor(.green)
                }
                
                // Illustration image
               // Image("panda_invite") // Add your asset with this name
                LottieView(animationFileName: "7a4ce4b4" , loopMode: .loop)
                .aspectRatio(contentMode: .fill)
    ////                .frame(width: getRect().width,height: getRect().width)
                .scaleEffect(0.3)
                    .scaledToFit()
                    .frame(width: 200, height: 150)
                
                // Invite description
                VStack(spacing: 5) {
                    Text("邀请您的朋友成为 VIP,邀请好友享首次付费30%返佣,赶紧邀请好友一同使用开心上网！")
                        .multilineTextAlignment(.center)
                        .font(.headline)
                        .padding(10)
                        .foregroundColor(.black)
                    
                    
                    
                }
                
                // Copy invite code button
                Button(action: {
                    // Copy invite code action
                    if inviteCode.count <= 1 {
                        Task {
                            await reloadInvite(copy: true)
                        }
                    }else{
                        UIPasteboard.general.string =  UserManager.shared.mainregisterURL()+inviteCode
                        alert = Alert(okMessage: "复制成功")
                    }
                }) {
                    Text("复制邀请链接")
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.7), Color.green]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(25)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 40)
                
                Spacer().frame(height: 30)
                 
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(radius: 10)
                
            )
            
            .padding()
          
        }
        .onAppear(perform: {
            Task {
                await reloadInvite(copy: false)
            }
        })
        .alertBinding($alert)
        .edgesIgnoringSafeArea(.all)
        
        
        
    }
    
     
    public func reloadInvite(copy: Bool) async {
        
        
        let userInfoUrl = URL(string: "\(UserManager.shared.baseURL())user/invite/fetch")!
        var request = URLRequest(url: userInfoUrl)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(UserManager.shared.getAutoData(), forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    alert = Alert(error)
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                // Parse the user info response
                if let invites = try? JSONDecoder().decode(InviteReponse.self, from: data) {
                    if let invite = invites.data?.codes?.first?.code {
                        self.inviteCode = invite
                        if copy {
                            UIPasteboard.general.string =  UserManager.shared.mainregisterURL()+inviteCode
                            alert = Alert(okMessage: "复制成功")
                        }
                    }else{
                        //生成第一条
                        Task{
                            await genoneInvite()
                        }
                    }
                    
                    
                }else{
                    alert = Alert(errorMessage: "访问失败")
                }
            }
        }

        task.resume()
    }
      
    public func genoneInvite() async {
        
        
        let userInfoUrl = URL(string: "\(UserManager.shared.baseURL())user/invite/save")!
        var request = URLRequest(url: userInfoUrl)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(UserManager.shared.getAutoData(), forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    alert = Alert(error)
                    return
                }
                
                guard let data = data else {
                    return
                } 
                // Parse the user info response
                if let _ = try? JSONDecoder().decode(InviteReponse.self, from: data) {
                    Task{
                        await reloadInvite(copy: false)
                    }
                    
//                    if invites.status == "success" {}
                    /**
                     
                     {
                         "status": "success",
                         "message": "\u64cd\u4f5c\u6210\u529f",
                         "data": true,
                         "error": null
                     }
                     
                     */
                    
                }
            }
        }

        task.resume()
    }
    
    
    
    
    
}


