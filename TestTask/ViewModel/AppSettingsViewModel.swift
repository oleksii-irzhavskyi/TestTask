//
//  AppSettingsViewModel.swift
//  TestTask
//
//  Created by Oleksii Ilchavskyi on 04.02.2024.
//

// AppSettingsViewModel.swift
import Firebase
import FirebaseFirestore
import Combine

class AppSettingsViewModel: ObservableObject {
    @Published var isWebView: Bool?

    init() {
        fetchAppSettings()
    }

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
                    self.isWebView = appSettings.isWebView
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

