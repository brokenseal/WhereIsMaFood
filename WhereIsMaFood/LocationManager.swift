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
  
  init(
    distanceFilter: Double = 200.0,
    accuracy: CLLocationAccuracy = kCLLocationAccuracyNearestTenMeters
  ) {
    super.init()
    
    clLocationManager.delegate = self
    clLocationManager.distanceFilter = distanceFilter // update every # meters
    clLocationManager.desiredAccuracy = accuracy
  }
  
  func initiate() {
    handleAuthorizationStatus(CLLocationManager.authorizationStatus())
  }
  
  func startReceivingLocationUpdates(){
    clLocationManager.startUpdatingLocation()
  }
  
  func stopReceivingLocationsUpdate(){
    clLocationManager.stopUpdatingLocation()
  }
  
  func handleAuthorizationStatus(_ authorizationStatus: CLAuthorizationStatus) {
    switch authorizationStatus {
    case .notDetermined:
      clLocationManager.requestWhenInUseAuthorization()
    case .denied:
      App.main.trigger(
        App.Message.warnUser,
        object: "The app cannot work properly withouth the permission to monitor its position while in use"
      )
    case .authorizedWhenInUse, .authorizedAlways:
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
    handleAuthorizationStatus(status)
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
