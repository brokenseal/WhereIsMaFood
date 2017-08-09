//
//  RestaurantTableViewController
//  WhereIsMaFood
//
//  Created by Davide Callegari on 13/07/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import UIKit
import MapKit


class RestaurantTableViewController: UITableViewController {
  var dataSource: RestaurantsDataSource!
  var mapManager: MapManager!

  func setup(
    dataSource: RestaurantsDataSource,
    mapManager: MapManager
  ) {
    self.dataSource = dataSource
    self.mapManager = mapManager
  }
  
  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return dataSource.currentDataSet.count
  }
  
  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: "DefaultCell"
    )! as! RestaurantTableCell
    let restaurantData = dataSource.currentDataSet[indexPath.row]
    
    cell.setup(with: restaurantData)
    
    if restaurantData.selected == true {
      tableView.scrollToRow(
        at: indexPath,
        at: UITableViewScrollPosition.top,
        animated: true
      )
    }
    
    return cell
  }
  
  override func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    dataSource.selectRestaurantData(at: indexPath.row)
  }
  
  override func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    let restaurantData = dataSource.currentDataSet[indexPath.row]
    return restaurantData.selected ? 120 : 60
  }
  
  @IBAction func showDirections(_ sender: Any) {
    guard let (from, to) = mapManager.getLocationsForDirections() else { return }
    
    let alertViewController = UIAlertController(
      title: "",
      message: "",
      preferredStyle: .actionSheet
    )
    func dismissAlert(){
      alertViewController.dismiss(animated: true, completion: nil)
    }
    
    let chooseAppleMaps = UIAlertAction(title: "", style: .default) { _ in
      MapManager.ExternalMapDirectionsProvider.apple.getDirections(from: from, to: to)
      self.mapManager.showDirectionsUsing(
        provider: .apple,
        from: from,
        to: to
      )
      dismissAlert()
    }
    alertViewController.addAction(chooseAppleMaps)
    let chooseGoogleMaps = UIAlertAction(title: "", style: .default) { _ in
      MapManager.ExternalMapDirectionsProvider.google.getDirections(from: from, to: to)
      self.mapManager.showDirectionsUsing(
        provider: .apple,
        from: from,
        to: to
      )
      dismissAlert()
    }
    alertViewController.addAction(chooseGoogleMaps)
    let cancel = UIAlertAction(title: "", style: .cancel) { _ in
      dismissAlert()
    }
    alertViewController.addAction(cancel)
    present(
      alertViewController,
      animated: true,
      completion: nil
    )
  }
  
  override func prepare(
    for segue: UIStoryboardSegue,
    sender: Any?
  ) {
    if segue.identifier == "showWebsite" {
      let viewController = segue.destination as! ShowWebsiteModalViewController
      
      // FIXME: bail out?
      if let currentData = dataSource.getSelectedRestaurantData(),
        let url = currentData.url {
        viewController.setup(url: url)
      }
    }
  }
}
