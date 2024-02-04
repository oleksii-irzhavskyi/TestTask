//
//  ContentView.swift
//  TestTask
//
//  Created by Oleksii Ilchavskyi on 03.02.2024.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct ContentView: View {
    @StateObject private var viewModel = AppSettingsViewModel()

    var body: some View {
        // Use a Group to conditionally display either WebView or GameView based on isWebView
        Group {
            if let isWebView = viewModel.isWebView {
                if isWebView {
                    WebView(urlString: "https://www.google.com/")
                } else {
                    GameView()
                }
            } else {
                Text("Loading...")
            }
        }
    }
}
