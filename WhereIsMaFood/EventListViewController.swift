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
  //@IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var mainMap: MKMapView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  var unsubscribers: [Unsubscriber] = []
  
  var dataSource: RestaurantsDataSource?
  var mapManager: MapManager?
  var locationManager: LocationManager?
  var searchBarManager: SearchBarManager?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  func setup(){
    setupRefreshController()
    setupWiring()
    setupManagers()
    dataSource = RestaurantsDataSource(
      app: App.main!,
      dataGenerator: MKRestaurantDataSetGenerator()
    )
    
    locationManager!.askUserForPermission()
  }
  
  func setupRefreshController(){
    refreshControl = UIRefreshControl()
    refreshControl!.addTarget(
      self,
      action: #selector(RestaurantTableViewController.refreshTable),
      for: .valueChanged
    )
  }
  
  func refreshTable(){
    // FIXME: bail out?
    guard let mapManager = mapManager,
      let dataSource = dataSource,
      let searchBarManager = searchBarManager else { return }
    
    dataSource.updateData(
      for: mapManager.getCurrentRegion(),
      searchQuery: searchBarManager.lastSearchQuery
    )
  }
  
  func setupWiring() {
    // not sure what might happen here, let's lean on the safe side
    tearDownUnsubscribers()
    
    // LISTENER: update table data when new restaurants data is received
    let dataSourceUnsubscriber = App.main!.on(
      App.Message.newRestaurantsDataSet
    ) { [weak self] _ in
      self?.tableView.reloadData()
      self?.showRestaurantsOnMap()
      self?.refreshControl?.endRefreshing()
    }
    unsubscribers.append(dataSourceUnsubscriber)
    
    // LISTENER: update map when a new location is received, but only once, at the beginning
    let newLocationUnsubscriber = App.main!.once(
      App.Message.newLocation
    ) { [weak self] notification in
      // FIXME: bail out?
      guard let location = notification.object as? CLLocation,
        let mapManager = self?.mapManager else { return }
      
      mapManager.showRegion(
        latitude: location.coordinate.latitude,
        longitude: location.coordinate.longitude
      )
      self?.refreshTable()
    }
    unsubscribers.append(newLocationUnsubscriber)
    
    // LISTENER: show an alert when a warnUser message is received
    let alertsUnsubscriber = App.main!.on(App.Message.warnUser) { notification in
      // FIXME: bail out?
      guard let message = notification.object as? String else { return }
      
      AlertsManager.simple(
        title: "Warning!",
        message: message
      ).alert.show(using: self)
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
    
    let viewAnnotationUnsubscriber = App.main!.on(
      App.Message.annotationViewSelected
    ) { [weak self] notification in
      // FIXME: bail out?
      guard let annotationView = notification.object as? MKAnnotationView,
        let mapManager = self?.mapManager,
        let annotation = annotationView.annotation else { return }
      
      let pin = mapManager.getPinFromAnnotation(
        annotation: annotation
      )
      
      print("pin!!")

      guard let this = self,
        let dataSource = this.dataSource,
        let daPin = pin,
        let restaurantData = daPin.rawData as? RestaurantData
        else { return }
      
      print("pin!!: \(daPin)")
      dataSource.select(restaurantData)
    }
    unsubscribers.append(viewAnnotationUnsubscriber)
  }

  func setupManagers() {
    mapManager = MapManager(mainMap)
    locationManager = LocationManager(app: App.main!)
    searchBarManager = SearchBarManager(searchBar) { [weak self] _ in
      self?.refreshTable()
    }
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
        rawData: restaurantData,
        selected: restaurantData.selected
      )
    }
    mapManager.addPins(pinsData)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    tearDownUnsubscribers()
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")!
    let restaurantData = dataSource!.currentDataSet[indexPath.row]
    cell.textLabel?.text = restaurantData.name
    
    if restaurantData.selected == true {
      cell.backgroundColor = UIColor.brown
    } else {
      cell.backgroundColor = UIColor.white
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    dataSource!.selectRestaurantData(at: indexPath.row)
  }

  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return dataSource!.currentDataSet.count
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
}
