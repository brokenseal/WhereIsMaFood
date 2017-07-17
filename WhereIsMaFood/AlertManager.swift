//
//  SimpleAlert.swift
//  WhereIsMaFood
//
//  Created by Davide Callegari on 13/07/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import UIKit
import Foundation


class Alert {
  private let alert: UIAlertController

  init(title: String, message: String) {
    self.alert = UIAlertController(
      title: title,
      message: message,
      preferredStyle: UIAlertControllerStyle.alert
    )
  }
  
  func addButton(_ buttonTitle: String, style: UIAlertActionStyle?) {
    let action = UIAlertAction(
      title: buttonTitle,
      style: style ?? UIAlertActionStyle.default,
      handler: nil
    )
    alert.addAction(action)
  }
  
  func show(using viewController: UIViewController, completion: @escaping () -> Void) {
    viewController.present(alert, animated: true, completion: completion)
  }
}

class AlertsManager {
  func simple(title: String, message: String) -> Alert {
    let alert = Alert(title: title, message: message)
    alert.addButton("Ok", style: nil)
    return alert
  }
  
  func simpleWithCancel(title: String, message: String) -> Alert {
    let alert = simple(title: title, message: message)
    alert.addButton("Cancel", style: UIAlertActionStyle.cancel)
    return alert
  }
}
