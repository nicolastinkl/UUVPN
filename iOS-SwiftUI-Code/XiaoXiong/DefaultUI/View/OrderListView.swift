//
//  OrderListView.swift
//  SFI
//
//  Created by Mac on 2024/10/21.
//
 
import Foundation
import SwiftUI

struct OrderListView: View {
    
//    @Binding var isPresented: Bool
     
    @State private var planList: [OrderInfoDatum] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var alert: Alert?
    @Environment(\.openURL) private var openURL
    
    @Environment(\.presentationMode) var presentationMode // 环境变量用于控制视图的呈现
    
    var body: some View {
        NavigationView(content: {
            VStack {
                
                // Navigation Bar
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
                         
                         Spacer()
                     }
                     Spacer()
                     VStack(spacing: 5){
                         
                         Text("我的订单")
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
                        if planList.isEmpty {
                           //  Text("Loading plans...") // Loading indicator
                            if !isLoading
                            {
                                Text("暂无记录").font(.caption)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center) // 确保多行文本居中
                                    .padding()
                            }
                        } else {
                            
                            ForEach(planList) { plan in
                                
                                NavigationLink(destination: OrderPaymentView(orderinfo: plan )) {
                                    OrderItemView(orderinfo: plan)
                                }
//
//                                Button(action: {
//                                     
//                                }, label: {
//                                    OrderItemView(orderinfo: plan)
//                                })
                                 
                            }
                        }
                        
                    }
                }.padding(.top, 20)
                
                Spacer()
                
                // Subscription Notice
                Text("订阅须知:仅支持微信和支付宝付款")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
            .background(
               BackgroundBg()
            )
            .onAppear(){
                Task{
                    await getOrderList()
                }
            }.edgesIgnoringSafeArea(.bottom)
        
        })
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true) // 隐藏返回按钮
        .alertBinding($alert)
        
    }
     
     
     
    public func getOrderList() async {
        
        isLoading = true
        errorMessage = nil

        
        let userInfoUrl = URL(string: "\(UserManager.shared.baseURL())user/order/fetch")!
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
               if let Subscribe = try? JSONDecoder().decode(OrderInfoReponse.self, from: data) {
                    
                   if let data = Subscribe.data {
                       planList = data
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



struct OrderItemView: View {
    var orderinfo : OrderInfoDatum
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(orderinfo.plan.name + " " + "\(orderinfo.plan.transferEnable ?? 0)GB/月")
                    .font(.headline)
                    .foregroundColor(.black).multilineTextAlignment(.leading)
                
                
                Text("订单号："+orderinfo.tradeNo)
                    .font(.headline)
                    .foregroundColor(.black).multilineTextAlignment(.leading)
                //.fontWeight(orderinfo.status == 2 ? .bold : .regular)
                
                
                Text("订单金额：¥\(String(format: "%.2f", orderinfo.totalAmount/100))")
                    .font(.subheadline)
                    .foregroundColor(.black)
                
                HStack (spacing: 4) {
                    Text(orderinfo.status_zh)
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(2)
                    .background(orderinfo.status == 1 ? Color.green: (orderinfo.status == 0 ? Color.red : Color.gray) )
                    .cornerRadius(4)
                    .foregroundColor(.white)
                    .offset(y:10)
                 
                    Text(orderinfo.period_zh)
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(2)
                    .background(Color("Main"))
                    .cornerRadius(4)
                    .foregroundColor(.white)
//                    .offset(x: -16, y:16)
                    .offset(y:10)
                    
                    Spacer()
                    
                    
                    Text("创建时间："+TimestampConverter.convertTimestampToDateString(orderinfo.createdAt))
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(2)
                    .foregroundColor(.gray)
//                    .offset(x: -16, y:16)
                    .offset(y:10)
                }
                
            }
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
        .padding(.horizontal, 20)
    }
}

//struct SubscriptionView_Previews: PreviewProvider {
//    static var previews: some View {
//        SubscriptionView()
//    }
//}
