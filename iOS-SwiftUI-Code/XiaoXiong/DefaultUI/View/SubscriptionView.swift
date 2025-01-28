//
//  SubscriptionView.swift
//  SFI
//
//  Created by Mac on 2024/10/12.
//

import Foundation
import SwiftUI

struct SubscriptionView: View {
    
    @Binding var isPresented: Bool
     
    @State private var planList: [DatuPlanResponse] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var alert: Alert?
    @State var orderinfo : OrderInfoDatum?
    @Environment(\.openURL) private var openURL
    
    let adimages = ["10-35-24", "10-35-15", "10-35-03"] // 替换为你广告图片的名字
    let adimagesString = ["小熊加速器 采用最高安全 ECC 加密技术，仅需一键操作，军事级的加密技术将护航您的任何互联网访问", "小熊加速器 拥有170 个热门城市的300+高速服务器，您可以随时随地获得高速安全的互联网体验", "小熊加速器 支持所有当前主流的平台系统，您可以在几乎任何设备上使用"]
    @Environment(\.presentationMode) var presentationMode // 环境变量用于控制视图的呈现
    // 当前页的索引
    
    
    @State private var isNavigationActive = false // 控制跳转
    
    @State private var currentIndex = 0
    // 自动轮播计时器
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView(content: {
            VStack {
                ZStack{
                    
                    
                    HStack{
                        
                        Button(action: {
                            withAnimation {
                                isPresented = false // Close the side menu
                            }
                            presentationMode.wrappedValue.dismiss()   // 手动触发返回
                        }, label: {
                            
                            Image(systemName: "chevron.left")
                               .foregroundColor(.white)
                                 
                            Text("返回")
                                .foregroundColor(.white)
                        }).padding(10) // 增加可点击区域
                        
                        Spacer()
                        
                        NavigationLink(destination: OrderListView()) {
                            Text("我的订单").foregroundColor(.red)
                        }.listRowBackground(Color.clear)
                        
                    }
                    Spacer()
                    VStack(spacing: 5){
                        
                        Text( "升级套餐")
                            .fontWeight(.bold).lineLimit(1).frame(width: UIScreen.main.bounds.width*0.5)
                        
                    }
                    .foregroundColor(.white)
                    Spacer()
                    
                }
                .padding(.all)
                
                if let orderinfoS = orderinfo{
                    
                    NavigationLink(destination: OrderPaymentView(orderinfo: orderinfoS),isActive: $isNavigationActive, label: {
                        EmptyView() // 隐藏的视图
                    })
                }
                
               
                
                //
                //            // Subscription Plans
                
                ScrollView(.vertical, showsIndicators: false) {
                    // VPN Info and Trial Offer
                    VStack(spacing: 8) {
                        // 图片轮播
                        TabView(selection: $currentIndex) {
                            ForEach(0..<adimages.count, id: \.self) { index in
                                VStack(spacing: 8) {
                                    Image(adimages[index])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: UIScreen.main.bounds.width * 0.8,height: 150)
                                        .cornerRadius(10)
                                        .tag(index)
                                    
                                    
                                    Text(adimagesString[index])
                                        .font(.subheadline)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 20)
                                }
                                
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // 隐藏系统自带的指示器
                        .frame(height: 220)
                        .onReceive(timer) { _ in
                            // 自动切换广告
                            withAnimation {
                                currentIndex = (currentIndex + 1) % adimages.count
                            }
                        }
                        
                        // 自定义指示器
                        HStack(spacing: 8) {
                            ForEach(0..<adimages.count, id: \.self) { index in
                                Circle()
                                    .fill(index == currentIndex ? Color.green : Color.gray)
                                    .frame(width: 5, height: 5)
                            }
                        }
                        //                .padding(.top, 3)
                        
                        
                        // Free Trial Text
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.shield.fill")
                                .foregroundColor(.green)
                            Text("首次订阅免费试用 2 天")
                                .font(.title3)
                                .fontWeight(.bold)
                            
                        }
                        .padding(.top, 10)
                        
                        Text("订阅可随时取消，试用期内取消不收取任何费用")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)
                    
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
                    VStack(spacing: 16) {
                        if planList.isEmpty {
                            //  Text("Loading plans...") // Loading indicator
                        } else {
                            
                            ForEach(planList) { plan in
                                
                                Button(action: {
                                    //print( plan.content ?? "")
                                    Task{
                                        await subPlanOrder(plan_id:plan.idOLD ?? 0,amount : plan.monthPrice ?? 0)
                                    }
                                }, label: {
                                    
                                    SubscriptionPlanView(planName: plan.name, originalPrice: "¥\(String(format: "%.2f", Double(plan.monthPrice ?? 0)/100)) /月", discountedPrice: "", discountPercentage: "", monthlyPrice: "", content: plan.content ?? "", bestPlan: plan.idOLD == planList.count,planContent: "\(plan.transferEnable ?? 0)GB/月")
                                    
                                    //                                Text( plan.content ?? "").padding()
                                    
                                    
                                    
                                })
                                
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
            .background(
                LinearGradient(colors: [
                    
                    Color("BG1"),
                    Color("BG1"),
                    Color("BG2"),
                    Color("BG2"),
                    
                ], startPoint: .top, endPoint: .bottom)
            )
            //        .background(.white)
            .onAppear(){
                Task{
                    await getPlanList()
                }
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.bottom)
            
        })
        .navigationBarHidden(true)
        .alertBinding($alert)
        .navigationBarBackButtonHidden(true) // 隐藏返回按钮
    }
     
    
     
    public func subPlanOrder(plan_id: Int,amount: Int) async {
        let userInfoUrl = URL(string: "\(UserManager.shared.baseURL())user/order/save?plan_id=\(plan_id)&period=month_price&coupon_code=")!
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
                    alert = Alert(errorMessage: "提交订单信息错误，请重试")
                    return
                }
                 
                 
                struct saveOrderResponse: Codable {
                    let status, message, data: String?
                   
                }
                
  
                
                // Parse the user info response
               if let message = try? JSONDecoder().decode(saveOrderResponse.self, from: data) {
                   if let dataNO = message.data,dataNO.count > 10 {
                       Task{
                           await getOrderInfo(OrderNO: dataNO)
                       }
                       
                       
                   }else{
                       alert = Alert(errorMessage: message.message ?? "" )
                   }
                   
                   //2024101311320180720&sitename=
                   
               }
            }
        }

        task.resume()
        
        
    }
    
    func getOrderInfo(OrderNO: String) async {
    
        
        let userInfoUrl = URL(string: "\(UserManager.shared.baseURL())user/order/detail?trade_no=\(OrderNO)")!
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
               if let Subscribe = try? JSONDecoder().decode(OrderInfoSingleReponse.self, from: data) {
                    
                   if let data = Subscribe.data {
                       orderinfo = data                       
                       isNavigationActive = true
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
    
 
    
    
    func getPlanList() async {
        
        isLoading = true
        errorMessage = nil

        
        let userInfoUrl = URL(string: "\(UserManager.shared.baseURL())user/plan/fetch")!
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
               if let Subscribe = try? JSONDecoder().decode(PlanResponse.self, from: data) {
                    
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



struct SubscriptionPlanView: View {
    var planName: String
    var originalPrice: String
    var discountedPrice: String
    var discountPercentage: String
    var monthlyPrice: String
    
    var content: String
    var bestPlan: Bool = false
    var planContent: String
    
    var body: some View {
        
        VStack(spacing: 5, content: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(planName)
                        .font(.headline)
                        .fontWeight(bestPlan ? .bold : .regular)
                        .foregroundColor(bestPlan ? .green : .black)
                    Text(planContent).font(.subheadline).fontWeight(bestPlan ? .bold : .regular).foregroundColor( .black)
                    if bestPlan {
                        Text("Best")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(4)
                            .background(Color.red)
                            .cornerRadius(4)
                            .foregroundColor(.white)
                            .offset(x: -15, y:16)
                    }
                }
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                  
                    
                    HStack {
                       /* if bestPlan {
                            Text("\(discountPercentage) OFF")
                                .font(.caption)
                                .padding(4)
                                .foregroundColor(.white).background(.green)
                                .cornerRadius(16)
                        }else{
                            Text("\(discountPercentage) OFF")
                                .font(.caption)
                                .padding(4)
                                .foregroundColor(.black).background(.gray.opacity(0.5))
                                .cornerRadius(16)
                        }
                        Text(discountedPrice)
                            .strikethrough()
                            .foregroundColor(.gray)
                        
                        */
                        Text(originalPrice)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                         
                    }
                    
                    Text(monthlyPrice)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            
          //  Text(extractChinese(from:  content)).font(.subheadline).foregroundStyle(.black).padding()
            //HTMLTextView(htmlString:content)
            
        }).padding()
        
        .background(Color.white.opacity(0.9))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
        .padding(.horizontal, 20)
    }
    
    func extractChinese(from text: String) -> String {
            let pattern = "[\\u4e00-\\u9fa5]+"  // 匹配中文字符的正则表达式
            let regex = try? NSRegularExpression(pattern: pattern, options: [])
            let nsString = text as NSString
            let results = regex?.matches(in: text, options: [], range: NSRange(location: 0, length: nsString.length))

            // 提取匹配的中文
            let chineseStrings = results?.compactMap { result -> String? in
                
                if let range = Range(result.range, in: text) {
                    return String(text[range])
                }
                return nil
            }
            dump(chineseStrings)
            return chineseStrings?.joined(separator: " ") ?? ""
        }
    
}

//struct SubscriptionView_Previews: PreviewProvider {
//    static var previews: some View {
//        SubscriptionView()
//    }
//}
