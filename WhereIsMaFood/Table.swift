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
  var wrapper: RestaurantTableWrapper {
    return self.parent as! RestaurantTableWrapper
  }
  var dataSource: RestaurantsDataSource?

  func setup(
    dataSource: RestaurantsDataSource
  ) {
    self.dataSource = dataSource
  }
  
  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    guard let dataSource = dataSource else { return 0 }
    return dataSource.currentDataSet.count
  }
  
  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let dataSource = self.dataSource!
    let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")! as! RestaurantTableCell
    
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
    dataSource!.selectRestaurantData(at: indexPath.row)
  }
  
  override func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    let restaurantData = dataSource!.currentDataSet[indexPath.row]
    return restaurantData.selected ? 120 : 60
  }

  @IBAction func showDirections(_ sender: Any) {
    guard let (from, to) = wrapper.mapManager?.getLocationsForDirections() else { return }
    
    let directionsMenu = UIAlertController(
      title: "Get directions",
      message: "",
      preferredStyle: .actionSheet
    )
    func dismissAlert(){
      directionsMenu.dismiss(animated: true, completion: nil)
    }
    
    let chooseAppleMaps = UIAlertAction(title: "With Apple Maps", style: .default) { _ in
      MapManager.ExternalMapDirectionsProvider.apple.getDirections(from: from, to: to)
      dismissAlert()
    }
    directionsMenu.addAction(chooseAppleMaps)
    let chooseGoogleMaps = UIAlertAction(title: "With Google Maps", style: .default) { _ in
      MapManager.ExternalMapDirectionsProvider.google.getDirections(from: from, to: to)
      dismissAlert()
    }
    directionsMenu.addAction(chooseGoogleMaps)
    let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
      dismissAlert()
    }
    directionsMenu.addAction(cancel)
    present(
      directionsMenu,
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
      if let currentData = dataSource!.getSelectedRestaurantData(),
        let url = currentData.url {
        viewController.setup(url: url)
      }
    }
  }
}
