//
//  ViewController.swift
//  WhereIsMaFood
//
//  Created by Davide Callegari on 13/07/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import UIKit


class EventTableViewController: UITableViewController {
  @IBOutlet weak var eventTableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView = eventTableView
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")!
    cell.textLabel?.text = "AAAAAAAAA"
    return cell
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
}
