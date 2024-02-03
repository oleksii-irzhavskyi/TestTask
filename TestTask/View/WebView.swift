//
//  WebView.swift
//  TestTask
//
//  Created by Oleksii Ilchavskyi on 03.02.2024.
//

import SwiftUI
import WebKit

// UIViewRepresentable for displaying a WebView in SwiftUI
struct WebView: UIViewRepresentable {
    // The URL string to load in the WebView
    let urlString: String
    
    // Creates and returns the initial WKWebView
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    // Updates the WKWebView when needed
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Check if the urlString can be converted to a valid URL
        if let url = URL(string: urlString) {
            // Create a URLRequest and load it into the WKWebView
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}
