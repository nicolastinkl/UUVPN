//
//  ResizableLottieView.swift
//  AnimatedOnBoardingScreen
//
//  Created by zues on 17/12/22.
//

import SwiftUI

// MARK: Resizable Lottie View Without Background
struct ResizableLottieView: UIViewRepresentable{
    @Binding var onboardingItem: OnboardingItem
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        setupLottieView(view)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    func setupLottieView(_ to: UIView){
        let lottieView = onboardingItem.lottieView
        lottieView.loopMode = .loop
        lottieView.backgroundColor = .clear
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        
        // MARK: Applying Constraints
        let constraints = [
            lottieView.widthAnchor.constraint(equalTo: to.widthAnchor),
            lottieView.heightAnchor.constraint(equalTo: to.heightAnchor),
        ]
        to.addSubview(lottieView)
        to.addConstraints(constraints)
    }
}
