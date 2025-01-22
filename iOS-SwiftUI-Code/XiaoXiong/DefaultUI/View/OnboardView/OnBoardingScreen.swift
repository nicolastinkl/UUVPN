//
//  OnBoardingScreen.swift
//  AnimatedOnBoardingScreen
//
//  Created by Balaji on 17/12/22.
//

import SwiftUI
import Lottie

struct OnBoardingScreen: View {
    // MARK: OnBoarding Slides Model Data
    @State var onboardingItems: [OnboardingItem] = [ 
    ]
    // MARK: Current Slide Index
    @State var currentIndex: Int = 0
    var body: some View {
        GeometryReader{
            let size = $0.size
            
            HStack(spacing: 0){
                ForEach($onboardingItems) { $item in
                    let isLastSlide = (currentIndex == onboardingItems.count - 1)
                    VStack{
                        // MARK: Top Nav Bar
                        HStack{
                            Button(action: {
                                if currentIndex > 0{
                                    currentIndex -= 1
                                    playAnimation()
                                }
                            }, label: {
                                Image(systemName: "arrow.backward")
                            })
                            .opacity(currentIndex > 0 ? 1 : 0)
                            
                            Spacer(minLength: 0)
                            
                            Button("跳过"){
                                currentIndex = onboardingItems.count - 1
                                playAnimation()
                            }
                            .opacity(isLastSlide ? 0 : 1)
                        }
                        .animation(.easeInOut, value: currentIndex)
                        .tint(Color("Green"))
                        //.fontWeight(.bold)
                        
                        // MARK: Movable Slides
                        VStack(spacing: 15){
                            let offset = -CGFloat(currentIndex) * size.width
                            // MARK: Resizable Lottie View
                            ResizableLottieView(onboardingItem: $item)
                                .frame(height: size.width)
                                .onAppear {
                                    // MARK: Intially Playing First Slide Animation
                                    if currentIndex == indexOf(item){
                                        item.lottieView.play(toProgress: 0.7)
                                    }
                                }
                                .offset(x: offset)
                                .animation(.easeInOut(duration: 0.5), value: currentIndex)
                            
                            Text(item.title)
                                .font(.title.bold())
                                .offset(x: offset)
                                .animation(.easeInOut(duration: 0.5).delay(0.1), value: currentIndex)
                            
                            Text(item.subTitle)
                                .font(.system(size: 14))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal,15)
                                .foregroundColor(.gray)
                                .offset(x: offset)
                                .animation(.easeInOut(duration: 0.5).delay(0.2), value: currentIndex)
                        }
                        
                        Spacer(minLength: 0)
                        
                        // MARK: Next / Login Button
                        VStack(spacing: 15){
                            Button {
                                if currentIndex < onboardingItems.count - 1{
                                    // MARK: Pausing Previous Animation
                                    let currentProgress = onboardingItems[currentIndex].lottieView.currentProgress
                                    onboardingItems[currentIndex].lottieView.currentProgress = (currentProgress == 0 ? 0.7 : currentProgress)
                                    currentIndex += 1
                                    // MARK: Playing Next Animation from Start
                                    playAnimation()
                                }
                                if isLastSlide {
                                    withAnimation(){
                                        
                                    }
                                }
                            } label: {
                                
                                
                                Text(isLastSlide ? "登录" : "下一步")
                                    .foregroundColor(.white)
                                    .padding(.vertical, isLastSlide ? 13 : 12)
                                     
                                    .background(
                                        Capsule()
                                            .fill(Color("Green"))
                                    )
                                    .frame(maxWidth: .infinity) // 保证按钮宽度填充父视图
                                    .padding(.horizontal, isLastSlide ? 50 : 100)
                                    .contentShape(Rectangle()) // 扩大点击区域
                                
                            }

                            
                           /* Button(isLastSlide ? "登录" : "下一步"){
                               
                            }
                                .foregroundColor(.white)
                                .padding(.vertical,isLastSlide ? 13 : 12)
                                .frame(maxWidth: .infinity)
                                .background {
                                    Capsule()
                                        .fill(Color("Green"))
                                }
                                .padding(.horizontal,isLastSlide ? 50 : 100)
                                */
                            
                            if currentIndex == onboardingItems.count - 1{
                                
                                HStack{
//                                    Button("Terms of Service"){}
                                        
//                                    Button("Privacy Policy"){}
                                }
                                .font(.caption2)
                                //.underline(true, color: .primary)
                                .offset(y: 5)
                            }
                        }
                    }
                    .animation(.easeInOut, value: isLastSlide)
                    .padding(15)
                    .frame(width: size.width, height: size.height)
                }
            }
            .frame(width: size.width * CGFloat(onboardingItems.count),alignment: .leading)
        }
    }
    
    func playAnimation(){
        onboardingItems[currentIndex].lottieView.currentProgress = 0
        onboardingItems[currentIndex].lottieView.play(toProgress: 0.7)
    }
    
    // MARK: Retreving Index of the Item in the Array
    func indexOf(_ item: OnboardingItem)->Int{
        if let index = onboardingItems.firstIndex(of: item){
            return index
        }
        return 0
    }
}

//struct OnBoardingScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
