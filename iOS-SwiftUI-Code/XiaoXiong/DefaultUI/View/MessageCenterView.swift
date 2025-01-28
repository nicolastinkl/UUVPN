//
//  MessageCenterView.swift
//  SFI
//
//  Created by Mac on 2024/10/24.
//

import Foundation

//
//
//  QuestionView.swift
//  SFI
//
//  Created by Mac on 2024/10/24.
//

import ApplicationLibrary
import Foundation
import SwiftUI

struct MessageCenterView: View {
    
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
                    
                    Text("消息通知")
                        .fontWeight(.bold).lineLimit(1)
                }
                .padding()
                //                .padding(.top,edges.top)
                .foregroundColor(.white)
                
                
                Text("暂无消息").font(.subheadline).padding()
                Spacer()
                
            }.navigationBarHidden(true).edgesIgnoringSafeArea(.bottom).foregroundColor(.white).background(
                LinearGradient(colors: [
                
                    Color("BG1"),
                    Color("BG1"),
                    Color("BG2"),
                    Color("BG2"),
                    
                ], startPoint: .top, endPoint: .bottom))
               
        })
         
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true) // 隐藏返回按钮
        
    }
    
}
