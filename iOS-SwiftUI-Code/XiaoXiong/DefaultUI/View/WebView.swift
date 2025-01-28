//
//  WebView.swift
//  SFI
//
//  Created by Mac on 2024/10/12.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {

    var url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}


struct WebViewContent: UIViewRepresentable {

    var content: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
//        let request = URLRequest(url: url)
//        webView.load(request)
        webView.loadHTMLString(content, baseURL: nil)
    }
}
