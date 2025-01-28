//
//  QuestionView.swift
//  SFI
//
//  Created by Mac on 2024/10/24.
//

import ApplicationLibrary
import Foundation
import SwiftUI

struct QuestionView: View {
    
    @Environment(\.presentationMode) var presentationMode // 环境变量用于控制视图的呈现
    
    var body: some View {
        NavigationView(content: {
            VStack{
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
                    
                    Text("问题解答")
                        .fontWeight(.bold).lineLimit(1)
                }
                .padding()
                //                .padding(.top,edges.top)
                .foregroundColor(.white)
                
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                     
                        HStack{
                            Text("App软件无法使用问题？")  // 让 Text 宽度为屏幕宽度
                            Spacer()
                        }
                        Section("") {
                            Text("1：确认网络没问题，包括 WIFI 和 移动网络可用 \n2：确认手机可访问浏览器正常数据,可以尝试访问 https://www.apple.com 试试网络是否连接正常。")
                                .buttonStyle(.plain).font(.subheadline)
                                .foregroundColor(Color.white.opacity(0.8))
                            
                        }
                        Divider() // 分隔线
                         
                        
                        HStack{
                            Text("初次连接提示创建“VPN连接”失败?")  // 让 Text 宽度为屏幕宽度
                            Spacer()
                        }
                        
                        Section("") {
                            Text("到这种情况可能是VPN功能被系统被禁止了。可以尝试到设置中开启“VPN连接”权限，若还有问题请随时联系客服。")
                                .buttonStyle(.plain).font(.subheadline)
                                .foregroundColor(Color.white.opacity(0.8))
                            
                        }
                        Divider() // 分隔线
                        
                        HStack{
                            Text("指定的国家连接不上?")  // 让 Text 宽度为屏幕宽度
                            Spacer()
                        }
                        
                        Section("") {
                            Text("快连每个国家的背后都有成干上百的网络节点在进行智能调控，若遇到指定国家连接不上的情况请随时联系客服为您定位原因，请放心一定能解决!")
                                .buttonStyle(.plain).font(.subheadline)
                                .foregroundColor(Color.white.opacity(0.8))
                            
                        }
                        Divider() // 分隔线
                        
                        
                         HStack{
                             Text("连接成功了，但无法访问外网?")  // 让 Text 宽度为屏幕宽度
                             Spacer()
                         }
                        Section("") {
                            Text("恭喜您遇到了严重的软件BUG，请尽快联系客服复现问题，领取BUG奖励~!!!")
                                .buttonStyle(.plain).font(.subheadline).foregroundColor(Color.white.opacity(0.8))
                                
                            
                        }
                        
                        Divider() // 分隔线
                       
                        HStack{
                            Text("遇到VPN无法连接怎么办？")  // 让 Text 宽度为屏幕宽度
                            Spacer()
                        }
                        
                        Section("") {
                            Text("1：确定您所安装的小熊加速器是最新版本  2：尝试重启客户端  3：联系我们的客服 ").multilineTextAlignment(.leading)
                                .buttonStyle(.plain).font(.subheadline).foregroundColor(Color.white.opacity(0.8))
                                
                            
                        }
                    }.padding(.leading,10).padding(.trailing,10)
                }.foregroundColor(.white)
            }.navigationBarHidden(true).edgesIgnoringSafeArea(.bottom).background(
                BackgroundBg()
            )
               
        })
         
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true) // 隐藏返回按钮
        
    }
    
}

 
