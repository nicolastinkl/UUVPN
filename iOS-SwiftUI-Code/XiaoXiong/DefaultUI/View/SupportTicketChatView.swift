//
//  SupportTicketChatView.swift
//  SFI
//
//  Created by Mac on 2024/10/20.
//

import Foundation

import SwiftUI
import Combine

// 1. 创建 KeyboardResponder 类
class KeyboardResponder: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0

    private var cancellable: AnyCancellable?
    
    
    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        /*
           cancellable = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
               .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification))
               .sink { [weak self] notification in
                   if let userInfo = notification.userInfo {
                       
                       if notification.name == UIResponder.keyboardWillShowNotification,
                          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                           self?.keyboardHeight = keyboardFrame.cgRectValue.height
                           print(" \(keyboardFrame.cgRectValue.height)" )
                       }
                       else {
                           print(" \(notification.name)" )
                          // self?.keyboardHeight = 0 // Reset height when keyboard hides
                       }
                   }
               }
         */
        
        
        
        /*
        let showPublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
        let hidePublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)

        showPublisher
            .merge(with: hidePublisher)
            .compactMap { notification in
                // 动画和键盘高度的处理
                guard let userInfo = notification.userInfo else { return 0 }
                let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
                return notification.name == UIResponder.keyboardWillShowNotification ? endFrame?.height ?? 0 : 0
            }
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &cancellableSet)
         */
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
                .map { $0.height }
                .sink { [weak self] height in
                    self?.keyboardHeight = height
                }
                .store(in: &cancellableSet)

            NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat.zero }
                .assign(to: &$keyboardHeight)
        
    }
}

struct SupportTicketChatView : View {
    
    @State var message = ""
    @State var imagePicker = false
    @State var imgData : Data = Data(count: 0)
    @State private var alert: Alert?
    var ticketID:Int 
    @State private var isMessageInputBarPresented = false
    
    
    //StateObject is the owner of the object....
    
    @State private var alltickets: [Message] = []
    @State private var isLoading = false
    @State private var isSendingMsg = false
    @State private var errorMessage: String?
    @State private var showAlert = false
    @State private var tickchatData: TicketChatReponseDataClass?

    @ObservedObject private var keyboard = KeyboardResponder()
    @StateObject var allMessages = Messages()
    
    @Environment(\.presentationMode) var presentationMode // 环境变量用于控制视图的呈现

    var body: some View{
        NavigationView(content: {
            
        
        VStack{
            
            Spacer()
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
                     if tickchatData?.status == 0 {
                         
                         
                         Button(action: {
                             alert = Alert(YesOrNOMessage: "确定关闭工单吗？", {
                                 Task{
                                      await closeThisTicket()
                                  }

                             })
                         }, label: {
                                 Text("关闭工单")
                                     .foregroundColor(.white)
                         
                         })
                        
                     }
                 }
                 Spacer()
                 VStack(spacing: 5){
                     
                     Text(tickchatData?.subject ?? "")
                         .fontWeight(.bold).lineLimit(1).frame(width: UIScreen.main.bounds.width*0.5)
                     
                     
                     if tickchatData?.status == 0 {
                         Text("待回复").font(.caption).foregroundColor(.red)
                     }else if tickchatData?.status == 1 {
                         Text("已关闭").font(.caption).foregroundColor(.gray)
                     }else if tickchatData?.status == 2 {
                         Text("已回复").font(.caption).foregroundColor(.green)
                     }
                     
                 }
                 .foregroundColor(.white)
                Spacer()
               
            }
            .padding(.all)
          
             
            VStack{
               
                // Displaying Message....
                
                if isLoading {
                      ProgressView()
                        .progressViewStyle(CircularProgressViewStyle()).tint(Color("Main"))
                        .padding().padding(.horizontal)
                    Spacer()
                    
                  }
                 
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .bold()
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center) // 确保多行文本居中
                        .padding(.horizontal)
                    Spacer()
                }
                

                
                if (alltickets.count > 0  ){
                    Spacer()
                    ScrollView(.vertical, showsIndicators: false, content: {
                        
                        ScrollViewReader{reader in
                            
                            VStack(spacing: 20){
                                  
                               
                                 ForEach(allMessages.messages){msg in
                                     
                                     // Chat Bubbles...
                                     Text("\(TimestampConverter.convertTimestampToDateString(msg.updatedAt))").font(.caption).foregroundColor(.black.opacity(0.8))
                                     ChatBubble(msg: msg)
                                     
                                 }
                                 // when ever a new data is inserted scroll to bottom...
                                 .onChange(of: allMessages.messages) { (value) in
                                     
                                     // scrolling only user message...
                                     
                                     //if value.last!.myMsg{}//
                                     withAnimation {
                                         reader.scrollTo(value.last?.id)
                                     }
                                 }
                                 
                            }
                            .padding([.horizontal,.bottom])
                            .padding(.top, 25)
                          
                        }
                    })
                    
                }
                 
                
            }
            // since bottom edge is ignored....
            .padding(.bottom,getSafeAreaInsets().bottom)// + keyboard.keyboardHeight
            .background((self.isLoading || errorMessage?.isEmpty==false)
                        ?
                        AnyView(Color.clear.clipped())
                        :
                            AnyView(Color.white.clipShape(RoundedShape())))
            
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.bottom)//
        //.background(Color("bg").ignoresSafeArea(.all, edges: .all))
//        .ignoresSafeArea(.all, edges: .top)
        .background(
            LinearGradient(colors: [
            
                Color("BG1"),
                Color("BG1"),
                Color("BG2"),
                Color("BG2"),
                
            ], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all, edges: .all))
        .onAppear(){
            Task{
                await getPlanList()
            }
        }
        })
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true) // 隐藏返回按钮
        .alertBinding($alert)
        .overlay(
            GeometryReader { geometry in
                VStack {
                    
                    Spacer() // Pus
                    Group {
                        if isMessageInputBarPresented {
                            MessageInputBar(isPresented: $isMessageInputBarPresented, message: $message,isSendingMsg: $isSendingMsg) { message in
                                print("发送消息: \(message)")
                                
                                Task{
                                    await SendMsg(msg:message)
                                }
                            }//.shadow(radius: 5)
                            //.padding(.bottom, keyboard.keyboardHeight) // Adjust for keyboard height
                            //.animation(.easeIn(duration: 0.3), value: keyboard.keyboardHeight) // Smooth transition
                            
                        }
                    }//.edgesIgnoringSafeArea(.bottom)
                }.frame(height: geometry.size.height * 1 / 2) // 只占据底部 1/2 的高度
                    .offset(y: geometry.size.height / 2) // 向下移动 1/2
            }
        )
        //.background(Color("Color").edgesIgnoringSafeArea(.top))
        // Full Screen Image Picker...
        .fullScreenCover(isPresented: self.$imagePicker, onDismiss: {
            
            // when ever image picker closes...
            // verifying if image is selected or cancelled...
            
            if self.imgData.count != 0{
                
                //allMessages.writeMessage(id: Date(), msg: "", photo: self.imgData, myMsg: true, profilePic: "p1")
            }
            
        }) {
            
            ImagePicker(imagePicker: self.$imagePicker, imgData: self.$imgData)
        }
    }
    
    
    struct MessageInputBar: View {
        @Binding var isPresented: Bool
        @Binding var message:String
        @Binding var isSendingMsg: Bool
        
        @ObservedObject private var keyboard = KeyboardResponder()
        var onSend: (String) -> Void

        var body: some View {
            VStack {
                Spacer()
               
                HStack(spacing: 1){
                    
                    HStack(spacing: 15){
                        
                        //TextField("输入消息", text: self.$message).foregroundColor(.black)
                        
                        CustomTF(sfIcon: "message", hint: "输入消息", hasDriveLine:false, value: $message).foregroundColor(.black)
                        
                        /* Button(action: {
                         
                         // toogling image picker...
                         
                         imagePicker.toggle()
                         
                         }, label: {
                         
                         Image(systemName: "paperclip.circle.fill")
                         .font(.system(size: 22))
                         .foregroundColor(.gray)
                         })*/
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .background(Color.black.opacity(0.06))
                    .clipShape(Capsule())
                    //.animation(.easeInOut(duration: 0.3)) // 添加动画效果
                    
                    // Send Button...
                    
                    // hiding view...
                    
                    if message != "" {
                        if isSendingMsg == false  {
                            Button(action: {
                                onSend(message)
                                // appeding message...
                                 
                                
                            }, label: {
                                
                                Image(systemName: "paperplane.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(Color("Main"))
                                // rotating the image...
                                    .rotationEffect(.init(degrees: 45))
                                // adjusting padding shape...
                                    .padding(.vertical,12)
                                    .padding(.leading,12)
                                    .padding(.trailing,17)
                                    .background(Color.black.opacity(0.07))
                                    .clipShape(Circle())
                            })
                        }else{
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle()).tint(Color("Main"))
                            
                            
                        }
                        
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
                .background(Color.white)

            }
        }
    }
    
   public func getPlanList() async {
     
       isLoading = true
       errorMessage = nil
 
       let userInfoUrl = URL(string: "\(UserManager.shared.baseURL())user/ticket/fetch?id=\(ticketID)")!
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
               if let Subscribe = try? JSONDecoder().decode(TicketChatReponse.self, from: data), let data = Subscribe.data {
                   tickchatData = data
                  if let message  = Subscribe.data?.message {
                      alltickets = message
                      alltickets.forEach { msg in
                          allMessages.messages.append(msg)
                      }
                      
                      if (alltickets.count > 0  && tickchatData?.status == 0){
                          isMessageInputBarPresented.toggle()
                      }
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
    
    
    
   public func closeThisTicket() async {
        

       
       let userInfoUrl = URL(string: "\(UserManager.shared.baseURL())user/ticket/close?id=\(ticketID)")!
       var request = URLRequest(url: userInfoUrl)
       request.httpMethod = "POST"
       request.addValue("application/json", forHTTPHeaderField: "Content-Type")
       request.addValue(UserManager.shared.getAutoData(), forHTTPHeaderField: "Authorization")

       let task = URLSession.shared.dataTask(with: request) { data, response, error in
           DispatchQueue.main.async {
             
               
               if let error = error {
                   self.alert = Alert(errorMessage: "数据请求失败： \(error.localizedDescription)")
                   return
               }
               
               guard let data = data else {
                   self.alert = Alert(errorMessage:  "数据请求失败")
                   return
               }
               // MARK: - TicketSendMsgReponse
               struct TicketSendMsgReponse: Codable {
                   let status, message: String?
                   
               }
              
 
               // Parse the user info response
               if let SendMsgReponse = try? JSONDecoder().decode(TicketSendMsgReponse.self, from: data), let message = SendMsgReponse.message {
                   
                  if let stutas  = SendMsgReponse.status , stutas == "success" {
                      self.alert = Alert(okMessage:  message)
                  }else{
                      self.alert = Alert(errorMessage:  message)
                       
                  }
                   
               }else{
                   self.alert =   Alert(errorMessage: "数据请求失败： JSON 解析错误")
               }
                
           }
       }

       task.resume()
   }
     
    
    
    public func SendMsg(msg: String) async {
       
       isSendingMsg = true
 
        if let encodedMsg = msg.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),let userInfoUrl = URL(string: "\(UserManager.shared.baseURL())user/ticket/reply?id=\(ticketID)&message=\(encodedMsg)"){
           
           
           var request = URLRequest(url: userInfoUrl)
           request.httpMethod = "POST"
           request.addValue("application/json", forHTTPHeaderField: "Content-Type")
           request.addValue(UserManager.shared.getAutoData(), forHTTPHeaderField: "Authorization")

           let task = URLSession.shared.dataTask(with: request) { data, response, error in
               DispatchQueue.main.async {
                   self.isSendingMsg = false
                   
                   if let error = error {
                       self.alert = Alert(errorMessage: "数据请求失败： \(error.localizedDescription)")
                       return
                   }
                   
                   guard let data = data else {
                       self.alert = Alert(errorMessage:  "数据请求失败")
                       return
                   }
                   // MARK: - TicketSendMsgReponse
                   struct TicketSendMsgReponse: Codable {
                       let status, message: String?
                       
                   }
                  


                   // Parse the user info response
                   if let SendMsgReponse = try? JSONDecoder().decode(TicketSendMsgReponse.self, from: data), let message = SendMsgReponse.message {
                       let randomInt = Int.random(in: 100...1000)
                      if let stutas  = SendMsgReponse.status , stutas == "success" {
                          withAnimation(.easeIn){
                              allMessages.writeMessage(idold: randomInt, msg: msg, myMsg: true, profilePic: "p1")
                          }
                          self.message = ""
                      }else{
                          self.alert = Alert(errorMessage:  message)
                           
                      }
                       
                   }else{
                       self.alert =   Alert(errorMessage: "数据请求失败： JSON 解析错误")
                   }
                   
                    
               }
           }

           task.resume()
       }
    }
     
    
}

// Chat Bubbles...

struct ChatBubble : View {

    var msg : Message
    
    var body: some View{
        
        // Automatic scroll To Bottom...
        // First Assigning Id To Each Row...
        
        HStack(alignment: .top,spacing: 10){
            
            if msg.isMe{
                
                // pushing msg to left...
                
                // minimum space ...
                
                // Modifying for Image...
                
                Spacer(minLength: 25)
                
                
                if msg.photo == nil{
                    
                    Text("\(msg.message)")
                        .padding(.all)
                        .background(Color.black.opacity(0.06))
                        .clipShape(BubbleArrow(myMsg: msg.isMe)).foregroundColor(.black)
                    
                
                    
                }
                else{
                    
                  //  Image(uiImage: UIImage(data: msg.photo!)!).resizable()
                    AsyncImage(url: URL(string: msg.photo ?? ""))
                        .frame(width: UIScreen.main.bounds.width - 150, height: 150)
                        .clipShape(BubbleArrow(myMsg: msg.isMe))
                }
                
                // profile Image...
                
                Image(msg.profilePic ?? "p1" )
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
            }
            
            else{
                
                // pushing msg to right...
                
                // profile Image...
                
                Image(msg.profilePic ?? "p2")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                
                if msg.photo == nil{
                    Text(msg.message)
                        .foregroundColor(.white)
                        .padding(.all)
                        .background(Color("Main"))
                        .clipShape(BubbleArrow(myMsg: msg.isMe))
                    

//                        Text("回复时间:\(TimestampConverter.convertTimestampToDateString(msg.updatedAt)).font(.caption).foregroundColor(.black.opacity(0.8))")

                }
                else{
                    
//                    Image(uiImage: UIImage(data: msg.photo!)!)
//                        .resizable()
                    AsyncImage(url: URL(string: msg.photo ?? ""))
                        .frame(width: UIScreen.main.bounds.width - 150, height: 150)
                        .clipShape(BubbleArrow(myMsg: msg.isMe))
                }
                
                
                Spacer(minLength: 25)
            }
        }
        .id(msg.id)
    }
}

// Bubble Arrow...

struct BubbleArrow : Shape {

    var myMsg : Bool
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: myMsg ?  [.topLeft,.bottomLeft,.bottomRight] : [.topRight,.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        
        return Path(path.cgPath)
    }
}

// Custom Rounded Shape...

struct RoundedShape : Shape {

    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 35, height: 35))
        
        return Path(path.cgPath)
    }
}

// Model Data For Message...

/*struct Message : Identifiable,Equatable{

    var id : Date
    var message : String
    var myMsg : Bool
    var profilePic : String
    var photo: Data?
    
}*/

class Messages : ObservableObject{
    
    @Published var messages : [Message] = []
    
    // sample data...
    
    init() {
        
        /*let strings = ["Hii","Hello !!!!","What's Up, What Are You Doing ???","Nothing Just Simply Enjoying Quarintine Holidays..You???","Same :))","Ohhhhh","What About Your Country ???","Very Very Bad...","Ok Be Safe","Bye....","Ok...."]
        
        //simple logic for two side messages
        
        for i in 0..<strings.count{
            
            messages.append(Message(id: Date(), message: strings[i], myMsg: i % 2 == 0 ? true : false, profilePic: i % 2 == 0 ? "p1" : "p2"))
        }*/
    }
    
    func writeMessage(idold: Int,msg: String,myMsg: Bool,profilePic: String?){
        messages.append(Message(idold: idold, ticketID: 0, isMe: myMsg, message: msg, photo: nil, createdAt: Int(Date().timeIntervalSince1970), updatedAt: Int(Date().timeIntervalSince1970), profilePic: profilePic))
        //messages.append(Message(id: id, message: msg, myMsg: myMsg, profilePic: profilePic, photo: photo))
    }
}

// Image Picker...

struct ImagePicker : UIViewControllerRepresentable {
    
    
    func makeCoordinator() -> Coordinator {
        
        return ImagePicker.Coordinator(parent1: self)
    }

    @Binding var imagePicker : Bool
    @Binding var imgData : Data
    
    func makeUIViewController(context: Context) -> UIImagePickerController{
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    class Coordinator : NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
        
        var parent : ImagePicker
        
        init(parent1 : ImagePicker) {
            
            parent = parent1
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            
            parent.imagePicker.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            let image = info[.originalImage] as! UIImage
            parent.imgData = image.jpegData(compressionQuality: 0.5)!
            parent.imagePicker.toggle()
        }
    }
}



