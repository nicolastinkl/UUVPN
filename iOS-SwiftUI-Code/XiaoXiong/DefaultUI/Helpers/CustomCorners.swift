//
//  CustomCorners.swift
//  CustomCorners
//
//  Created by Balaji on 12/09/21.
//

import SwiftUI

struct CustomCorners: Shape {
    
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}

func getSafeAreaInsets() -> UIEdgeInsets {
    let windowScene = UIApplication.shared.connectedScenes
        .filter({ $0.activationState == .foregroundActive })
        .map({ $0 as? UIWindowScene })
        .compactMap({ $0 })
        .first

    guard let keyWindow = windowScene?.windows.filter({ $0.isKeyWindow }).first else {
        return .zero
    }
    
    return keyWindow.safeAreaInsets
}


func getRect() -> CGRect {
    return UIScreen.main.bounds
}
@ViewBuilder
func BackgroundBg()->some View{
     
     
    
    ZStack{
        
        LinearGradient(colors: [
        
            Color("BG1"),
            Color("BG1"),
            Color("BG2"),
            Color("BG2"),
            
        ], startPoint: .top, endPoint: .bottom)
        
        
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
         
        Spacer()
         
    }
    .ignoresSafeArea()
}
