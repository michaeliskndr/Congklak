//
//  AppDelegate.swift
//  Congklak
//
//  Created by Michael Iskandar on 18/01/24.
//

import UIKit
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
    
        registerDependencies()
        initializeRoot()
        return true
    }
}

extension AppDelegate {
    
    func initializeRoot() {
        let factory = InjectorManager.shared.resolve(CongklakViewFactory.self)
        
        guard let rootVC = factory?.makeCongklakHomeViewController() else { return }
        
        let navigationController = UINavigationController(rootViewController: rootVC)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
                                
    func registerDependencies() {
        InjectorManager.shared.register(CongklakRouting.self) { _ in
            CongklakRouter()
        }
        
        InjectorManager.shared.register(CongklakViewFactory.self) { _ in
            CongklakFactory()
        }
    }
}

