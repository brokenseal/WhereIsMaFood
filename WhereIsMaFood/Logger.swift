//
//  Logger.swift
//  WhereIsMaFood
//
//  Created by Davide Callegari on 28/08/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import Foundation

class Logger: NSObject {
  @objc dynamic var logged: [Notification] = []
  let name: String
  
  init(_ name: String) {
    self.name = name
  }
  
  func log(_ notification: Notification){
    logged.append(notification)
  }
  
  func empty() {
    logged = []
  }
}
