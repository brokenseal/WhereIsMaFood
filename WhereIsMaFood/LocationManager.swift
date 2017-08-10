//
//  LocationManager.swift
//  WhereIsMaFood
//
//  Created by Davide Callegari on 28/07/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import MapKit
import Foundation
import CoreLocation


class LocationManager: NSObject {
  private let clLocationManager = CLLocationManager()
  var lastLocation: CLLocation?
  
  override init() {
    super.init()
    
    clLocationManager.delegate = self
    clLocationManager.distanceFilter = 200.0 // update every # meters
    clLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
  }
  
  func initiate() {
    handle(authorizationStatus: CLLocationManager.authorizationStatus())
  }
  
  func startReceivingLocationUpdates(){
    clLocationManager.startUpdatingLocation()
  }
  
  func stopReceivingLocationsUpdate(){
    clLocationManager.stopUpdatingLocation()
  }
  
  func handle(authorizationStatus: CLAuthorizationStatus) {
    switch authorizationStatus {
    case .denied:
      App.main.trigger(
        App.Message.warnUser,
        object: "The app cannot work properly withouth the permission to monitor its position while in use"
      )
    case .authorizedWhenInUse:
      startReceivingLocationUpdates()
    default:
      return
    }
  }
}

extension LocationManager: CLLocationManagerDelegate {
  func locationManager(
    _ manager: CLLocationManager,
    didChangeAuthorization status: CLAuthorizationStatus
  ) {
    handle(authorizationStatus: status)
    App.main.trigger(App.Message.locationAuthorizationStatusUpdated, object: status)
  }
  
  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]
  ) {
    if let location = locations.last {
      lastLocation = location
      App.main.trigger(App.Message.newLocation, object: location)
    }
  }
}
