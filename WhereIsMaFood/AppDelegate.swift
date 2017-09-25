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
      startDebugger()
    } else if !AppDelegate.hasUserSeenIntroduction(){
      storyBoardToUse = AppDelegate.getIntroductionStoryboard()
    } else {
      storyBoardToUse = AppDelegate.getMainStoryboard()
    }
    
    let rootController = storyBoardToUse.instantiateInitialViewController()
    
    self.window?.rootViewController = rootController
    self.window?.makeKeyAndVisible()
 
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    App.main?.trigger(App.Message.appEnteredForeground)
  }
}
