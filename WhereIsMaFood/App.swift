//
//  App.swift
//  WhereIsMaFood
//
//  Created by Davide Callegari on 17/07/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import UIKit
import Foundation


final class App {
  static var main: App?
  
  private class notifications {
    static let showAlert = Notification(name: Notification.Name(rawValue: "showAlert"))
  }
  
  static func setup(notificationManager: NotificationsManager, alertsManager: AlertsManager) throws -> App {
    if App.main != nil {
      throw NSError(domain: "com.brokenseal.AppError", code: 0, userInfo: nil)
    }
    
    let app = App(notificationManager: notificationManager, alertsManager: alertsManager)
    App.main = app
    return app
  }
  
  let alertsManager: AlertsManager
  let notificationManager: NotificationCenter
  
  private init(notificationManager: NotificationCenter, alertsManager: AlertsManager) {
    self.alertsManager = alertsManager
    self.notificationManager = notificationManager
  }
  
  private func setupWiring(viewController: UIViewController) {
    // self.notificationManager.removeObserver(<#T##observer: Any##Any#>)
    /*self.notificationManager.addObserver(
      forName: notifications.showAlert.name,
      object: nil, queue: nil) { notification in
        print(notification.name)
      }*/
  }
}
