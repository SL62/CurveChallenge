//
//  AppDelegate.swift
//  curve-challenge
//
//  Created by Saul Liang on 16/03/2018.
//  Copyright © 2018 SL. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		// Override appearance
		UINavigationBar.appearance().barTintColor = .purple500
		UIBarButtonItem.appearance().tintColor = .white
		UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
		UIApplication.shared.statusBarStyle = .lightContent
		return true
	}
}

