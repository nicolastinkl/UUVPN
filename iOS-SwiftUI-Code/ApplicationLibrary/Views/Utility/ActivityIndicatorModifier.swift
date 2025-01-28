//
//  ActivityIndicatorModifier.swift
//  ApplicationLibrary
//
//  Created by Mac on 2024/10/23.
//

import Foundation
import  SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

public struct ActivityIndicatorModifier: AnimatableModifier {
    var isLoading: Bool

    public  init(isLoading: Bool, color: Color = .primary, lineWidth: CGFloat = 3) {
        self.isLoading = isLoading
    }

    var animatableData: Bool {
        get { isLoading }
        set { isLoading = newValue }
    }

    public func body(content: Content) -> some View {
        ZStack {
            if isLoading {
                GeometryReader { geometry in
                    ZStack(alignment: .center) {
                        content
                            .disabled(self.isLoading)
                            .blur(radius: self.isLoading ? 3 : 0)

                        VStack {
//                            Text("配置中...").font(.subheadline)
                            ActivityIndicator(isAnimating: .constant(true), style: .large)
                        }
                        .frame(width: geometry.size.width / 2,
                               height: geometry.size.height / 5)
                        .background(Color.secondary.colorInvert())
                        .foregroundColor(Color.primary)
                        .cornerRadius(20)
                        .opacity(self.isLoading ? 1 : 0)
                        .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
                    }
                }
            } else {
                content
            }
        }
    }
}
