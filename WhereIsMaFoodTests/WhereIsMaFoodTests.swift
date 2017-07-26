//
//  WhereIsMaFoodTests.swift
//  WhereIsMaFoodTests
//
//  Created by Davide Callegari on 21/07/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import XCTest
import Nimble
import Quick
@testable import WhereIsMaFood

class WhereIsMaFoodTests: QuickSpec {
  override func spec() {
    describe("App class") {
      it("acts as a notification router") {
        let app = App(notificationsManager: NotificationCenter.default)
        let unsubscriber = app.on(App.Message.warnUser) { notification in
          let expected = notification.object as! String
          expect(expected).to(equal("Squee!"))
        }

        app.trigger(App.Message.warnUser, object: "Squee!")
        unsubscriber()
      }

      it("removes all listeners on destroy") {
        let app = App(notificationsManager: NotificationCenter.default)
        let unsubscriber = app.on(App.Message.warnUser) { _ in
          expect(false).to(equal(true))
        }
        app.destroy()
        app.trigger(App.Message.warnUser, object: "Squee!")
      }
    }
  }
}
