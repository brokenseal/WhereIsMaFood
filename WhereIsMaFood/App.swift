//
//  App.swift
//  WhereIsMaFood
//
//  Created by Davide Callegari on 17/07/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import UIKit
import Foundation


typealias Unsubscriber = () -> Void
typealias Listener = (Notification) -> Void


final class App {
  static var main: App?

  enum Message: String {
    case warnUser

    func getName() -> NSNotification.Name {
      return NSNotification.Name(rawValue: self.rawValue)
    }
  }


  static func setup(notificationsManager: NotificationCenter) throws -> App {
    if App.main != nil {
      throw ErrorsManager.appError(nil)
    }
    
    let app = App(notificationsManager: NotificationCenter.default)
    App.main = app
    return app
  }

  private let notificationsManager: NotificationCenter

  init(notificationsManager: NotificationCenter) {
    self.notificationsManager = notificationsManager
  }

  func on(_ message: Message, listener: @escaping Listener) -> Unsubscriber {
    let observer = self.notificationsManager.addObserver(
      forName: message.getName(),
      object: nil,
      queue: OperationQueue.main,
      using: listener
    )

    return {
      self.notificationsManager.removeObserver(observer)
    }
  }

  func trigger(_ message: Message, object: Any) {
    self.notificationsManager.post(
      name: message.getName(),
      object: object
    )
  }
}

class ErrorsManager {
  static let domain = "com.brokenseal.AppError"

  static func appError(_ userInfo: [String: String]?) -> NSError {
    return NSError(domain: domain, code: 0, userInfo: userInfo)
  }
}
