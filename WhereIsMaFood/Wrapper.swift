//
//  RestaurantTableWrapper.swift
//  WhereIsMaFood
//
//  Created by Davide Callegari on 07/08/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import UIKit
import MapKit


class RestaurantTableWrapper: UIViewController {
  @IBOutlet weak var mainMap: MKMapView!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var restaurantTableContainer: UIView!
  
  var unsubscribers: [Unsubscriber] = []
  var dataSource: RestaurantsDataSource?
  var mapManager: MapManager?
  var searchBarManager: SearchBarManager?
  var restaurantTableViewController: RestaurantTableViewController {
    return self.childViewControllers[0] as! RestaurantTableViewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
    start()
  }
  
  func setup() {
    dataSource = RestaurantsDataSource(
      app: App.main,
      dataGenerator: MKRestaurantDataSetGenerator()
    )
    mapManager = MapManager(self.mainMap!)
    searchBarManager = SearchBarManager(self.searchBar) { [weak self] _ in
      self?.refreshTable()
    }
    
    setupRefreshController()
    setupListeners()
    
    restaurantTableViewController.setup(
      dataSource: dataSource!
    )
  }
  
  func start(){
    App.main.locationManager.initiate()
  }
  
  func setupRefreshController(){
    let refreshControl = UIRefreshControl()
    restaurantTableViewController.refreshControl = refreshControl
    refreshControl.addTarget(
      self,
      action: #selector(RestaurantTableWrapper.refreshTable),
      for: .valueChanged
    )
  }
  
  func refreshTable(){
    guard let dataSource = dataSource,
      let mapManager = mapManager,
      let searchBarManager = searchBarManager else { return }
    
    dataSource.updateData(
      for: mapManager.getCurrentRegion(),
      searchQuery: searchBarManager.lastSearchQuery
    )
  }
  
  func tearDownUnsubscribers() {
    for unsubscriber in unsubscribers {
      unsubscriber()
    }
    unsubscribers = []
  }
  
  func showRestaurantsOnMap() {
    guard let dataSource = dataSource,
      let mapManager = mapManager else { return }
    
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
  
  func setupListeners() {
    // not sure what might happen here, let's lean on the safe side
    tearDownUnsubscribers()
    
    // LISTENER: update table data when new restaurants data is received
    let dataSourceUnsubscriber = App.main.on(
      App.Message.newRestaurantsDataSet
    ) { [weak self] _ in
      self?.restaurantTableViewController.tableView.reloadData()
      self?.showRestaurantsOnMap()
      self?.restaurantTableViewController.refreshControl?.endRefreshing()
    }
    unsubscribers.append(dataSourceUnsubscriber)
    
    // LISTENER: update map when a new location is received, but only once, at the beginning
    let newLocationUnsubscriberOnce = App.main.once(
      App.Message.newLocation
    ) { [weak self] notification in
      self?.refreshTable()
      
      guard let location = notification.object as? CLLocation,
        let mapManager = self?.mapManager else { return }
      
      mapManager.showRegion(
        latitude: location.coordinate.latitude,
        longitude: location.coordinate.longitude
      )
    }
    unsubscribers.append(newLocationUnsubscriberOnce)
    
    // LISTENER: update map when a new location is received, but only once, at the beginning
    let newLocationUnsubscriber = App.main.on(
      App.Message.newLocation
    ) { [weak self] notification in
      guard let location = notification.object as? CLLocation,
        let mapManager = self?.mapManager else { return }
      
      // TODO/FIXME: not sure about this one, the problem that I'm trying to fix is that the map region
      // is not updated along with the location, at the same time, but rather later
      mapManager.showRegion(
        latitude: location.coordinate.latitude,
        longitude: location.coordinate.longitude
      )
    }
    unsubscribers.append(newLocationUnsubscriber)

    // LISTENER: show an alert when a warnUser message is received
    let alertsUnsubscriber = App.main.on(
      App.Message.warnUser
    ) { [weak self] notification in
      // FIXME: bail out?
      guard let _ = self, let message = notification.object as? String else { return }
      
      AlertsManager.simple(
        title: "Warning!",
        message: message
      ).alert.show(using: self)
    }
    unsubscribers.append(alertsUnsubscriber)
    
    let viewAnnotationUnsubscriber = App.main.on(
      App.Message.annotationViewSelected
    ) { [weak self] notification in
      // FIXME: bail out?
      guard let annotationView = notification.object as? MKAnnotationView,
        let mapManager = self?.mapManager,
        let annotation = annotationView.annotation else { return }
      
      let pin = mapManager.getPinFromAnnotation(
        annotation: annotation
      )
      
      guard let daPin = pin,
        let restaurantData = daPin.rawData as? RestaurantData,
        let dataSource = self?.dataSource
        else { return }
      
      dataSource.select(restaurantData)
    }
    unsubscribers.append(viewAnnotationUnsubscriber)
  }
}
