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
  var dataSource: RestaurantsDataSource?
  
  func setup(dataSource: RestaurantsDataSource) {
    self.dataSource = dataSource
  }
  
  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return dataSource!.currentDataSet.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")! as! RestaurantTableCell
    let restaurantData = dataSource!.currentDataSet[indexPath.row]
    
    cell.setup(with: restaurantData)
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    dataSource!.selectRestaurantData(at: indexPath.row)
  }
  
  override func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    let restaurantData = dataSource!.currentDataSet[indexPath.row]
    return restaurantData.selected ? 120 : 60
  }
}
