//
//  AppDelegate.swift
//  GLSubModule
//
//  Created by Kathy on 2021/8/18.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GLCoreDataManager.shared.dbName = "GLSubModule"
        return true
    }

}

