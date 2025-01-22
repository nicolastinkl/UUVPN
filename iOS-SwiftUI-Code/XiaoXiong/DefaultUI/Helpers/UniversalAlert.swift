//
//  UniversalAlert.swift
//  CustomUniversalAlert
//
//  Created by Balaji Venkatesh on 18/09/23.
//

import SwiftUI

/// Alert Config
struct AlertConfig {
    fileprivate var enableBackgroundBlur: Bool = true
    fileprivate var disableOutsideTap: Bool = true
    fileprivate var transitionType: TransitionType = .slide
    fileprivate var slideEdge: Edge = .bottom
    fileprivate var show: Bool = false
    fileprivate var showView: Bool = false
    
    init(enableBackgroundBlur: Bool = true, disableOutsideTap: Bool = true, transitionType: TransitionType = .slide, slideEdge: Edge = .bottom) {
        self.enableBackgroundBlur = enableBackgroundBlur
        self.disableOutsideTap = disableOutsideTap
        self.transitionType = transitionType
        self.slideEdge = slideEdge
    }
    
    /// TransitionType
    enum TransitionType {
        case slide
        case opacity
    }
    
    /// Alert Present/Dismiss Methods
    mutating
    func present() {
        show = true
    }
    
    mutating
    func dismiss() {
        show = false
    }
}
  
 

fileprivate struct AlertView<Content: View>: View {
    @Binding var config: AlertConfig
    /// View Tag
    var tag: Int
    @ViewBuilder var content: () -> Content
    /// View Properties
    @State private var showView: Bool = false
    var body: some View {
        GeometryReader(content: { geometry in
            if showView && config.transitionType == .slide {
                content()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.move(edge: config.slideEdge))
            } else {
                content()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .opacity(showView ? 1 : 0)
            }
        })
        .background {
            ZStack {
                if config.enableBackgroundBlur {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                } else {
                    Rectangle()
                        .fill(.primary.opacity(0.25))
                }
            }
            .ignoresSafeArea()
            .contentShape(.rect)
            .onTapGesture {
                if !config.disableOutsideTap {
                    config.dismiss()
                }
            }
            .opacity(showView ? 1 : 0)
        }
        .onAppear(perform: {
            config.showView = true
        })
//        .onChange(of: config.showView) { oldValue, newValue in
//            withAnimation(.smooth(duration: 0.35, extraBounce: 0)) {
//                showView = newValue
//            }
//        }
    }
}
