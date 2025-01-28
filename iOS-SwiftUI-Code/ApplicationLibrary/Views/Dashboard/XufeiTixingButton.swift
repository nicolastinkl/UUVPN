//
//  XufeiTixingButton.swift
//  ApplicationLibrary
//
//  Created by Mac on 2024/10/26.
//

import Foundation

//
import Library
import SwiftUI

@MainActor
public struct XufeiTixingButton: View {
    
    private let callback: () async -> Void
    public init(_ callback: @escaping (() async -> Void)) {
        self.callback = callback
    }

    public var body: some View {
        parsePowerButton()
    }

     
    
    @ViewBuilder
    func parsePowerButton()->some View{
        
        Button {
            
            Task {
                await callback()
            }
        } label: {

            ZStack{
                
                ZStack{
                    //
//                    LottieView(animationFileName: "1d2a0fe5" , loopMode: .loop)
                    LottieView(animationFileName: "8dfa14a6" , loopMode: .loop).scaleEffect(0.2)
                    Text("开启服务").bold().font(.title2).foregroundStyle(Color.white)
                    //LottieView(animationFileName: "8dfa14a6" , loopMode: .loop).scaleEffect(0.5)
                    
                }

            }
            // Max Frame...
            .frame(width: 190,height: 190)

        }.padding()
        

    }
     
}
