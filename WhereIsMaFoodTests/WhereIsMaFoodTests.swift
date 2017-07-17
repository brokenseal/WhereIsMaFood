//
//  WhereIsMaFoodTests.swift
//  WhereIsMaFoodTests
//
//  Created by Davide Callegari on 13/07/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import XCTest
@testable import WhereIsMaFood

class WhereIsMaFoodTests: XCTestCase {
  var app: App!
  
  override func setUp() {
    super.setUp()
    
    app = App(notificationManager: NotificationsManager, alertsManager: AlertsManager())
  }
    
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
    
    app = nil
  }

  func testApp() {
    app.notificationsManager.on(app.notificationManager.warnUser) { notification in
      XCTAssert(notification)
    }
    app.alertsManager.warn(title: "Test", message: "Ok?? Ok!!")
  }
}
