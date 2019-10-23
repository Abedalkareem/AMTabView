//
//  AppDelegate.swift
//  AMTabView
//
//  Created by Abedalkareem on 10/23/2019.
//  Copyright (c) 2019 Abedalkareem. All rights reserved.
//

import UIKit
import AMTabView

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

    // Customize the colors
    AMTabView.settings.ballColor = #colorLiteral(red: 0.7529411765, green: 0.4470588235, blue: 0.5960784314, alpha: 1)
    AMTabView.settings.tabColor = #colorLiteral(red: 0.9960784314, green: 0.9960784314, blue: 0.9960784314, alpha: 1)
    AMTabView.settings.selectedTabTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    AMTabView.settings.unSelectedTabTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

    // Chnage the animation duration
    AMTabView.settings.animationDuration = 1

    return true
  }

  func applicationWillResignActive(_ application: UIApplication) { }

  func applicationDidEnterBackground(_ application: UIApplication) { }

  func applicationWillEnterForeground(_ application: UIApplication) { }

  func applicationDidBecomeActive(_ application: UIApplication) { }

  func applicationWillTerminate(_ application: UIApplication) { }

}

