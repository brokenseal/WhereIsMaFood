//
//  NotificationsManager.swift
//  WhereIsMaFood
//
//  Created by Davide Callegari on 18/07/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import Foundation

/*
typealias NotificationListener = (_ payload: Any) -> Void
typealias Unsubscriber = () -> Void
enum AvailableNotifications {
  case warnUser
}

protocol NotificationsManagerProtocol {
  var listeners: [AvailableNotifications: [Int: NotificationListener]] { get set }
  func on(_ notification: AvailableNotifications, listener: @escaping NotificationListener) throws -> Unsubscriber
  func emit(_ notification: AvailableNotifications, payload: Any) throws
}


extension NotificationsManagerProtocol {
  func on(_ notification: AvailableNotifications, listener: @escaping NotificationListener) throws -> Unsubscriber {
    guard var listenersForNotification = listeners[notification] else {
      throw ErrorsManager.appError(nil)
    }

    guard let index = listenersForNotification.keys.sorted().last else {
      throw ErrorsManager.appError(nil)
    }

    if listenersForNotification[index] != nil {
      throw ErrorsManager.appError(nil)
    }

    listenersForNotification[index] = listener

    return {
      listenersForNotification.removeValue(forKey: index)
    }
  }

  func emit(_ notification: AvailableNotifications, payload: Any) throws {
    guard let listenersForNotification = listeners[notification] else {
      throw ErrorsManager.appError(nil)
    }

    listenersForNotification.values.forEach { listener in
      listener(payload)
    }
  }
}

final class NotificationsManager: NotificationsManagerProtocol {
  internal var listeners: [AvailableNotifications: [Int: NotificationListener]]

  init() {
    listeners = [
      AvailableNotifications.warnUser: [:]
    ]
  }
}
*/
