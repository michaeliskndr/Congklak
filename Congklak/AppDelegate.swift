//
//  AppDelegate.swift
//  Congklak
//
//  Created by Michael Iskandar on 18/01/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = initializeRoot()
        window?.makeKeyAndVisible()
        return true
    }
    
    func initializeRoot() -> UIViewController {
        let router: CongklakRouting = CongklakRouter()
        return router.makeCongklakViewController()
    }
}

