//
//  HTMLTextView.swift
//  SFI
//
//  Created by Mac on 2024/10/27.
//

import Foundation
import SwiftUI
import UIKit

struct HTMLTextView: UIViewRepresentable {
    let htmlString: String

    func makeUIView(context: Context) -> UITextView {
         let textView = UITextView()
         textView.isEditable = false
         textView.isScrollEnabled = true
         textView.backgroundColor = .clear
         return textView
     }

     func updateUIView(_ uiView: UITextView, context: Context) {
         guard let data = htmlString.data(using: .utf8) else { return }
         do {
             
             let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
             uiView.attributedText = attributedString
         } catch {
             print("Error loading HTML: \(error)")
         }
     }
}
