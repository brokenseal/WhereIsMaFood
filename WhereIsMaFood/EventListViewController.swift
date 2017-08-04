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
  //@IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var mainMap: MKMapView!
  
  var unsubscribers: [Unsubscriber] = []
  
  var dataSource: RestaurantsDataSource?
  var mapManager: MapManager?
  var locationManager: LocationManager?
  //var searchBarManager: SearchBarManager?
  
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
      print("new restaurant data!")
      self?.tableView.reloadData()
      self?.showRestaurantsOnMap()
    }
    unsubscribers.append(dataSourceUnsubscriber)
    
    // LISTENER: update map when a new location is received
    let newLocationUnsubscriber = App.main!.on(App.Message.newLocation) { [weak self] notification in
      // FIXME: bail out?
      guard
        let location = notification.object as? CLLocation,
        let mapManager = self?.mapManager,
        let dataSource = self?.dataSource
        else { return }
      
      print("new location: \(location)")
      
      mapManager.showRegion(
        latitude: location.coordinate.latitude,
        longitude: location.coordinate.longitude
      )
      dataSource.updateData(
        for: mapManager.getCurrentRegion(),
        searchQuery: ""
      )
    }
    unsubscribers.append(newLocationUnsubscriber)
    
    // LISTENER: show an alert when a warnUser message is received
    let alertsUnsubscriber = App.main!.on(App.Message.warnUser) { notification in
      // FIXME: bail out?
      guard let message = notification.object as? String else { return }
      
      print("new alert")
      let alert = AlertsManager.simple(
        title: "Warning!",
        message: message
      ).alert
      
      alert.show(using: self)
    }
    unsubscribers.append(alertsUnsubscriber)
    
    // LISTENER: on location authorization update
    let locationAuthorizationUnsubscriber = App.main!.on(
      App.Message.locationAuthorizationStatusUpdated
    ) { [weak self] notification in
      // FIXME: bail out?
      guard let status = notification.object as? CLAuthorizationStatus else { return }
      
      if status == CLAuthorizationStatus.denied {
        App.main!.trigger(
          App.Message.warnUser,
          object: "The app cannot work properly withouth the permission to monitor its position while in use"
        )
      } else if status == CLAuthorizationStatus.authorizedWhenInUse,
        let locationManager = self?.locationManager {
        locationManager.startReceivingLocationUpdates()
      }
    }
    unsubscribers.append(locationAuthorizationUnsubscriber)
  }
  
  func setupManagers() {
    dataSource = RestaurantsDataSource(
      app: App.main!,
      dataGenerator: MKRestaurantDataSetGenerator()
    )
    mapManager = MapManager(mainMap)
    locationManager = LocationManager(app: App.main!)
  }
  
  func tearDownUnsubscribers() {
    for unsubscriber in unsubscribers {
      unsubscriber()
    }
    unsubscribers = []
  }
  
  func showRestaurantsOnMap() {
    // FIXME: bail out?
    guard let dataSource = dataSource,
      let mapManager = mapManager
      else { return }
    
    let pinsData = dataSource.currentDataSet.map { restaurantData in
      return Pin(
        title: restaurantData.name,
        latitude: restaurantData.location.coordinate.latitude,
        longitude: restaurantData.location.coordinate.longitude,
        selected: restaurantData.selected
      )
    }
    mapManager.addPins(pinsData, removeOldPins: true)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    tearDownUnsubscribers()
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")!
    let restaurantData = dataSource!.currentDataSet[indexPath.row]
    cell.textLabel?.text = restaurantData.name
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    dataSource!.selectRestaurantData(at: indexPath.row)
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
