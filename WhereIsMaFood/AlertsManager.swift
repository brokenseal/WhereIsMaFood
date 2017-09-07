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
  let alert: UIAlertController

  init(title: String, message: String, style: UIAlertControllerStyle?) {
    self.alert = UIAlertController(
      title: title,
      message: message,
      preferredStyle: style ?? UIAlertControllerStyle.alert
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
  
  func show(using viewController: UIViewController) {
    viewController.present(alert, animated: true, completion: nil)
  }
}

enum AlertsManager {
  case simple(title: String, message: String)
  case withCancel(title: String, message: String)

  var alert: Alert {
    switch self {
    case .simple(let title, let message):
      return getAlertWith(title: title, message: message)

    case .withCancel(let title, let message):
      let alert = getAlertWith(title: title, message: message)
      alert.addButton("Cancel", style: UIAlertActionStyle.cancel)
      return alert
    }
  }

  private func getAlertWith(title: String, message: String) -> Alert {
    let alert = Alert(title: title, message: message, style: nil)
    alert.addButton("Ok", style: nil)
    return alert
  }
  
  func show(using viewController: UIViewController){
    alert.show(using: viewController)
  }
}
