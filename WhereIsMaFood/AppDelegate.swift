//
//  AppDelegate.swift
//  WhereIsMaFood
//
//  Created by Davide Callegari on 13/07/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  var app: App?
  
  static func getIntroductionStoryboard() -> UIStoryboard {
    return UIStoryboard(name: "Introduction", bundle: nil)
  }
  static func getMainStoryboard() -> UIStoryboard {
    return UIStoryboard(name: "Main", bundle: nil)
  }
  static func getDebugStoryboard() -> UIStoryboard {
    return UIStoryboard(name: "Debug", bundle: nil)
  }
  static func hasUserSeenIntroduction() -> Bool {
    return UserDefaults.standard.object(forKey: "HasSeenIntroduction") as? Bool ?? false
  }
  static func setUserHasSeenIntroduction(){
    UserDefaults.standard.set(true, forKey: "HasSeenIntroduction")
  }

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    do {
      try app = App.setup()
    } catch {
      fatalError("Unable to instantiate App")
    }
    
    startDebugger()
    setupCorrectStoryBoard(debug: false)
    
    return true
  }
  
  func startDebugger(){
    let _ = app!.onAny() { notification in
      self.app!.logger.log(notification)
    }
  }
  
  func setupCorrectStoryBoard(debug: Bool){
    var storyBoardToUse: UIStoryboard
    
    if debug {
      storyBoardToUse = AppDelegate.getDebugStoryboard()
    } else if !AppDelegate.hasUserSeenIntroduction(){
      storyBoardToUse = AppDelegate.getIntroductionStoryboard()
      AppDelegate.setUserHasSeenIntroduction()
    } else {
      storyBoardToUse = AppDelegate.getMainStoryboard()
    }
    
    let rootController = storyBoardToUse.instantiateInitialViewController()
    
    self.window?.rootViewController = rootController
    self.window?.makeKeyAndVisible()
 
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
      // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
}
