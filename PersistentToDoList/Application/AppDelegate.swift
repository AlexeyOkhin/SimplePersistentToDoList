//
//  AppDelegate.swift
//  PersistentToDoList
//
//  Created by Djinsolobzik on 24.03.2023.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)


        let mainVC = CategoryViewController()

        let navigationController = UINavigationController(rootViewController: mainVC)

        if #available(iOS 15, *) {
            // Navigation Bar background color
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemCyan

            // setup title font color
            let titleAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.black]
            appearance.titleTextAttributes = titleAttribute

            navigationController.navigationBar.standardAppearance = appearance
            navigationController.navigationBar.scrollEdgeAppearance = appearance
        }

        do {
            let _ = try Realm()
        } catch {
            print(error)
        }

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}

