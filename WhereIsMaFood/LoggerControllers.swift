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
  override func viewWillAppear(_ animated: Bool) {
    self.tableView.reloadData()
    
    super.viewWillAppear(animated)
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

class LoggerCell: UITableViewCell {
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var details: UILabel!
  
  func setup(name: String, details: Any){
    self.name.text = name
    self.details.text = "\(details)"
  }
}
