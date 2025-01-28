//
//  InviteListView.swift
//  SFI
//
//  Created by Mac on 2024/10/21.
//

import Foundation
import SwiftUI
import ApplicationLibrary

//InviteListView
struct InviteListView : View{
    
    @Binding var isPresented: Bool
    
    @State private var codeslist: [InviteCode] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var alert: Alert?
    @State private var stat: [Int]?
    
    @Environment(\.openURL) private var openURL
    
    @Environment(\.presentationMode) var presentationMode // 环境变量用于控制视图的呈现
    
    var body: some View {
        NavigationView(content: {
            VStack {
                
                // Navigation Bar
                ZStack{
                    
                
                     HStack{
                         
                         Button(action: {
                             isPresented = false
                             presentationMode.wrappedValue.dismiss() // 手动触发返回
                         }, label: {
                             
                             Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                  
                             Text("返回")
                                 .foregroundColor(.white)
                         }).padding(10) // 增加可点击区域
                         Spacer()
                         
                         Button(action: {
                             Task{
                                 await genoneInvite()
                             }
                         }, label: {
                             Text("生成邀请码").foregroundColor(.white)
                         })
                         
                     }
                     Spacer()
                     VStack(spacing: 5){
                         
                         Text("我的邀请")
                             .fontWeight(.bold).lineLimit(1).frame(width: UIScreen.main.bounds.width*0.5)
                         
                     
                     }
                     .foregroundColor(.white)
                    Spacer()
                    
                   
                }
                .padding(.all)
                 
                   
                
                if isLoading {
                      ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                  }
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .bold()
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center) // 确保多行文本居中
                        .padding()
                }

    //
    //            // Subscription Plans
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        VStack {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), alignment: .leading) {
                                if let st = stat {
                                    StatusItem("邀请注册人数") {
                                        
                                        StatusLine("人数", "\(st[0])")
                                    }
                                    StatusItem("邀请佣金比例") {
                                        
                                        StatusLine("比例", "\(st[3])%")
                                    }
                                    StatusItem("确认中的佣金") {
                                        
                                        StatusLine("金额（¥）", "\(st[1])")
                                    }
                                    StatusItem("累计获得佣金") {
                                        
                                        StatusLine("金额（¥）", "\(st[2])")
                                    }
                                }
                                    
                                
                             }.background {
                                GeometryReader { geometry in
                                    Rectangle()
                                        .fill(.clear)
                                        .frame(height: 1)
                                        .onChangeCompat(of: geometry.size.width) { newValue in
                                            //updateColumnCount(newValue)
                                        }
                                        .onAppear {
                                           // updateColumnCount(geometry.size.width)
                                        }
                                }.padding()
                            }
                        }
                        .frame(alignment: .topLeading)
                        .padding([.top, .leading, .trailing])
                        
                        if codeslist.isEmpty {
                           //  Text("Loading plans...") // Loading indicator
                            if !isLoading
                            {
                                Text("暂无记录").font(.caption)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center) // 确保多行文本居中
                                    .padding()
                            }
                        } else {
                            
                            ForEach(codeslist) { plan in
                                Button(action: {
                                    UIPasteboard.general.string =  UserManager.shared.mainregisterURL()+plan.code
                                    alert = Alert(okMessage: "复制成功: " + UserManager.shared.mainregisterURL()+plan.code )
                                }, label: {
                                    InviteItemView(invicode: plan)
                                })
                                 
                            }
                        }
                        
                    }
                }.padding(.top, 20)
                
                Spacer()
                
                // Subscription Notice
                Text(" ")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
            }
            .background(
                LinearGradient(colors: [
                
                    Color("BG1"),
                    Color("BG1"),
                    Color("BG2"),
                    Color("BG2"),
                    
                ], startPoint: .top, endPoint: .bottom)
            )
            .navigationBarHidden(true)
    //        .background(.white)
            .onAppear(){
                Task{
                    await getCodesList()
                }
            }.edgesIgnoringSafeArea(.bottom)
        
        })
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true) // 隐藏返回按钮
        .alertBinding($alert)
        
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
                
                
                struct InviteReponse2: Codable {
                    let status, message: String?
                }
                // Parse the user info response
                if let response = try? JSONDecoder().decode(InviteReponse2.self, from: data),let  message = response.message {
                    
                    if let status = response.status, status == "success" {
                        alert = Alert(okMessage: message){
                            
                            Task{
                                await  getCodesList()
                            }
                        }
                    }else{
                        alert = Alert(errorMessage: message)
                    }
                }
            }
        }

        task.resume()
    }
    
    
    private struct StatusLine: View {
        private let name: String
        private let value: String

        init(_ name: String, _ value: String) {
            self.name = name
            self.value = value
        }

        var body: some View {
            HStack {
                Text(name)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text(value)
                    .font(.subheadline)
            }
        }
    }

    private struct StatusItem<T>: View where T: View {
        private let title: String
        @ViewBuilder private let content: () -> T

        init(_ title: String, @ViewBuilder content: @escaping () -> T) {
            self.title = title
            self.content = content
        }

        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .font(.subheadline)
                    Spacer()
                }.padding(.bottom, 8)
                content()
            }
            .frame(minWidth: 125, alignment: .topLeading)
            #if os(tvOS)
                .padding(EdgeInsets(top: 20, leading: 26, bottom: 20, trailing: 26))
            #else
                .padding(EdgeInsets(top: 10, leading: 13, bottom: 10, trailing: 13))
            #endif
                .background(backgroundColor.opacity(0.3))
                .cornerRadius(10)
        }

        private var backgroundColor: Color {
            #if os(iOS)
            return Color(.gray)
            #elseif os(macOS)
                return Color(nsColor: .textBackgroundColor)
            #elseif os(tvOS)
                return Color(uiColor: .black)
            #endif
        }
    }
     
     
    public func getCodesList() async {
        
        isLoading = true
        errorMessage = nil

        
        let userInfoUrl = URL(string: "\(UserManager.shared.baseURL())user/invite/fetch")!
        var request = URLRequest(url: userInfoUrl)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(UserManager.shared.getAutoData(), forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = "数据请求失败： \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "数据请求失败"
                    return
                }
                 
                
                
//                if let jsonString = String(data: data, encoding: .utf8) {
//                      print("Response data: \(jsonString)")
//                  } else {
//                      print("Failed to convert data to string.")
//                  }
//                
                
                // Parse the user info response
               if let Subscribe = try? JSONDecoder().decode(InviteReponse.self, from: data) {
                    
                   if let codes = Subscribe.data?.codes {
                       codeslist = codes
                       stat = Subscribe.data?.stat
                   }else{
                       self.errorMessage = Subscribe.message ?? ""
                   }
                    
                }else{
                    self.errorMessage = "数据请求失败： JSON 解析错误"
                }
                 
            }
        }

        task.resume()
    }
    
}



struct InviteItemView: View {
    var invicode : InviteCode
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                
                Text("邀请码：" + invicode.code )
                    .font(.headline)
                    .foregroundColor(.black).multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity)
                
                    Spacer()
                    
                    
                    Text("创建时间："+TimestampConverter.convertTimestampToDateString(invicode.createdAt))
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(2)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.gray)
//                    .offset(x: -16, y:16)
                    .offset(y:10)
            
                
            }
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
        .padding(.horizontal, 20)
    }
}
