//
//  AppDelegate.swift
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/5/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        true
    }
}

/// Window scene delegate. Apps built with the iOS 27 SDK must adopt the scene life cycle;
/// the window and root view controller come from Main.storyboard via the Info.plist scene manifest.
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
}
