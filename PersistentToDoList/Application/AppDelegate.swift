//
//  AppDelegate.swift
//  PersistentToDoList
//
//  Created by Djinsolobzik on 24.03.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        let mainVC = MainToDoListViewController()

        let navigationController = UINavigationController(rootViewController: mainVC)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}

