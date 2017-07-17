//
//  SimpleAlert.swift
//  WhereIsMaFood
//
//  Created by Davide Callegari on 13/07/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import UIKit
import Foundation

class SimpleAlert {
    private let alert: UIAlertController

    static func `default`(title: String, message: String) -> SimpleAlert {
        let alert = SimpleAlert(title: title, message: message)
        return alert
    }

    init(title: String, message: String) {
        self.alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
    }
    func show(using viewController: UIViewController) {
        viewController.present(alert, animated: true, completion: nil)
    }
}
