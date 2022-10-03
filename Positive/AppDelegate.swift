//
//  AppDelegate.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/05/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//         Override point for customization after application launch.
        let userDefaults = UserDefaults.standard
        let firstLunchKey = "firstLunchKey"
        let firstLunch = [firstLunchKey: true]
        userDefaults.register(defaults: firstLunch)
        FirebaseApp.configure()
        try? Auth.auth().useUserAccessGroup("7Y5RBD24LU.com.kiyono.Positive")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

