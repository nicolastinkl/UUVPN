//
//  SupportticketView.swift
//  SFI
//
//  Created by Mac on 2024/10/20.
//

import Foundation
import SwiftUI
import ApplicationLibrary
 
 

struct SupportTicketView : View {
  
    var edges = getSafeAreaInsets()
    
    @State var selectedTab = "Chats"
    @Namespace var animation
     
    @Environment(\.presentationMode) var presentationMode // 环境变量用于控制视图的呈现
    @State private var TicketsList: [TicketsReponseDatum] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var alert: Alert?
    
    @State private var showInputSheet = false
    @State private var tickettitle = ""
    @State private var userInput = ""
    
    @State private var isInputLoading = false
    @State private var submitmessage = ""
    var body: some View{
        NavigationView(content: {
            VStack(spacing: 0){
                
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
                           
                            Button(action: {
                                showInputSheet.toggle()
                                 }, label: {
                                //                            Image(systemName: "note.text.badge.plus")
                                Text("提交新工单").foregroundColor(.red)
                            })
                            
                        }
                        
                        Text("我的工单").fontWeight(.bold).lineLimit(1)
                         
                    }
                    .padding()
    //                .padding(.top,edges.top)
                    .foregroundColor(.white)
                    
                    
    //                HStack(spacing: 20){
    //
    //                    ForEach(tabs,id: \.self){title in
    //
    //                        TabButton(selectedTab: $selectedTab, title: title, animation: animation)
    //                    }
    //                }
    //                .padding()
    //                .background(Color.white.opacity(0.08))
    //                .cornerRadius(15)
    //                .padding(.vertical)
                }
                .padding(.bottom)
//                .background(Color("top"))
//                .clipShape(CustomCorner(corner: .bottomLeft, size: 65))
                
                ZStack{
                    
//                    Color("top")
                    
//                    Color("bg")
//                        .clipShape(CustomCorner(corner: .topRight, size: 65))
                     
                    ScrollView(.vertical, showsIndicators: false, content: {
                        
                        VStack(spacing: 20){
                            
                            /*HStack{
                                
                                Text("All Chats")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Spacer(minLength: 0)
                                
                                Button(action: {}, label: {
                                    
                                    Image(systemName: "slider.horizontal.3")
                                        .font(.system(size: 22))
                                        .foregroundColor(.primary)
                                })
                            }
                            .padding([.horizontal,.top])*/
                            
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
                            if TicketsList.count > 0 {
                                
                                ForEach(TicketsList){chatData in
                                    // Chat View...
                                    NavigationLink(destination: SupportTicketChatView(ticketID: chatData.idOLD)) {
                                        ChatView(chatData: chatData)
                                    }
                                }
                            }else{
                                if !isLoading
                                {
                                    Text("暂无记录").font(.caption)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.center) // 确保多行文本居中
                                        .padding()
                                }
                            }
                        }
                        .padding(.vertical)
                        
                    })
                    //.clipShape(CustomCorner(corner: .topRight, size: 65))
                    // its cutting off inside view may be its a bug....
                }
            }.onAppear(){
                Task{
                    await getPlanList()
                }
            }
            .navigationBarHidden(true)
            //.background(Color("bg").ignoresSafeArea(.all, edges: .all))
            .background(
            LinearGradient(colors: [
            
                Color("BG1"),
                Color("BG1"),
                Color("BG2"),
                Color("BG2"),
                
            ], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all, edges: .all))
//            .ignoresSafeArea(.all, edges: .top)
            .sheet(isPresented: $showInputSheet) {
                InputSheet(tickettitle: $tickettitle, userInput: $userInput, isInputLoading: $isInputLoading, submitmessage: $submitmessage, onSubmit: {
                          Task {
                              // 提交网络请求
                              await submitTicketData(title: tickettitle, userInput: userInput)
                          }
                      })
                  }
                
        })
        .navigationBarHidden(true)
        .alertBinding($alert)
        .navigationBarBackButtonHidden(true) // 隐藏返回按钮
    }
    
    public func submitTicketData(title: String, userInput: String) async{
           isInputLoading = true
           let userInfoUrl = URL(string: "\(UserManager.shared.baseURL())user/ticket/save?subject=\(title)&level=0&message=\(userInput)")!
           var request = URLRequest(url: userInfoUrl)
           request.httpMethod = "POST"
           request.addValue("application/json", forHTTPHeaderField: "Content-Type")
           request.addValue(UserManager.shared.getAutoData(), forHTTPHeaderField: "Authorization")

           let task = URLSession.shared.dataTask(with: request) { data, response, error in
               DispatchQueue.main.async {
                   isInputLoading = false
                   if let error = error {
                       submitmessage =  ( "数据请求失败： \(error.localizedDescription)")
                       return
                   }
                   
                   guard let data = data else {
                       submitmessage =  ( "数据请求失败")
                       return
                   }
                   // MARK: - TicketSendMsgReponse
                   struct TicketSendMsgReponse: Codable {
                       let status, message: String?
                       
                   }
                  
                   // Parse the user info response
                   if let SendMsgReponse = try? JSONDecoder().decode(TicketSendMsgReponse.self, from: data), let message = SendMsgReponse.message {
                       
                      if let stutas  = SendMsgReponse.status , stutas == "success" {
                          submitmessage =  message
                          //1s 后 关闭窗口
                          withAnimation {
                              DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                 showInputSheet = false
                                  //刷新界面
                                  Task{
                                      await getPlanList()
                                  }
                             }
          
                          }
                      }else{
                          submitmessage =  (message)
                      }
                       
                   }else{
                       submitmessage =  ( "数据请求失败： JSON 解析错误")
                   }
                    
               }
           }

           task.resume()
       }
         
    
    
   public func getPlanList() async {
       
       isLoading = true
       errorMessage = nil

       
       let userInfoUrl = URL(string: "\(UserManager.shared.baseURL())user/ticket/fetch")!
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
               
               // Parse the user info response
              if let Subscribe = try? JSONDecoder().decode(TicketsReponse.self, from: data) {
                   
                  if let data = Subscribe.data {
                      TicketsList = data
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

var tabs = ["Chats","Status","Calls"]

struct TabButton : View {
    
    @Binding var selectedTab : String
    var title : String
    var animation : Namespace.ID
    
    var body: some View{
        
        Button(action: {
            
            withAnimation{
                
                selectedTab = title
            }
            
        }, label: {
            
            Text(title)
                .foregroundColor(.white)
                .padding(.vertical,10)
                .padding(.horizontal)
                // Sliding Effect...
                .background(
                
                    ZStack{
                        
                        if selectedTab == title{
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("top"))
                                .matchedGeometryEffect(id: "Tab", in: animation)
                        }
                    }
                )
        })
    }
}

struct CustomCorner : Shape {
    
    var corner : UIRectCorner
    var size : CGFloat
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize(width: size, height: size))
        
        return Path(path.cgPath)
    }
}

struct ChatView : View {
    
    var chatData : TicketsReponseDatum
    
    var body: some View{
        
        HStack(spacing: 10){
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 8, content: {
                        
                        Text(chatData.subject)
                            .fontWeight(.bold)
                            .lineLimit(1).foregroundColor(.white)
                        
//                        Text("官方回复：\(chatData.message ?? "未回复")")
//                            .font(.caption)
//                            .lineLimit(1)
                                                
                        HStack(content: {
                            
                            if(chatData.status == 1){
                                Text("工单状态 : 已关闭").fontWeight(.light).foregroundColor(.gray).font(.subheadline)
                            }else if(chatData.status == 0){
                                Text("工单状态 : 待回复").fontWeight(.light).foregroundColor(.red).font(.subheadline)
                            }else if(chatData.status == 2){
                                Text("工单状态 : 已回复").fontWeight(.light).foregroundColor(.green).font(.subheadline)
                            }
                            
                            Spacer(minLength: 0)
                            
                            Text("\(TimestampConverter.convertTimestampToDateString(chatData.updatedAt))")
                                .font(.subheadline).foregroundColor(.white)
                                
                            
                        })
                       
                         
                    })
                    
                }
                
                Divider()
            }
        }
        .padding(.horizontal)
    }
}

// Model And Sample Data....
//
//struct Chat : Identifiable {
//    
//    var id = UUID().uuidString
//    var name : String
//    var image : String
//    var msg : String
//    var time : String
//}
//
//// were going to do custom grouping of views....
//
//struct HomeData {
//    
//    var groupName : String
//    var groupData : [Chat]
//}

//var FriendsChat : [Chat] = [
//
//    Chat(name: "iJustine",image: "p0", msg: "Hey EveryOne !!!", time: "02:45"),
//    Chat(name: "Kavsoft",image: "p1", msg: "Learn - Develop - Deploy", time: "03:45"),
//    Chat(name: "SwiftUI",image: "p2", msg: "New Framework For iOS", time: "04:55"),
//    Chat(name: "Bill Gates",image: "p3", msg: "Founder Of Microsoft", time: "06:25"),
//    Chat(name: "Tim Cook",image: "p4", msg: "Apple lnc CEO", time: "07:19"),
//    Chat(name: "Jeff",image: "p5", msg: "I dont Know How To Spend Money :)))", time: "08:22"),
//]
//
//var GroupChat : [Chat] = [
//
//    Chat(name: "iTeam",image: "p0", msg: "Hey EveryOne !!!", time: "02:45"),
//    Chat(name: "Kavsoft - Developers",image: "p1", msg: "Next Video :))))", time: "03:45"),
//    Chat(name: "SwiftUI - Community",image: "p2", msg: "New File Importer/Exporter", time: "04:55"),
//]
//
//var data = [
//
//    // Group 1
//    HomeData(groupName: "", groupData: FriendsChat),
//]

struct InputSheet: View {
    @Binding var tickettitle: String
    @Binding var userInput: String
    @Binding var isInputLoading: Bool
    @Binding var submitmessage:String
    var onSubmit: () -> Void
    var body: some View {
        VStack(spacing: 20) {
           
            Spacer()
            
            Text("新的工单").fontWeight(.bold).lineLimit(1)
            
            Text("请输入工单标题").font(.subheadline) .foregroundColor(.gray)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.leading)
            .padding(.leading, 5) // 添加左侧内边距
            .padding(.top, 8) // 添加顶部内边距
                
            TextEditor( text: $tickettitle)
                          .textFieldStyle(RoundedBorderTextFieldStyle())
                          .padding()
                          .frame(width: UIScreen.main.bounds.width * 0.9,height: 50)
                          .background(Color.clear) // 设置背景为透明
                          .cornerRadius(10) // 圆角
                          .overlay(
                              RoundedRectangle(cornerRadius: 10)
                                  .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                          ) // 添加边框
                          .background(Color.clear) // 设置背景为透明// 添加边框
                          .font(.system(size: 18))
                          .transparentScrolling()

                        
            
                Text("请输入工单内容").font(.subheadline) .foregroundColor(.gray)
                .frame(maxWidth: .infinity)
                .padding(.leading, 5) // 添加左侧内边距
                .padding(.top, 8) // 添加顶部内边距
                .multilineTextAlignment(.leading)
            
                TextEditor(text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.9,height: UIScreen.main.bounds.height * 0.4)
                    .background(Color.clear) // 设置背景为透明
                    .cornerRadius(10) // 圆角
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    ) // 添加边框
                    .font(.system(size: 18))
                    .transparentScrolling()
           
            
            
            
                
            Spacer()
            
            if !submitmessage.isEmpty{
                Text(submitmessage).font(.subheadline).foregroundColor(Color.red.opacity(0.9))
            }
            
            Button(action: {
                if( tickettitle.count > 0  && userInput.count > 0){
                    onSubmit() // 提交时触发回调
                }
                
            }) {
                if isInputLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle()).tint(Color("Main"))
                } else {
                    Text("提交工单")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
                       .frame(maxWidth: .infinity)
                       .padding(.bottom, 20)

            
        }
        .background(Color("bg").ignoresSafeArea(.all, edges: .all))
        .ignoresSafeArea(edges: .bottom) // 忽略安全区域，保证按钮位置靠底部
    }
}


