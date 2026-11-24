//
//  MYSettings.swift
//  MyEssentialOilRemedies
//
//  Created by burnsoft on 6/23/16.
//  Copyright © 2016 burnsoft. All rights reserved.
//

import Foundation

/// App wide constants and settings.
enum MYSettings {
    /// Database Name
    static let dbName = "MNRSS.db"
    /// Expected Database Version for the current version of this app
    static let dbVersion = 1.2
    static let fullVersionName = "My NRA Rifle Match Score Sheet"
    /// Enable the Debug Functions for additional information during run time.
    /// The Objective-C version keyed this off `NDEBUG`, which no build configuration defines,
    /// so debug messages were always on; that behavior is kept here.
    static let buggerMe = true
    /// Number of matches allowed in the Lite version
    static let liteLimit = 10

    /// Check to see if the application is the full or lite version, if it is the lite version it will restrict the number of items that can be entered into the application.
    /// - Returns: True if it is the Lite version and False if it is the full version
    static func isLiteVersion() -> Bool {
        let targetName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        return targetName != fullVersionName
    }
}
