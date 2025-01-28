//
//  ChatViewControllerWrapper.swift
//  SFI
//
//  Created by Mac on 2024/10/24.
//

import SwiftUI
import UIKit
import Crisp

// Step 2: Create a SwiftUI wrapper for ChatViewController
struct ChatViewControllerWrapper: UIViewControllerRepresentable {
    
    // Initialize any properties needed to pass to ChatViewController
    typealias UIViewControllerType = ChatViewController
    
    func makeUIViewController(context: Context) -> ChatViewController {
        // Return the ChatViewController
        let chatViewController = ChatViewController()
        return chatViewController
    }
    
    func updateUIViewController(_ uiViewController: ChatViewController, context: Context) {
        // Update the view controller when needed
    }
}
