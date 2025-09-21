//
//  SettingsAboutView.swift
//  SFI
//
//  Created by Mac on 2024/10/12.
//

import Foundation

//

import SwiftUI

struct SettingsAboutView: View {
    @State private var alert: Alert?
    @Environment(\.openURL) private var openURL // 引入环境值
    @Environment(\.presentationMode) var presentationMode // 环境变量用于控制视图的呈现
    var body: some View {
        
        NavigationView(content: {
            VStack() {
                
                ZStack{
                    
                    HStack{
                        Button(action: {
                            
                            presentationMode.wrappedValue.dismiss() // 手动触发返回
                        }, label: {
                            
                            Image(systemName: "chevron.left")
                               .foregroundColor(.white)
                                 
                            Text("返回")
                                .foregroundColor(.white)
                        }).padding(10) // 增加可点击区域
                        Spacer(minLength: 0)
                    }
                    
                    Text("关于我们")
                        .fontWeight(.bold).lineLimit(1)
                }
                .padding()
                //                .padding(.top,edges.top)
                .foregroundColor(.white)
                
                
                Spacer().frame(height: 40)
                // 顶部的Logo和标题
                VStack {
                    Image("applogo")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .foregroundColor(.orange) // 使用系统图标，实际图标替换时可以用 Image("logo")
                    
                  
                    Text("UUVPN for iOS \n在您的 iPhone 和 iPad 上体验最快的全球网络连接工具")
                        .font(.subheadline)                        
                        .padding(.top, 10)
                        .frame(width: 300)
                        .multilineTextAlignment(.center)
                    
                    
                    
                }
                
                Spacer().frame(height: 40)
                
                // 设置项列表
                List {
                    
                    HStack {
                        Text("当前版本")
                        Spacer()
                        Text( Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String ?? "1.0.0").foregroundColor(.gray)
                    }.padding(.vertical, 10).listRowBackground(Color.clear)
                    
                    Button(action: {
                        alert = Alert(okMessage: "没有检测到更新，已经是最新版本.")
                    }, label: {
                        HStack {
                            Text("检查更新")
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.gray)
                        }.padding(.vertical, 10)
                    }).listRowBackground(Color.clear)
                    
                    
                    
                    Button(action: {
                        if let url = URL(string: UserManager.shared.websiteURL()) {
                            openURL(url) { accepted in  //  通过设置 completion 闭包，可以检查是否已完成 URL 的开启。状态由 OpenURLAction 提供
                                print(accepted ? "Success" : "Failure")
                            }
                        }
                    }, label: {
                        HStack {
                            Text("官方网址")
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.gray)
                        }.padding(.vertical, 10)
                    }).listRowBackground(Color.clear)
                    
                    
                    Button(action: {
                        if let url = URL(string: UserManager.shared.telegramUrl()) {
                            openURL(url) { accepted in  //  通过设置 completion 闭包，可以检查是否已完成 URL 的开启。状态由 OpenURLAction 提供
                                print(accepted ? "Success" : "Failure")
                            }
                        }
                    }, label: {
                        
                        HStack {
                            Text("订阅Telegram频道")
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.gray)
                        }.padding(.vertical, 10)
                    }).listRowBackground(Color.clear)
                    
                    
                }
                .listStyle(PlainListStyle()) // 设置为普通列表样式
                
                Spacer()
                
                // 底部的版权信息和链接
                VStack {
                    HStack {
                        Button(action: {
                            // 打开用户协议链接
                            if let url = URL(string: "https://minipanda.soccertt.com/teams.html") {
                                openURL(url) { accepted in  //  通过设置 completion 闭包，可以检查是否已完成 URL 的开启。状态由 OpenURLAction 提供
                                    print(accepted ? "Success" : "Failure")
                                }
                            }
                        }) {
                            Text("用户协议")
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .underline()
                        }
                        Button(action: {
                            // 打开隐私政策链接
                            if let url = URL(string: "https://minipanda.soccertt.com/privacy.html") {
                                openURL(url) { accepted in  //  通过设置 completion 闭包，可以检查是否已完成 URL 的开启。状态由 OpenURLAction 提供
                                    print(accepted ? "Success" : "Failure")
                                }
                            }
                        }) {
                            Text("隐私政策")
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .underline()
                        }
                    }
                    .padding(.horizontal)
                    
                    Text("Copyright 2014 - 2024, UUVPN 版权所有")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.top, 5)
                }
                .padding(.bottom, 10)
            }
            .background(
                BackgroundBg()
            )        
            .alertBinding($alert)
//            .padding()
            .navigationBarHidden(true)
//            .edgesIgnoringSafeArea(.bottom)
        })
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true) // 隐藏返回按钮
        
    }
     
}

#Preview {
    SettingsAboutView()
}
