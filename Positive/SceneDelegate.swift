//
//  SceneDelegate.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/05/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let userDefaults = UserDefaults.standard
        let firstLunchKey = "firstLunchKey"
        let firstLunch = [firstLunchKey: true]
        userDefaults.register(defaults: firstLunch)
        guard let _ = (scene as? UIWindowScene) else { return }
        let windows = UIWindow(windowScene: scene as! UIWindowScene)
//        self.window = windows
        windows.makeKeyAndVisible()
        self.window = windows
        let tutorial: UIStoryboard = UIStoryboard(name: "Tutorial", bundle: nil)
        let main: UIStoryboard = UIStoryboard(name: "MainStory", bundle: nil)
        if userDefaults.bool(forKey: "firstLunchKey") {
//            userDefaults.set(false, forKey: firstLunchKey)
            let vc = tutorial.instantiateViewController(withIdentifier: "PagingView")
            window!.rootViewController = vc
        } else {
            let vc = main.instantiateViewController(withIdentifier: "tab")
            window!.rootViewController = vc
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

