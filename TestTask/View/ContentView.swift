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
    // State variable to store whether to show WebView or GameView
    @State private var isWebView: Bool?

    var body: some View {
        // Use a Group to conditionally display either WebView or GameView based on isWebView
        Group {
            if let isWebView = isWebView {
                // If isWebView is true, display WebView with Google URL, else display GameView
                if isWebView {
                    WebView(urlString: "https://www.google.com/")
                } else {
                    GameView()
                }
            } else {
                // If isWebView is not yet determined, display a loading message and fetch app settings
                Text("Loading...")
                    .onAppear {
                        fetchAppSettings()
                    }
            }
        }
    }

    // Function to fetch app settings from Firestore
    func fetchAppSettings() {
        // Initialize Firestore
        let db = Firestore.firestore()

        // Fetch document with ID "lMiBVhVvwzfJP7VFSOBV" from collection "isWebView"
        db.collection("isWebView").document("lMiBVhVvwzfJP7VFSOBV").getDocument { document, error in
            if let error = error {
                // Handle error if fetching document fails
                print("Error getting document: \(error)")
            } else if let document = document, document.exists {
                do {
                    // Try to decode retrieved data into AppSettings model
                    let appSettings = try document.data(as: AppSettings.self)
                    // Update isWebView based on the retrieved value
                    isWebView = appSettings.isWebView
                } catch {
                    // Handle error if decoding fails
                    print("Error decoding appSettings: \(error)")
                }
            } else {
                // Handle case where document does not exist
                print("Document does not exist")
            }
        }
    }
}
