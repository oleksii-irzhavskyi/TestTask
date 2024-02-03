//
//  TestTaskApp.swift
//  TestTask
//
//  Created by Oleksii Ilchavskyi on 03.02.2024.
//

import SwiftUI
import Firebase

@main
struct TestTaskApp: App {
    init() {
        // Initialize Firebase when the app starts
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
