//
//  Utils.swift
//  WhereIsMaFood
//
//  Created by Davide Callegari on 20/07/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import UIKit
import Foundation


var root: UIViewController? {
  get {
    return UIApplication.shared.delegate?.window??.rootViewController
  }
}

func getTopViewController(from viewController: UIViewController? = root) -> UIViewController? {
  if let tabBarViewController = viewController as? UITabBarController {
    return getTopViewController(from: tabBarViewController.selectedViewController)
  } else if let navigationController = viewController as? UINavigationController {
    return getTopViewController(from: navigationController.visibleViewController)
  } else if let presentedViewController = viewController?.presentedViewController {
    return getTopViewController(from: presentedViewController)
  } else {
    return viewController
  }
}
