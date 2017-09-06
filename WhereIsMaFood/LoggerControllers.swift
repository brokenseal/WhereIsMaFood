//
//  LoggerViewController.swift
//  WhereIsMaFood
//
//  Created by Davide Callegari on 28/08/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import UIKit
import Foundation

class LoggerTable: UITableViewController {
  var loggerDetail: LoggerDetail!
  
  override func viewWillAppear(_ animated: Bool) {
    self.tableView.reloadData()
    
    super.viewWillAppear(animated)
  }
  
  func setup(loggerDetail: LoggerDetail){
    self.loggerDetail = loggerDetail
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let notification = App.main.logger.logged[indexPath.row]
    let splitViewController = getTopViewController() as! LoggerSplitViewController
    
    loggerDetail.setup(notification: notification)
    splitViewController.showDetailViewController(loggerDetail, sender: nil)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return App.main.logger.logged.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell") as! LoggerCell
    let name = App.main.logger.logged[indexPath.row].name.rawValue
    let details = App.main.logger.logged[indexPath.row].object!
    
    cell.setup(name: name, details: details)
    
    return cell
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
}

class LoggerDetail: UIViewController {
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var details: UILabel!
  
  var notification: Notification!
  
  func setup(notification: Notification) {
    self.notification = notification
    name.text = notification.name.rawValue
    details.text = "\(notification.object ?? "UNKNOWN")"
  }
}

class LoggerSplitViewController: UISplitViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    let navigationController = viewControllers[0] as! UINavigationController
    let loggerTable = navigationController.viewControllers[0] as! LoggerTable
    let loggerDetail = viewControllers[1] as! LoggerDetail
    loggerTable.setup(loggerDetail: loggerDetail)
  }
}

class LoggerCell: UITableViewCell {
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var details: UILabel!
  
  func setup(name: String, details: Any){
    self.name.text = name
    self.details.text = "\(details)"
  }
}
