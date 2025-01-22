//
//  OrderPaymentView.swift
//  SFI
//
//  Created by Mac on 2024/10/21.
//

import Foundation

//

import SwiftUI

struct OrderPaymentView: View {
    var orderinfo : OrderInfoDatum
    
    @State private var alert: Alert?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @Environment(\.openURL) private var openURL
    
    @State private var showAlert = false
    @State private var payment :PaymentReponseDatum?
    
    
    @State private var ischeckout = false
    
    @Environment(\.presentationMode) var presentationMode // 环境变量用于控制视图的呈现
    
    var body: some View {
        NavigationView(content: {
            VStack{
                
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
                        if orderinfo.status == 0 {
                       
                            Button(action: {
                                alert = Alert(YesOrNOMessage: "确定取消订单吗？"){
                                    Task{
                                        await cancelorder(orderNO: orderinfo.tradeNo)
                                    }
                                }
                            }, label: {
                                
                                Text("取消订单")
                                    .foregroundColor(.red)
                            })
                        
                        }                        
                    }
                    Spacer()
                    
                    Text("订单详情")
                        .fontWeight(.bold).lineLimit(1).frame(width: UIScreen.main.bounds.width*0.5)
                    .foregroundColor(.white)
                    Spacer()
                }
                .padding(.all)
                
                
                
                VStack(spacing: 20) {
                    ScrollView(.vertical, showsIndicators: false) {
                        // Product Details Section
                        VStack(alignment: .leading, spacing: 10) {
                            Text("订单详情")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            HStack {
                                Text("订单号: ")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                Text(orderinfo.tradeNo)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            
                            HStack {
                                Text("创建时间: ")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                Text(TimestampConverter.convertTimestampToDateString(orderinfo.createdAt))
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            
                            Spacer().frame(height: 20)
                            
                            Text("商品详情")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            HStack {
                                Text("商品名称: ")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                Text(orderinfo.plan.name)
                                    .font(.subheadline)
                                    .foregroundColor(.yellow)
                            }
                            
                            HStack {
                                Text("类型/周期: ")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                Text(orderinfo.period_zh)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            
                            HStack {
                                Text("产品流量: ")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                Text("\(orderinfo.plan.transferEnable ?? 0)GB/月")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            
                            // Pending payment stamp (badge)
                            Spacer()
                            HStack {
                                Spacer()
                                Text(orderinfo.status_zh)
                                    .font(.subheadline)
                                    .padding(10)
                                    .background(orderinfo.status == 1 ? Color.green: (orderinfo.status == 0 ? Color.red : Color.gray))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(10)
                        
                        // Payment Method Section
                        VStack(alignment: .leading) {
                            Text("支付方式")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                
                            }
                            
                            if let errorMessage = errorMessage {
                                Text(errorMessage)
                                    .bold()
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center) // 确保多行文本居中
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                
                            }else{
                                
                                Text("\(payment?.name ?? "") (\(payment?.handlingFeePercent ?? "")%手续费)")
                                    .font(.subheadline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.red.opacity(0.3))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            
                            
                        }
                        .padding()
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(10)
                        
                        // Order Summary Section
                        VStack(alignment: .leading) {
                            Text("订单摘要")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            HStack {
                                Text("商品价格:")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                Spacer()
                                Text("¥\(String(format: "%.2f", orderinfo.totalAmount/100))")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            
                            HStack {
                                Text("手续费:")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                Spacer()
                                Text("¥\(String(format: "%.2f", shouxufei()))")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            
                            HStack {
                                Text("总计:")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                Spacer()
                                Text("¥\(String(format: "%.2f", total()))")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(10)
                        
                        if orderinfo.status == 0 {
                            // Pay Now Button
                            Button(action: {
                                // Trigger the payment action
                                showAlert = true
                            }, label: {
                                HStack {
                                    Image(systemName: "cart")
                                    Text("立即支付")
                                    if ischeckout {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle()).tint(.white)
                                    }
                                    
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                                
                            }).disabled(ischeckout)
                                .padding()
                                .alert(isPresented: $showAlert) {
                                    Alert(
                                        title: Text("提示"),
                                        message: Text("确认要支付吗？"),
                                        primaryButton: .default(Text("确定"),action: {
                                            Task{
                                                if let paymentID = payment?.id {
                                                    await submitOrder(orderNO:orderinfo.tradeNo,paymentID:paymentID)
                                                }
                                                
                                            }
                                        }),
                                        secondaryButton: .cancel(Text("取消"))
                                    )
                                }
                        }
                    }
                    
                }
            }
            .padding()
            .navigationBarHidden(true)
            .onAppear(){
                Task{
                     await getPayment()
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .background(
              BackgroundBg()
            )
        })
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true) // 隐藏返回按钮
        .alertBinding($alert)
    }
    
     func  shouxufei() -> Double {
         return orderinfo.totalAmount/100 * (Double(payment?.handlingFeePercent ?? "") ?? 0.0)/100
    }
                                 
     func  total() -> Double{
        return orderinfo.totalAmount/100 +  shouxufei()
    }
    
    func cancelorder(orderNO:String) async {
        //cancel?trade_no=2024102108102956235125484
        let userInfoUrl = URL(string: "\(UserManager.shared.baseURL())user/order/cancel?trade_no=\(orderNO)")!
        var request = URLRequest(url: userInfoUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(UserManager.shared.getAutoData(), forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
            
                if let error = error {
                    alert = Alert(error)
                    return
                }
                
                guard let data = data else {
                    alert = Alert(errorMessage: "取消失败,返回数据为空")
                    return
                }
                 
                 
                struct cancelResponse: Codable {
                    let status, message: String?
                   
                }
                
                  
                // Parse the user info response
               if let message = try? JSONDecoder().decode(cancelResponse.self, from: data) {
                   if let status = message.status,status == "success" {
                       alert = Alert(okMessage: "取消成功", {
                           presentationMode.wrappedValue.dismiss() // 手动触发返回
                       })
                   }else{
                       alert = Alert(errorMessage: message.message ?? "" )
                   }
                   
                   //2024101311320180720&sitename=
                   
               }
            }
        }

        task.resume()
    }
    func submitOrder(orderNO:String,paymentID:Int) async {
        ischeckout = true
        let userInfoUrl = URL(string: "\(UserManager.shared.baseURL())user/order/checkout?trade_no=\(orderNO)&method=\(paymentID)")!
        var request = URLRequest(url: userInfoUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(UserManager.shared.getAutoData(), forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                ischeckout = false
                if let error = error {
                    alert = Alert(error)
                    return
                }
                
                guard let data = data else {
                    alert = Alert(errorMessage: "支付失败,返回数据为空")
                    return
                }
                 
                 
                struct saveOrderResponse: Codable {
                    let status, message, data: String?
                   
                }
                
                
                // Parse the user info response
               if let message = try? JSONDecoder().decode(saveOrderResponse.self, from: data) {
                   if let payurl = message.data,payurl.count > 10 {
                       openURL(URL(string:payurl)!)
                   }else{
                       alert = Alert(errorMessage: message.message ?? "" )
                   }
                   
                   //2024101311320180720&sitename=
                   
               }
            }
        }

        task.resume()
    }
    func getPayment() async {
        
        isLoading = true
        errorMessage = nil

        
        let userInfoUrl = URL(string: "\(UserManager.shared.baseURL())user/order/getPaymentMethod")!
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
               if let Subscribe = try? JSONDecoder().decode(PaymentReponse.self, from: data) {
                    
                   if let data = Subscribe.data {
                       payment = data.first
                       
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
//struct PaymentView_Previews: PreviewProvider {
//    static var previews: some View {
//        OrderPaymentView()
//    }
//}
