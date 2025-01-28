//
//  SideMenuView.swift
//  SFI
//
//  Created by Mac on 2024/10/12.
//

import Foundation
import SwiftUI
import ApplicationLibrary
import WebKit
 
import Libbox
import Library

struct SideMenuView: View {
    
    @Binding var isPresented: Bool  
    @Binding var isLoggedIn: Bool
    
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    @State private var plandes: SubscribeReponseClass?
    @State private var size: CGSize = .zero
    @State private var avator = UserManager.shared.getUserInfo().avator
    @State private var emailid = UserManager.shared.getUserInfo().email
    
    @EnvironmentObject private var environments: ExtensionEnvironments
    @State private var alert: Alert?
    
    
    @State private var showAlert = false
    @State  private  var isInviteActive = false
    
    @State  private  var isLogouting = false
    
    
    @AppStorage("paymentURLKey") private var paymentURLKey = ""
    
    var body: some View {
        NavigationView {
            VStack() {
                
                // Navigation Bar
                // 用户信息区域
                ZStack{
                    
                    HStack{
                        Button(action: {
                            isPresented = false // Close the side menu
                        }, label: {
                            
                            Image(systemName: "chevron.left")
                               .foregroundColor(.white)
                                 
                            Text("返回")
                                .foregroundColor(.white)
                        }).padding(10) // 增加可点击区域
                        Spacer(minLength: 0)
                    }
                    
                    Text("设置")
                        .fontWeight(.bold).lineLimit(1)
                }
                .padding()
                //                .padding(.top,edges.top)
                .foregroundColor(.white)
                ScrollView(.vertical, showsIndicators: false) {
                    
                    // Profile Section
                    VStack {
                        
                        
                        HStack {

//                        AsyncImage(url: URL(string: avator)){ phase in
//                                if let image = phase.image {
//                                    image // Displays the loaded image.
//                                } else if phase.error != nil {
//                                   Color.red // Indicates an error.
//                                } else {
//                                    Color.blue // Acts as a placeholder.
//                                }
//                            }.frame(width: 50, height: 50)
//                            .clipShape(Circle())
//                        Image("applogo").resizable().frame(width: 50, height: 50).clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("账户信息:")
                                    .font(.headline).fontWeight(.light)
                                
                                Text(emailid)
                                    .font(.headline)
                                    .bold()
                                
                            }
                            Spacer()
                            /*
                             Spacer()
                             Button {
                             showAlert = true
                             } label: {
                             
                             Text("退出登录").foregroundColor(.red)
                             Image(systemName: "rectangle.portrait.and.arrow.forward")
                             .foregroundColor(.red)
                             .aspectRatio(contentMode: .fill)
                             .frame(width: 4, height: 4)
                             
                             }*/
                            
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        .shadow(color: .gray.opacity(0.1), radius: 5, x: 0, y: 5)
                        
                        if (paymentURLKey.count > 3){
                            HStack {
                                
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
                                }else{
                                    
                                    if let plandesss = self.plandes {
                                        if plandesss.transferEnable > 0 {
                                            VStack(alignment: .leading, spacing: 5) {
                                                
                                                //   Text("订阅详情：")  .font(.subheadline)
                                                
                                                
                                                Text(plandesss.plan?.name ?? "")
                                                    .font(.subheadline)
                                                let u = plandesss.d/1024/1024/1024
                                                let t = plandesss.transferEnable/1024/1024/1024
                                                
                                                Spacer().frame(height: 10)
                                                
                                                Text("已用: \(u) GB / 总计：\(t) GB")
                                                    .font(.subheadline).bold()
                                                
                                                HStack {
                                                    // White bar on the left
                                                    //                                            RoundedRectangle(cornerRadius: 10)
                                                    //                                                .fill(Color.red)
                                                    //                                                .frame(width: 300*CGFloat(plandesss.d)/CGFloat(plandesss.transferEnable),  height: 20)
                                                    //
                                                    Text("").frame(height: 20).frame(minWidth: (CGFloat(plandesss.d)/CGFloat(plandesss.transferEnable))<=0.1 ? 20 : 300*(CGFloat(plandesss.d)/CGFloat(plandesss.transferEnable))).background(
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .fill(
                                                                Color.red
                                                            )
                                                    )
                                                    Spacer() // Fill the remaining space to push the white rectangle to the left
                                                }
                                                .frame(height: 20) // Set the total width and height for the bar
                                                .background(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .fill(
                                                            Color.gray.opacity(0.5)
                                                        )
                                                )
                                                .padding()
                                                
                                                
                                                
                                                
                                                //                                    ScrollView {
                                                //                                        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                                //                                    AttributedText(htmlContent: plan.content, size: $size)
                                                //                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: size.height, maxHeight: .infinity)
                                                //                                        .background(.clear)
                                                
                                            }
                                            Spacer()
                                        }else{
                                            Spacer()
                                            Text("暂无订阅")
                                                .font(.subheadline)
                                            Spacer()
                                        }
                                        
                                    }
                                }
                                
                                
                                
                            }.padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                                .shadow(color: .gray.opacity(0.1), radius: 5, x: 0, y: 5)
                        }
                    }  .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                    
                    // Menu Items
                    // List {
                    //                    NavigationLink(destination: WebShuntView()) {
                    //                        MenuItem(icon: "globe", title: "App日志", color: .white, isNew: false)
                    //                    }
                    LazyVStack(spacing: 10, content: {
                        NavigationLink(destination: SupportTicketView()) {
                            MenuItem(icon: "listclipboard", title: "我的工单", color: .white, isNew: false)
                        }
                        Divider() // 分隔线
                        
                        if (paymentURLKey.count > 3){
                            
                            NavigationLink(destination: UpgradeView()) {
                                MenuItem(icon: "crown.fill", title: "升级套餐", color: .yellow, isNew: true)
                            }
                            Divider() // 分隔线
                            NavigationLink(destination: OrderListView()) {
                                MenuItem(icon: "checkout", title: "我的订单", color: .white, isNew: false)
                            }
                            
                            Divider() // 分隔线
                            NavigationLink(destination: InviteListView(isPresented: $isInviteActive)) {
                                MenuItem(icon: "star.fill", title: "邀请中心", color: .white, isNew: false)
                            }
                            Divider() // 分隔线
                            
                            
                        }else{
                                                        
                            NavigationLink(destination: MessageCenterView()) {
                                MenuItem(icon: "message.badge.circle", title: "消息通知", color: .white, isNew: false)
                            }
                            Divider() // 分隔线
                        }
                        
                        
                        NavigationLink(destination: QuestionView()) {
                            MenuItem(icon: "questionmark.app", title: "问题解答", color: .white, isNew: false)
                        }
                        
                        Divider() // 分隔线
                        
                        NavigationLink(destination: SupportView()) {
                            MenuItem(icon: "headphones", title: "联系客服", color: .white, isNew: false)
                        }
                        Divider() // 分隔线
                        NavigationLink(destination: AboutUsView()) {
                            MenuItem(icon: "info.circle.fill", title: "关于我们", color: .white, isNew: false)
                        }
                        Divider() // 分隔线
                    }).padding()
                    
                    Button(action: {
                        // Trigger the payment action
                        // showAlert = true
                        
                        alert = Alert(YesOrNOMessage: "确定退出登录吗？", {
                            isLogouting=true
                            UserManager.shared.clearUserData()
                            //删除订阅信息
                            Task {
                                //await reloadSubscribe()
                                
                            }
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                                isLoggedIn = false
                            }
                            
                        })
                        
                    }, label: {
                        HStack {
                            Image(systemName: "trash.fill")
                            Text("退出登录")
                            
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        
                    }).padding()
                    
                }
                    
               // }
               // .listStyle(PlainListStyle())
                 
            }.background(
                BackgroundBg()
            ).modifier(ActivityIndicatorModifier(isLoading: isLogouting, color: Color.black.opacity(0.8), lineWidth: 1))
            .onAppear {
                Task {
                    await reloadSubscribe()
                }
            }.navigationBarHidden(true)
            
        }.alertBinding($alert)

    }
    
    private func writeProfilePreviewList() async throws {
        let profiles = try await ProfileManager.list()
        
        for profile in profiles {
            print("detele : \(profile.path) \(profile.remoteURL ?? "" )")
            await deleteProfile(profile)
        }
    }

    private func deleteProfile(_ profile: Profile) async {
        do {
            _ = try await ProfileManager.delete(profile)
        } catch {
            alert = Alert(error)
            return
        }
        environments.profileUpdate.send()
    }

    
    @MainActor
    public func reloadSubscribe() async {
        
        isLoading = true
        errorMessage = nil
        
        let userInfoUrl = URL(string: "\(UserManager.shared.baseURL())user/getSubscribe")!
        var request = URLRequest(url: userInfoUrl)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(UserManager.shared.getAutoData(), forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = "套餐数据请求失败: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "套餐数据请求失败:数据为空"
                    return
                } 
                // Parse the user info response
                if let Subscribe = try? JSONDecoder().decode(SubscribeReponse.self, from: data) {
                    
                    if let data = Subscribe.data {
                        
                        plandes = data
                        emailid = data.email
                                             
                        UserManager.shared.storeUserInfo(email: emailid, avator: "")
//                        UserManager.shared.storeSuburlData(data: data.subscribeURL)
                        
                    }else{
                        self.errorMessage = Subscribe.message ?? ""
                    }
                    
                    
                }else{
                    self.errorMessage = "套餐数据请求失败"
                }
            }
        }

        task.resume()
    }
    
    
    
    // Sample Destination Views for each menu item
    struct UpgradeView: View {
        @State private var isSubscriptionActive = false
        var body: some View {
            SubscriptionView(isPresented: $isSubscriptionActive)
        }
    }
    
    
    struct WebShuntView: View {
        var body: some View {
            VStack(alignment: .trailing, content: {
                LogView()
                ProfileView()
            })
        }
    }

    


    struct Free30DaysView: View {
        @State private var islogined = false
        var body: some View {
            InviteView(isPresented: $islogined)
        }
    }

    struct AboutUsView: View {
        var body: some View {
            SettingsAboutView()
        }
    }
  
}

struct MenuItem: View {
    let icon: String
    let title: String
    let color: Color
    let isNew: Bool?
    
    var body: some View {
//        Button {
//            
//        } label: {
//
//        }

        HStack {
            
            if  UIImage(systemName: icon)  != nil{
                
                Image(systemName: icon)
                    .foregroundColor(color).tint(.white)
                    .frame(width: 24, height: 24)
                
            }else{
                
                Image(icon).resizable()
                    .foregroundColor(.white).tint(.white)
                    .frame(width: 24, height: 24)
                
            }
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 18))
            Spacer()
            
            if isNew == true {
                Circle()
                    .fill(Color.red)
                    .frame(width: 8, height: 8)
            }
        }
        
        .padding(.vertical, 10)
      
    }
}

struct AttributedText: UIViewRepresentable {
    let htmlContent: String
    @Binding var size: CGSize
    
    private let webView = WKWebView()
    var sizeObserver: NSKeyValueObservation?
    
    func makeUIView(context: Context) -> WKWebView {
        webView.scrollView.isScrollEnabled = false //<-- Here
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: AttributedText
        var sizeObserver: NSKeyValueObservation?
        
        init(parent: AttributedText) {
            self.parent = parent
            sizeObserver = parent.webView.scrollView.observe(\.contentSize, options: [.new], changeHandler: { (object, change) in
                parent.size = change.newValue ?? .zero
            })
        }
    }
}
