//
//  AppDelegate.swift
//  RandomUser
//
//  Created by Krzysztof Ignac on 16.01.2017.
//  Copyright © 2017 EXTENDED. All rights reserved.
//

import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let assembler = try! Assembler(assemblies: [ViewControllersAssembly(), ViewModelsAssembly(), ManagersAssembly()])
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        guard let rootViewController = assembler.resolver.resolve(MainViewController.self) else { return false }
        let navigationController = UINavigationController(rootViewController: rootViewController, customized: true)
        
        UIBarButtonItem.appearance().tintColor = CustomColor.navigationTint
        UINavigationBar.appearance().backgroundColor = CustomColor.dark
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.backgroundColor = UIColor.white
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()

        return true
        
    }

}

