//
//  ViewController.swift
//  WhereIsMaFood
//
//  Created by Davide Callegari on 13/07/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import UIKit
import MapKit


class RestaurantTableViewController: UITableViewController {
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var mainMap: MKMapView!
  
  var unsubscribers: [Unsubscriber] = []
  
  var dataSource: RestaurantsDataSource?
  var mapManager: MapManager?
  var locationManager: LocationManager?
  var searchBarManager: SearchBarManager?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupWiring()
    setupManagers()
    
    locationManager!.askUserForPermission()
  }
  
  func setupWiring() {
    // not sure what might happen here, let's lean on the safe side
    tearDownUnsubscribers()
    
    // LISTENER: update table data when new restaurants data is received
    let dataSourceUnsubscriber = App.main!.on(App.Message.newRestaurantsDataSet) { [weak self] _ in
      self?.tableView.reloadData()
    }
    unsubscribers.append(dataSourceUnsubscriber)
    
    // LISTENER: update map when a new location is received
    let newLocationUnsubscriber = App.main!.on(App.Message.newLocation) { [weak self] notification in
      // FIXME: bail out?
      guard
        let location = notification.object as? CLLocation,
        let mapManager = self?.mapManager
        else { return }
      
      print("new location: \(location)")
      mapManager.showRegion(
        latitude: location.coordinate.latitude,
        longitude: location.coordinate.longitude
      )
    }
    unsubscribers.append(newLocationUnsubscriber)
    
    // LISTENER: show an alert when a warnUser message is received
    let alertsUnsubscriber = App.main!.on(App.Message.warnUser) { notification in
      // FIXME: bail out?
      guard let message = notification.object as? String else { return }
      
      let alert = AlertsManager.simple(
        title: "Warning!",
        message: message
      ).alert
      
      alert.show(using: self)
    }
    unsubscribers.append(alertsUnsubscriber)
    
    // LISTENER: on location authorization update
    let locationAuthorizationUnsubscriber = App.main!.on(App.Message.locationAuthorizationStatusUpdated) { notification in
      // FIXME: bail out?
      if let status = notification.object as? CLAuthorizationStatus,
        status == CLAuthorizationStatus.denied {
        
        App.main!.trigger(
          App.Message.warnUser,
          object: "The app cannot work properly withouth the permission to monitor its position while in use"
        )
      }
    }
    unsubscribers.append(locationAuthorizationUnsubscriber)
  }
  
  func setupManagers() {
    dataSource = RestaurantsDataSource(app: App.main!)
    mapManager = MapManager(mainMap)
    locationManager = LocationManager(app: App.main!)
    
    searchBarManager = SearchBarManager(searchBar) { [weak self] searchText in
      self?.mapManager?.search(searchText) { error in
        if error != nil {
          App.main!.trigger(
            App.Message.warnUser,
            object: "Error while searching for restaurant"
          )
        }
      }
    }
  }
  
  func tearDownUnsubscribers() {
    for unsubscriber in unsubscribers {
      unsubscriber()
    }
    unsubscribers = []
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    tearDownUnsubscribers()
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")!
    let restaurantData = dataSource!.currentDataSet[indexPath.startIndex]
    cell.textLabel?.text = restaurantData.name
    return cell
  }

  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
    return dataSource!.currentDataSet.count
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
}
