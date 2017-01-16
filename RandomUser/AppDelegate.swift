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
        
        let navigationVC = UINavigationController(rootViewController: assembler.resolver.resolve(MainViewController.self)!)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.backgroundColor = UIColor.white
        window!.rootViewController = navigationVC
        window!.makeKeyAndVisible()
        
        return true
        
    }

}

