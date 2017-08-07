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
  
  let app: App
  
  init(app: App) {
    self.app = app
    
    super.init()
    
    clLocationManager.delegate = self
    clLocationManager.distanceFilter = 200.0 // meters
    clLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
  }
  
  func askUserForPermission() {
    if CLLocationManager.authorizationStatus() == .notDetermined {
      clLocationManager.requestWhenInUseAuthorization()
    }
    /* else if CLLocationManager.authorizationStatus() == .denied {
      // FIXME: this message may not be necessary because at startup we always request authorization and
      // the App.Message.locationAuthorizationStatusUpdated should be invoked after that
      
      app.trigger(
        App.Message.warnUser,
        object: "The app cannot work properly withouth the permission to monitor its position while in use"
      )
    }*/
  }
  
  func startReceivingLocationUpdates(){
    clLocationManager.startUpdatingLocation()
  }
  
  func stopReceivingLocationsUpdate(){
    clLocationManager.stopUpdatingLocation()
  }
}

extension LocationManager: CLLocationManagerDelegate {
  func locationManager(
    _ manager: CLLocationManager,
    didChangeAuthorization status: CLAuthorizationStatus
    ) {
    app.trigger(App.Message.locationAuthorizationStatusUpdated, object: status)
  }
  
  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]
  ) {
    if let location = locations.last {
      lastLocation = location
      app.trigger(App.Message.newLocation, object: location)
    }
  }
}
