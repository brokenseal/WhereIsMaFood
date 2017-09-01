//
//  App.swift
//  WhereIsMaFood
//
//  Created by Davide Callegari on 17/07/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation


typealias Unsubscriber = () -> Void
typealias Listener = (Notification) -> Void


final class App {
  static var main: App!
  
  enum Message: String {
    // message sent if we want to warn the user about something, possibly showing an alert
    case warnUser
    // message sent when a new restaurant data set is received by the application
    case newRestaurantsDataSet
    // message sent when a new location is received by the core location framework
    case newLocation
    // message sent when the authorization status is updated
    case locationAuthorizationStatusUpdated
    // message sent when an annotation view on a map is selected
    case annotationViewSelected

    func getName() -> NSNotification.Name {
      return NSNotification.Name(rawValue: self.rawValue)
    }
    
    static let values = [warnUser, newRestaurantsDataSet, newLocation,
                         locationAuthorizationStatusUpdated, annotationViewSelected]
  }
  
  static func setup(
    notificationsManager: NotificationCenter = NotificationCenter.default
    ) throws -> App {
    if App.main != nil {
      throw ErrorsManager.appError("App already initialized and setup, App.setup can only be invoked once.")
    }
    
    let app = App(
      notificationsManager: notificationsManager
    )
    App.main = app
    return app
  }

  private let notificationsManager: NotificationCenter
  private var unsubscribers: [Unsubscriber] = []
  let locationManager: LocationManager
  let logger = Logger("MaFood")

  init(
    notificationsManager: NotificationCenter
  ) {
    self.notificationsManager = notificationsManager
    self.locationManager = LocationManager()
  }
  
  func onAny(_ listener: @escaping Listener) -> Unsubscriber {
    let unsubscribers = Message.values.map { message in
      on(message, listener: listener)
    }
    
    return {
      for unsubscriber in unsubscribers {
        unsubscriber()
      }
    }
  }

  func on(
    _ message: Message,
    listener: @escaping Listener
  ) -> Unsubscriber {
    let observer = self.notificationsManager.addObserver(
      forName: message.getName(),
      object: nil,
      queue: OperationQueue.main,
      using: listener
    )

    let unsubscriber = {
      self.notificationsManager.removeObserver(observer)
    }
    unsubscribers.append(unsubscriber)
    return unsubscriber
  }
  
  func once(
    _ message: Message,
    listener: @escaping Listener
  ) -> Unsubscriber {
    var count = 0
    
    let unsubscriber = on(message) { notification in
      if count == 0 {
        listener(notification)
      }
      count += 1
    }
    return unsubscriber
  }

  func trigger(_ message: Message, object: Any) {
    self.notificationsManager.post(
      name: message.getName(),
      object: object
    )
  }

  func tearDown(){
    removeAllListeners()
  }

  private func removeAllListeners(){
    for unsubscriber in unsubscribers {
      unsubscriber()
    }
  }
}

class ErrorsManager {
  static let domain = "com.brokenseal.AppError"

  static func appError(_ info: String = "Generic Error") -> NSError {
    return NSError(domain: domain, code: 0, userInfo: ["Info": info])
  }
}

