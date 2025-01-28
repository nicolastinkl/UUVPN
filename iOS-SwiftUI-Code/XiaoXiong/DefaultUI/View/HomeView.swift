//
//  Home.swift
//  Home
//
//  Created by Balaji on 12/09/21.
//

import SwiftUI
import ApplicationLibrary 
import Libbox
import Library
import SwiftUI
import Crisp

struct HomeView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var environments: ExtensionEnvironments
    @State private var alert: Alert?
    
    @State private var selection = NavigationPage.dashboard
    @State private var importProfile: LibboxProfileContent?
    @State private var importRemoteProfile: LibboxImportRemoteProfile?
    @State private var isUpdating = false
    @State private var profileList: [ProfilePreview] = []
    @State private var isUrlTesting = false
    
    
    @AppStorage("serverData") private var serverData: String = ""
      // 用于记录上次更新的时间
    @AppStorage("lastFetchTime") private var lastFetchTime: Double = 0.0 // = Date(timeIntervalSince1970: 0).timeIntervalSince1970
   
    @Binding var isLoggedIn: Bool
    
    @State private var isNodesLoading = true
    
    @StateObject private var commandClient = CommandClient(.groups)
    
    @State private var groups: [OutboundGroup] = []
    @State private var groups_firsttime: [OutboundGroup] = []
    
    
    @State var isConnected = false
    
    // Current Server...
    @State var servers: [nodereponseData] = []
    
     
    @State var serverstixignfufeiTest: [nodereponseData] = [nodereponseData( type: "", name: "香港1🇭🇰高速节点", rate: "", id2: 1, isOnline: 1, cacheKey: ""),nodereponseData( type: "", name: "香港2🇭🇰高速节点", rate: "", id2: 1, isOnline: 1, cacheKey: ""),nodereponseData( type: "", name: "香港3🇭🇰高速节点", rate: "", id2: 1, isOnline: 1, cacheKey: ""),nodereponseData( type: "", name: "香港4🇭🇰高速节点", rate: "", id2: 1, isOnline: 1, cacheKey: ""),nodereponseData( type: "", name: "美国🇺🇸高速节点", rate: "", id2: 1, isOnline: 1, cacheKey: ""),nodereponseData( type: "", name: "日本🇯🇵高速节点", rate: "", id2: 1, isOnline: 1, cacheKey: ""),nodereponseData( type: "", name: "法国🇫🇷高速节点", rate: "", id2: 1, isOnline: 1, cacheKey: ""),nodereponseData( type: "", name: "韩国🇰🇷高速节点", rate: "", id2: 1, isOnline: 1, cacheKey: ""),nodereponseData( type: "", name: "新加坡🇸🇬高速节点", rate: "", id2: 1, isOnline: 1, cacheKey: ""),nodereponseData( type: "", name: "新加坡1🇸🇬高速节点", rate: "", id2: 1, isOnline: 1, cacheKey: ""),nodereponseData( type: "", name: "新加坡2🇸🇬高速节点", rate: "", id2: 1, isOnline: 1, cacheKey: ""),nodereponseData( type: "", name: "新加坡3🇸🇬高速节点", rate: "", id2: 1, isOnline: 1, cacheKey: ""),nodereponseData( type: "", name: "新加坡4🇸🇬高速节点", rate: "", id2: 1, isOnline: 1, cacheKey: ""),nodereponseData( type: "", name: "新加坡5🇸🇬高速节点", rate: "", id2: 1, isOnline: 1, cacheKey: ""),nodereponseData( type: "", name: "新加坡6🇸🇬高速节点", rate: "", id2: 1, isOnline: 1, cacheKey: "")]
    @State var currentServer: nodereponseData = nodereponseData( type: "", name: "", rate: "", id2:0, isOnline: 0 , cacheKey: "")
    @State var changeServer = false
        
    @State private var isUserViewActive = false
    @State private var isSubscriptionActive = false
    @State private var isInviteActive = false
    @State private var isKefuActive = false
    @State private var isErrorViewActive = false
    //@State private var currentNode = UserDefaults.standard.string(forKey: "selectedNode") ?? "自动选择"
    @AppStorage("selectedNode") private var currentNode = "自动选择"
    @AppStorage("goGrouptag") private var goGrouptag = ""
    
    @AppStorage("paymentURLKey") private var paymentURLKey = ""
    @State private var islogined = false
    
    @State private var loadingNodes = false
    
    @State private var urltestinggoGrouptag = ""
    @State private var isConfiging = false
    
    @AppStorage("baseDYURL") private var  baseDYURL = ""
    
    @State private var xufeiNotify = false
    
    
    let adimages = ["11-53-53", "12-11-56", "12-14-11"] // 替换为你广告图片的名字
    
    // 当前页的索引
    @State private var currentIndex = 0
    // 自动轮播计时器
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
       
        VStack{
            
            HStack{
                    
                
                
                Button {
                    withAnimation{
                        isUserViewActive.toggle()
                    }
                } label: {
                    
                    Image(systemName: "circle.grid.cross")
                        .font(.title2)
                        .padding(5)
                        .foregroundColor(.white)
                        .background(
                            
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(.white.opacity(0.25),lineWidth: 1)
                        )
                }
                     
                Spacer()
                
                /* Button {
                    withAnimation{
                        isSubscriptionActive.toggle()
                        
                    }
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .font(.title2)
                        .padding(12)
                        .background(
                            
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(.white.opacity(0.25),lineWidth: 1)
                        )
                } */
                if (paymentURLKey.count > 3){
                    
                   // Text Bubble
                   Button {
                       withAnimation{
                           isSubscriptionActive.toggle()
                           
                       }
                   } label: {
                           
                       Text("超值折扣")
                           .font(.footnote)
                           .foregroundColor(.white)
                           .padding(.horizontal, 10)
                           .padding(.vertical, 6)
                           .background(
                               RoundedRectangle(cornerRadius: 4)
                                   .fill(Color.orange)
                           )
                           .overlay(
                               TriangleShape()
                                   .fill(Color.orange)
                                   .frame(width: 10, height: 10)
                                   .offset(x: 10)
                               , alignment: .trailing
                           )
                       
                       // Panda Image with VIP Tag
                       HStack(spacing: 10){
                           Text(verbatim: "")
                           Image("applogo") // Replace with actual image asset
                               .resizable()
                               .frame(width: 30, height: 30)
                               .cornerRadius(15)
                           
   //                                Text("VIP")
   //                                    .font(.caption)
   //                                    .fontWeight(.bold)
   //                                    .foregroundColor(.yellow)
   //                                    .padding(4)
   //                                    .background(Color.orange)
   //                                    .cornerRadius(4)
                       }
                       
                   }
                   .padding()
                }
                
                
                Button {
                    withAnimation{
                        isKefuActive.toggle()
                    }
                } label: {
                    
                    Image(systemName: "person.fill.questionmark")
                        .font(.title2)
                        .padding(5)
                        .foregroundColor(.white)
                        .background(
                            
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(.white.opacity(0.25),lineWidth: 1)
                        )
                    Text("客服").foregroundColor(.white)
                }
                
            }
//            .overlay(
//                
//                // Attributed Text...
//                Text(getTitle())
//            )
//            .foregroundColor(.white)
        
        // end navigationbar
        
//        DashboardView()
            
        // discount view
//        Image("11-53-53").resizable().scaledToFill()
//                .frame(width: UIScreen.main.bounds.width * 0.8,height: 150)
//                .cornerRadius(10)
            
            // 图片轮播
            TabView(selection: $currentIndex) {
                ForEach(0..<adimages.count, id: \.self) { index in
                    
                    Button {
                        if index == 0 {
                            if (paymentURLKey.count > 3){
                                withAnimation{
                                    isSubscriptionActive.toggle()
                                    
                                }
                            }
                        }
                        if index == 1 {
                            if (paymentURLKey.count > 3){
                                withAnimation{
                                    isInviteActive.toggle()
                                    
                                }
                            }
                        }
                        
                    } label: {
                        Image(adimages[index])
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width * 0.8,height: 150)
                            .cornerRadius(10)
                            .tag(index)
                    }

                    
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // 隐藏系统自带的指示器
            .frame(height: 150)
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
                        .fill(index == currentIndex ? Color.blue : Color.gray)
                        .frame(width: 5, height: 5)
                }
            }
            .padding(.top, 3)
            
            if environments.extensionProfileLoading {
                //加载是否安装 VPN 插件
                VStack{
                    LottieView(animationFileName: "8c31d47d" , loopMode: .loop)
                } .aspectRatio(contentMode: .fill)
                  .scaleEffect(0.1).frame(width: 190,height: 190).padding()
                
           } else if let profile = environments.extensionProfile {
               //已经安装 Profile VPN 插件的情况下。
            
               DashboardViewNewUI().environmentObject(profile)
               
               ConnectErrorView
               Spacer()
           }else {
                 
               InstallProfileButton { error in
                   handleProfileButtonError(error)
               }
               
               ConnectErrorView
                            
               
#if targetEnvironment(simulator)
               
               StartStopButton()              
               ClashModeView()
//               ExtensionStatusView()
               
#endif
           }
            
        // Power Button....
//        PowerButton()
            

        // Max Frame...
//        .frame(height: 120)
//        .padding(.top,getRect().height < 750 ? 20 : 40)
        // Why using max frame...
        // it will be useful to fit the content to small iphones later...
        }
        .padding()
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
        .modifier(ActivityIndicatorModifier(isLoading: isConfiging, color: Color.black.opacity(0.8), lineWidth: 1))
        .background(
            Background()
        )
        // Blur View when Server page shows...
        .overlay(
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(changeServer ? 1 : 0)
                .ignoresSafeArea()
                .onTapGesture {
                                        
                    withAnimation{
                        changeServer.toggle()
                    }
                }
        )
        .overlay(
            BottomSheet(),            
            alignment: .bottom
        )
        .ignoresSafeArea(.container, edges: .bottom)
        // Since the theme is black ...
        // using always dark mode...
        .preferredColorScheme(.dark)
        .onAppear {
             
            print("onAppear ->  \(islogined)")
            //await environments.reload()
            
            environments.postReload()
            Task {
                
                await doReload()
                
                await getConfigCache()
                
               // await doReloadSystemProxy()
            }
            
            
        }
        .fullScreenCover(isPresented: $isUserViewActive, content: {
            SideMenuView(isPresented: $isUserViewActive, isLoggedIn: $isLoggedIn)
        }).transition(.slide)
        .fullScreenCover(isPresented: $isSubscriptionActive, content: {
            SubscriptionView(isPresented: $isSubscriptionActive)
        }).transition(.slide)
        .fullScreenCover(isPresented: $isKefuActive, content: {
            SupportView()
        })
        .onReceive(environments.openProfileGetSuccess, perform: { _ in
            Task{
                await referGetLocalNodes()
            }
        })
        .onReceive(environments.opentixingSubnodes, perform: { _ in
//            print("onReceive opentixingSubnodes")
            isSubscriptionActive = true
        })
        .fullScreenCover(isPresented: $isInviteActive, content: {
            InviteListView(isPresented: $isInviteActive)
        })
        .popover(isPresented: $isErrorViewActive, content: {
            QuestionView()
        })
        .alertBinding($alert)
        .onChangeCompat(of: scenePhase) { newValue in
            if newValue == .active {
                environments.postReload()
            }
        }
        .onChangeCompat(of: selection) { newValue in
            print("onChangeCompat: \(newValue)" )
        } 
        .onReceive(commandClient.$groups, perform: { groups in
            
            if let groups {
                print("节点刷新成功 groups: \(String(describing: groups.count))")
                setGroups(groups)
            }
        })
        .environment(\.selection, $selection)
        .environment(\.importProfile, $importProfile)
        .environment(\.importRemoteProfile, $importRemoteProfile)
        .handlesExternalEvents(preferring: [], allowing: ["*"])
        
    }
    
 
    
    private func handleXufeiTixingButtonError(){
        alert = Alert(title: Text("续费提醒"), message: Text("您的账户已经过期，请续费后继续体验畅快感受；如果您刚购买完请耐心等待，会员时长会在1分钟内到账。"),dismissButton:.default(Text("续费")) {
          
            withAnimation{
                isSubscriptionActive.toggle()
                
            }
        })
    }
    
    private func handleProfileButtonError(_ error: Error?) {
           if let err = error {
               alert = Alert(errorMessage: err.localizedDescription, {
                
               })
           } else {
               Task {
                   await environments.reload()
               }
           }
       }
    
    private var ConnectErrorView: some View{
        VStack {
       // Spacer()
        
        HStack {
            Button {
                isErrorViewActive.toggle()
            } label: {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                
                Text("无法连接？ 查看解决方案 >>")
                    .foregroundColor(.red)
                    .font(.system(size: 16))
            }

        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.8) // 占据屏幕宽度的 90%
        .background(Color.red.opacity(0.2))
        .cornerRadius(20)
        
        //Spacer()
    }
    }
    
    private func installProfile() async {
        do {
            try await ExtensionProfile.install()
            environments.postReload()
            
        } catch {
            alert = Alert(error)
        }
        
    }
    
    private func setGroups(_ goGroups: [LibboxOutboundGroup]) {
        
        var groups = [OutboundGroup]()
        if let goGroup = goGroups.first {
            goGroup.isExpand = true
            var items = [OutboundGroupItem]()
            let itemIterator = goGroup.getItems()!
            while itemIterator.hasNext() {
                let goItem = itemIterator.next()!
                
//                OutboundGroupItem
                items.append(OutboundGroupItem(tag: goItem.tag, type: goItem.type, urlTestTime: Date(timeIntervalSince1970: Double(goItem.urlTestTime)), urlTestDelay: UInt16(goItem.urlTestDelay)))
            }


            groups.append(OutboundGroup(tag: goGroup.tag, type: goGroup.type, selected: goGroup.selected, selectable: goGroup.selectable, isExpand: goGroup.isExpand, items: items))
            
            urltestinggoGrouptag = goGroup.tag
            //不要给默认值
            //UserDefaults.standard.setValue("\(goGroup.tag)", forKey: "goGrouptag")
            
        }
               
        /* 原有的全部显示逻辑
        var groups = [OutboundGroup]()
        for goGroup in goGroups {
            print(goGroup.tag)
            //默认设置为开启
            goGroup.isExpand = true
            var items = [OutboundGroupItem]()
            let itemIterator = goGroup.getItems()!
            while itemIterator.hasNext() {
                let goItem = itemIterator.next()!
                items.append(OutboundGroupItem(tag: goItem.tag, type: goItem.type, urlTestTime: Date(timeIntervalSince1970: Double(goItem.urlTestTime)), urlTestDelay: UInt16(goItem.urlTestDelay)))
            }
            groups.append(OutboundGroup(tag: goGroup.tag, type: goGroup.type, selected: goGroup.selected, selectable: goGroup.selectable, isExpand: goGroup.isExpand, items: items))
        }*/
        self.groups = groups
        
        isNodesLoading = false
    }
    
    private func referGetLocalNodes() async{
        
       
        
        do {
            profileList = try await ProfileManager.list().map { ProfilePreview($0) }
            if let profilePrview  = profileList.first {
                 
                
                guard let profile = try await ProfileManager.get(profilePrview.id) else {
                    throw NSError(domain: "Profile missing", code: 0)
                }
                
                let profileContent = try profile.read()
                
                // MARK: - Datum
                struct localDataum: Codable {
                    let outbounds: [Outbound]?
                    
                }
                
                struct Outbound: Codable {
                    let outboundDefault: String?
                    let outbounds: [String]?
                    let tag, type: String
                    let method, password, server: String?
                    let serverPort: Int?

                    enum CodingKeys: String, CodingKey {
                        case outboundDefault = "default"
                        case outbounds, tag, type, method, password, server
                        case serverPort = "server_port"
                    }
                }

                
                
                if let data =  profileContent.data(using: String.Encoding.utf8), let reponsesubdata = try? JSONDecoder().decode(localDataum.self, from: data){
                    if let itemsOuts  = reponsesubdata.outbounds {
                                
                        
                        var groups = [OutboundGroup]()
                        var items = [OutboundGroupItem]()
                        
                        var index = 0
                        var goItemindex = false
                        var tagname = ""
                        var tagtype = ""
                        itemsOuts.forEach { goItem in
                            if goItem.type == "urltest"{
                                goItemindex = true
                                tagname = goItem.tag
                                tagtype = goItem.type
                                print(goItem.tag + "  " + goItem.type)
                            }
                            
                            if goItemindex {
                                if let method = goItem.method, let server = goItem.server {
                                   // let numberThree: Int = 100 + Int(arc4random_uniform(400))

                                    
                                    var sss = OutboundGroupItem(tag: goItem.tag, type: goItem.type, urlTestTime: Date(timeIntervalSince1970: 12), urlTestDelay: UInt16(0))
                                    sss.server = server
                                    sss.method = method
                                    sss.password = goItem.password
                                    sss.server_port = goItem.serverPort
                                    items.append(sss)
                                }else{
                                    
                                    let sss = OutboundGroupItem(tag: goItem.tag, type: goItem.type, urlTestTime: Date(timeIntervalSince1970: 12), urlTestDelay: UInt16(0))
    //                                sss.server = server
    //                                sss.method = method
    //                                sss.password = goItem.password
    //                                sss.server_port = goItem.serverPort
                                    items.append(sss)
                                }
                            }
                            
                            
                            
                            index = index  + 1
                        }
                        
                        //groups.append(OutboundGroup(tag: "自动选择", type: "selector", selected: goGrouptag, selectable:true, isExpand: true, items: items))
                        groups.append(OutboundGroup(tag: tagname, type:tagtype, selected: goGrouptag, selectable:true, isExpand: true, items: items))
                        
                        await MainActor.run {
                            self.groups_firsttime = groups
                            print("第一次加载 nodes 列表 \(groups_firsttime.count)")
                        }
                    }
                }else{
                    print("本地 JSON 节点解析失败")
                }
                    
                
               
                  //  self.profile = profile
                   // self.profileContent = profileContent
                    
                    
                 
                
            }
        } catch {
            alert = Alert(error)
            return
        }
        
    }
    
    
    private func doReload() async {
        
        do {
            profileList = try await ProfileManager.list().map { ProfilePreview($0) }
        } catch {
            alert = Alert(error)
            return
        }
        
//        environments.emptyProfiles = profileList.isEmpty
    }
    
    
    public func reloadnotice() async {
        let userInfoUrl = URL(string: "\(UserManager.shared.baseURL())user/notice/fetch")!
        var request = URLRequest(url: userInfoUrl)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(UserManager.shared.getAutoData(), forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let _ = error {
                    
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                
                // MARK: - Welcome
                struct NoticeResponse: Codable {
                    let data: [NoticeResponseDatum]?
                    let total: Int?
                }

                // MARK: - Datum
                struct NoticeResponseDatum: Codable {
                    let title, content: String
                    let show: Int
                }

                // Parse the user info response
                if let reponsesubdata = try? JSONDecoder().decode(NoticeResponse.self, from: data), let total = reponsesubdata.total {
                    if ( total >= 1 ){
                        if let _ = reponsesubdata.data?.first {
                           
                         //    alert = Alert(title: data.title,okMessage: "  \(data.content)")
                        }
                    }
                }
            }
            
        }

        task.resume()
    }
    
    public func reloadSubscribe() async {
        
        let userInfoUrl = URL(string: "\(UserManager.shared.baseURL())user/getSubscribe")!
        var request = URLRequest(url: userInfoUrl)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(UserManager.shared.getAutoData(), forHTTPHeaderField: "Authorization")
        
        withAnimation {
            islogined = true
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let err = error {
                    print(err.localizedDescription)
                    Task{
                        try await Task.sleep(nanoseconds:2_000_000_000)
                        await reloadSubscribe()
                    }
                    
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                
//                if let jsonString = String(data: data, encoding: .utf8) {
//                      print("Response data: \(jsonString)")
//                } 
                // Parse the user info response
                if let reponsesubdata = try? JSONDecoder().decode(SubscribeReponse.self, from: data), let subscript_json = reponsesubdata.data {
                    
//                    withAnimation {
//                        islogined = true
//                    }
                    print("服务器返回最新的地址："+subscript_json.subscribeURL + " \n本地AppStorage：" + UserManager.shared.getSuburlData())
                    
                    
                    var localProfile:ProfilePreview?
                    if profileList.count > 1 {
                        //直接删除全部节点
                        Task {
                            for (_, profile) in profileList.enumerated() {
                                do {
                                    _ = try await ProfileManager.delete(profile.origin)
                                } catch {
                                    print(error)
                                }
                            }
                            
                        }
                    }else{
                        if profileList.count == 1 {
                            localProfile = profileList.first
                        }else{
                            print("第一次准备存储subscribe 地址，首先检查是否付费")
                            // >>>
                            UserManager.shared.storeSuburlData(data: subscript_json.subscribeURL)
                            print("服务器返回最新的地址："+subscript_json.subscribeURL + " \n本地AppStorage：" + UserManager.shared.getSuburlData())
                            Task{
                                //通知更新 Profile
                                environments.profileUpdate.send()
                            }
                            
                            
                            
//                            Task{
//                                try await checkingProfileBackground(remoteURL: subscript_json.subscribeURL)
//                            }
                            
                            
                        }
                        
                    }
                    
                    if let local = localProfile , let remoteURL = local.remoteURL {
                        print("存在本地目前订阅的URL:  - > \(remoteURL) \n 服务器最新地址:\(subscript_json.subscribeURL)")
//                        Task{
//                            try await checkingProfileBackground(remoteURL: subscript_json.subscribeURL)
//                        }
                        //>>
                        UserManager.shared.storeSuburlData(data: subscript_json.subscribeURL)
                        
                        if remoteURL != subscript_json.subscribeURL{
                            //切换了用户，删掉之前的 profile 数据然后重新 下载
                            Task {
                                
                                do {
                                    _ = try await ProfileManager.delete(local.origin)
                                } catch {
                                    print(error)
                                }
                                
                                environments.profileUpdate.send()
                            }
                            print("Log: 切换了用户,清空本地订阅数据，然后重新更新订阅地址.")
                          // commandClient.connect()
                        }else{
                            //更新 profile
                            print("Log: 用户不变,可以考虑每次更新订阅地址.")
                          // commandClient.connect()
                            Task {
                                environments.openProfileGetSuccess.send()
                            }
                            /*Task {
                                do {
                                    _ = try await local.origin.updateRemoteProfile()
                                } catch {
                                    print(error)
                                }
                            }*/
                            
                        }
                        
                    }
                     
                }else{
                    
                    print("LOG: 节点接口JSON解析失败，请注意. \(String(describing: error?.localizedDescription)) ")
                    //DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        //Task{
                         //   await reloadSubscribe()
                        //}
                   // }
                    if UserManager.shared.getSuburlData().count > 5 {
//                        withAnimation {
//                            islogined = true
//                            
//                        }
                        //commandClient.connect()
                    }
                    //alert = Alert(errorMessage: "访问失败")
                }
            }
            
        }

        task.resume()
    }
    
    
    
    //检查订阅地址是否付费nonisolated
    private  func checkingProfileBackground( remoteURL: String) async throws {
        //let nextProfileID = try await ProfileManager.nextID()
        
      
        
                 
        let remoteContent = try HTTPClient().getString(remoteURL)
        
        print("HomeView remoteContent : \(remoteContent.count)  paymentURLKey:\(  paymentURLKey)")
        if(remoteContent.count < 3){
            await MainActor.run {
                //进入正常逻辑
                if (UserManager.shared.paymentURL().count > 3){
                    xufeiNotify = true
                    UserManager.shared.storeSuburlData(data:remoteURL)
                    // environments.openProfileGetSuccess.send()
                    environments.profileUpdate.send()
                    
                }else{
                    //如果没有续费的情况下，判断是否是 Apple review
                    xufeiNotify = false
                    environments.profileUpdate.send()
                }
            }
             
            
        }else{
            //存储到本地 DB
            UserManager.shared.storeSuburlData(data:remoteURL)
            await MainActor.run {
                  environments.profileUpdate.send()
            }
//            await MainActor.run {
//                environments.openProfileGetSuccess.send()
//            }
          
        }
    }
    
    @MainActor
    public func reloadNodes() async {
        loadingNodes = true
        
        let userInfoUrl = URL(string: "\(UserManager.shared.baseURL())user/server/fetch")!
        var request = URLRequest(url: userInfoUrl)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(UserManager.shared.getAutoData(), forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                loadingNodes = false
                if let error = error {
                    alert = Alert(error)
                    return
                }
                
                guard let data = data else {
                    return
                }

                // Parse the user info response
                if let nodes = try? JSONDecoder().decode(nodereponse.self, from: data) {
                    
                    if let sss = nodes.data{
                        
                        servers = sss
                    }
                }
            }
        }

        task.resume()
    }
    
    
    // MARK: - Networking Logic
    
    func getConfigCache() async
    {
        print("serverData: \(serverData)")
        print("lastFetchTime: \(lastFetchTime)")
        
//        let dictionary = UserDefaults.standard.dictionaryRepresentation()
//          dictionary.keys.forEach { key in
//              print("key: \(key) : \(String(describing: UserDefaults.standard.object(forKey: key)))")
//          }
            
        
        
        let datesss = Date(timeIntervalSince1970: lastFetchTime)

        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM dd YYYY HH:mm a"

        let dateString = dayTimePeriodFormatter.string(from: datesss)
        print( "上次getconfig请求的 时间： \(dateString)")
        
        
        let currentTime = Date()
        let timeIntervalSinceLastFetch = currentTime.timeIntervalSince1970//Double
        
        // 如果超过 10 分钟（600 秒），则从服务器获取最新数据
        if (timeIntervalSinceLastFetch - lastFetchTime) > 600  && lastFetchTime > 10  {
            //
            print("超过 10 分钟（600 秒），则从服务器获取最新数据")
            await getConfig()
        }else{
            if serverData.count > 10  && lastFetchTime > 10  {
                
                print("取getConfig 缓存data ")
                
                withAnimation {
                    islogined = true
                }
                
                isConfiging = false
                
                Task {
                    
                    environments.openProfileGetSuccess.send()
                    
                }
                
                await MainActor.run {
                    print("crispTokenData:"+UserManager.shared.crispTokenData())
                    CrispSDK.configure(websiteID: UserManager.shared.crispTokenData())
                }
                
                
                
            }else{
                await getConfig()
            }
           
        }
        
    }
 
    func getConfig()  async {
        
        isConfiging = true
        
        // 读取登录状态和用户信息
        let isLoggedIn = UserManager.shared.isUserLoggedIn()
        let userInfo = UserManager.shared.getUserInfo()
        let autoData = UserManager.shared.getAutoData()

        print("Logged in: \(isLoggedIn)")
        print("本地信息Email: \(userInfo.email), avator: \(userInfo.avator)")
        print("本地信息Auto Data: \(autoData)")
        
        
        
       // Parse the login response and get the authorization token
       struct configReponse: Codable {
           let baseURL, mainregisterURL,paymentURL,crisptoken: String
           let telegramurl, kefuurl, websiteURL,baseDYURL: String
           let message: String
           let code: Int
       }
         
        
        let loginUrl = URL(string: UserManager.shared.configURL)!
        var request = URLRequest(url: loginUrl)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "bid")
        request.addValue(UserManager.shared.appversion, forHTTPHeaderField: "appver")
        request.addValue(UIDevice.current.model, forHTTPHeaderField: "model")
        
        dump(request.allHTTPHeaderFields ?? [:] )
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                
                if let _ = error {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        Task{
                            await getConfig()
                        }
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        Task{
                            await getConfig()
                        }
                    }
                    return
                }
                
                if let jsonString = String(data: data, encoding: .utf8) {
                      print("Response data: \(jsonString)")
                        serverData = jsonString
                        lastFetchTime =  Date().timeIntervalSince1970
                    
                        print("更新缓存信息")
                  } else {
                      print("Failed to convert data to string.")
                  }
                
              
                if let jsonResponse = try? JSONDecoder().decode(configReponse.self, from: data){
                     
                    if jsonResponse.code == 1 {
                        //save data
                        UserManager.shared.storebaseURLData(data: jsonResponse.baseURL)
                        UserManager.shared.storemainregisterURLData(data: jsonResponse.mainregisterURL)
                        UserManager.shared.storepaymentURLData(data: jsonResponse.paymentURL)
                        UserManager.shared.storetelegramUrlData(data: jsonResponse.telegramurl)
                        UserManager.shared.storekefuUrlData(data: jsonResponse.kefuurl)
                        UserManager.shared.storewebsiteURLData(data: jsonResponse.websiteURL)
                        UserManager.shared.storeCrispTokenData(data: jsonResponse.crisptoken)
                        
                        CrispSDK.configure(websiteID: jsonResponse.crisptoken)
                        
                        baseDYURL = jsonResponse.baseDYURL
                        isConfiging = false
                        
                        
                        //获取订阅信息
                        //after 2s
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.2) {
                            Task{
                                await reloadSubscribe()
                                //获取配置通知
                                //await reloadnotice()
                            }
                        }                    
                    }
                }else{
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        Task{
                            await getConfig()
                        }
                    }
                }
            }
        
        }

        task.resume()
    }
    
    
    func from(_ data: Data) throws -> LibboxProfileContent {
        var error: NSError?
        let content = LibboxDecodeProfileContent(data, &error)
        if let error {
            throw error
        }
        return content!
    }
    
    // Bottom Sheet...
    @ViewBuilder
    func BottomSheet()->some View{
        if islogined {
            
            
            VStack(spacing: 0){
                
                // Current Server...
                HStack{
                    
                    VStack(alignment: .leading, spacing: 6) {
                        
                        Text("节点选择")
                            .font(.headline)
                        //Text(currentServer.name).font(.subheadline)
                        Text(currentNode).font(.subheadline)
                    }
                    
                    Spacer(minLength: 10)
                    
                    if changeServer && groups.count>0{ 
                        Button {
                            Task {
                                isUrlTesting = true
                                await doURLTest()
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) {
                                    isUrlTesting = false
                                }
                            }
                        } label: {
                            
                            Image(systemName: "bolt.fill")
                            if (isUrlTesting) {
                                ProgressView()
                                Text(" ").font(.callout)
                            }else{
                                
                                Text("测速").font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                            
                        }.disableWithOpacity(isUrlTesting)
                    }
                    
                    
                    // Change Server Button...
                    Button {
                        if !changeServer {
                            if groups.count > 0 {  }
                            
                            Task{
                                try await Task.sleep(nanoseconds: 1_000_000_000)
                                
                            //    commandClient.disconnect()
                                commandClient.connect()
                                
                            }
                            
                            
                        }
                        withAnimation{
                            changeServer.toggle()
                            if servers.isEmpty{
                                
                                if changeServer {
                                    Task{
                                    //    await reloadNodes()
                                    }
                                }
                            }
                            
                        }
                    } label: {
                        
                        Text(changeServer ? "收起" : "展开")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .frame(width: 110,height: 45)
                            .background(
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(.white.opacity(0.25),lineWidth: 2)
                            )
                            .foregroundColor(.white)
                    }
                    
                    
                }
                .frame(height: 50)
                .padding(.horizontal)
                
                Divider()
                    .padding(.top)
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack {
                        if loadingNodes {
                            ProgressView()
                            Text("节点数据加载中...")    //网络加载节点
                            Spacer().frame(height: 20)
                        }
                    }.padding()
                    
//                    GroupListView()
                    
                    ScrollView {
                        
                       VStack {
                            //groups首先查看是否第一次开启，直接本地读取列表
                            if groups.count > 0 {
                                ForEach(groups, id: \.newhashValue) { it in
                                    GroupView(it)
                                }
                            }else{
                                ForEach(groups_firsttime, id: \.newhashValue) { it in
                                    GroupView(it)
                                }
                            }
                            
                            /*if (groups_firsttime.count == 0 && groups_firsttime.count == 0 ) {
                                VStack {
                                    ProgressView()
                                    Spacer().frame(height: 20)
                                    Text("节点数据加载中...") //本地 json 加载节点
                                    
                                }.padding()
                            }*/
                            
                            
                        }.padding() //.background(Color.gray.opacity(0.1))
                        
                    }.padding().padding(.bottom,getSafeArea().bottom)
                    if (groups_firsttime.count == 0 && groups_firsttime.count == 0 ) {
                        fufeiNodes()
                    }
                    //GroupListView().padding().padding(.bottom,getSafeArea().bottom)
                    
                   
                }
                .opacity(changeServer ? 1 : 0)
            }
            .frame(maxWidth: .infinity)
            // Max Height...
            .frame(height: changeServer ? getRect().height/1.2 : getRect().height / 2.5,alignment: .top)
            .padding()
            .background(
                
                Color("BottomSheet")
                    .clipShape(CustomCorners(radius: 35, corners: [.topLeft,.topRight]))
            )
            // Safe Area wont show on previews...
            // showing only 50 pixels of height...
            .offset(y: changeServer ? 0 : (getRect().height / 2.5)-50) //(getRect().height / 2.5) - (20 + getSafeArea().bottom)
        }else{
            EmptyView()
        }
    }
      
    func fufeiNodes()->some View{
        
        
        VStack(alignment: .leading, spacing: 18) {
                        // Filtered servers...
                        // Not showing selected One...
            
                    ForEach(serverstixignfufeiTest) { server in
                        Button(action: {
                            withAnimation {
                                
                               changeServer.toggle()
                               //提醒付费
                            
                                if (paymentURLKey.count > 3){
                                    isSubscriptionActive.toggle()
                                }
                                                   
                           }
                        }, label: {
                            VStack(spacing: 4) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
    //                            Image(server.name)
    //                            .resizable()
    //                            .aspectRatio(contentMode: .fit)
    //                            .frame(width: 20, height: 20)

                                            Text(server.name)
                                                .font(.subheadline)
                                                .fontWeight(.semibold).foregroundStyle(.white)
                                        }

                                        Label {
                                            Text(server.isOnline == 1 ? "在线可用" : "不可用")

                                        } icon: {
                                            Image(systemName: server.isOnline == 1 ? "checkmark" : "xmark")
                                        }
                                        .foregroundColor(server.isOnline == 1 ?.green : .red)
                                        .font(.caption2)
                                    }

                                    Spacer(minLength: 10)
                                    
                                    Image(systemName: "lock.fill").foregroundColor(.red)
                                    
                                    
                                }
                                .frame(height: 50)
                                .padding(.horizontal)

                                Divider()
                            }
                        })
                        
                        }
                    }
                    .padding(.top, 25)
                    .padding(.bottom, getSafeArea().bottom)
        
    }
    
    private nonisolated func doURLTest() async {
        print("doURLTest: \(await urltestinggoGrouptag) ")
        do {
            if  await urltestinggoGrouptag.count > 0 {
                try  await LibboxNewStandaloneCommandClient()!.urlTest(urltestinggoGrouptag)
            }
            
        } catch {
            print("doURLTest: \(error)")
//            await MainActor.run {
//                alert = Alert(error)
//            }
        }
        
        
    }
    
    @ViewBuilder
    func Background()->some View{
        
//        VStack(alignment: .trailing, content: {
//            Spacer()
//            Text("Placeholder")
//            LottieView(animationFileName: "1d2a0fe5", loopMode: .loop)
//                .frame(width: 100 ,height: 100 )
//        })
        
        ZStack{
             BackgroundBg()
            
            
            // Little Planet and little stars....
            Image("mars")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 30, height: 30)
                .scaleEffect(getRect().height < 750 ? 0.8 : 1)
            // not using offset...
            // using postiton..
            // this will position the object using screen basis...
                .position(x: 50, y: getRect().height < 750 ? 200 : 220)
                .opacity(0.7)
            
            // Sample star points....
            let stars: [CGPoint] = [
            
                CGPoint(x: 15, y: 190),
                CGPoint(x: 25, y: 250),
                CGPoint(x: 20, y: 350),
                CGPoint(x: getRect().width - 30, y: 240),
            ]
            
            ForEach(stars,id: \.x){star in
                
                Circle()
                    .fill(.white.opacity(0.3))
                    .frame(width: 5, height: 5)
                    .position(star)
                    .offset(y: getRect().height < 750 ? -20 : 0)
            }
                        
             
       
        }
        .ignoresSafeArea()
    }
    
    
    private nonisolated func serviceReload() async throws {
        try LibboxNewStandaloneCommandClient()!.serviceReload()
    }

    private nonisolated func setSystemProxyEnabled(_ isEnabled: Bool) async {
        do {
            try LibboxNewStandaloneCommandClient()!.setSystemProxyEnabled(isEnabled)
            await SharedPreferences.systemProxyEnabled.set(isEnabled)
        } catch {
            await MainActor.run {
                alert = Alert(error)
            }
        }
    }
    
    
    func getTitle()->AttributedString{
        var str = AttributedString("sss")
        
        if let range = str.range(of: "Lite"){
            str[range].font = .system(size: 24, weight: .light)
        }
        
        if let range = str.range(of: "VPN"){
            str[range].font = .system(size: 24, weight: .black)
        }
        
        return str
    }
     
}

//struct HomeView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        HomeView()
//    }
//}/ Triangle shape for the small tail in the speech bubble
