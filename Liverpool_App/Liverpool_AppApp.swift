//
//  Liverpool_AppApp.swift
//  Liverpool_App
//
//  Created by Gil casimiro on 03/10/24.
//

import SwiftUI
import Firebase
import FirebaseAppCheck
class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct Liverpool_AppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @StateObject var authViewModel = LoginViewModel()
    var body: some Scene {
        WindowGroup {
            if authViewModel.user != nil {
                MainView()
                    .environmentObject(authViewModel)
            } else {
                LoginView()  
                    .environmentObject(authViewModel)
            }
        }
    }
}
