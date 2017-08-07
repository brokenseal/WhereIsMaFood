//
//  MapManager.swift
//  WhereIsMaFood
//
//  Created by Davide Callegari on 13/07/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import Foundation
import MapKit


struct Pin {
  let title: String
  let latitude: Double
  let longitude: Double
  let rawData: Any?
  var selected: Bool
}

class MapManager: NSObject {
  private let map:MKMapView
  private var managedPins: [(Pin, MKAnnotation)] = []

  var regionRadius: Double

  init(
    _ map: MKMapView,
    regionRadius: Double = 1000.0
  ){
    self.map = map
    self.regionRadius = regionRadius
    super.init()
  
    map.delegate = self
  }
  
  func getCurrentRegion() -> MKCoordinateRegion {
    return map.region
  }

  func showRegion(latitude: Double, longitude: Double){
    let location = CLLocationCoordinate2D(
      latitude: latitude,
      longitude: longitude
    )
    let region = MKCoordinateRegionMakeWithDistance(
      location,
      regionRadius * 2,
      regionRadius * 2
    )
    map.setRegion(region, animated: true)
  }

  func addPin(_ pin: Pin){
    let annotation = MKPointAnnotation()
    annotation.title = pin.title
    annotation.coordinate = CLLocationCoordinate2D(
      latitude: pin.latitude,
      longitude: pin.longitude
    )
    map.addAnnotation(annotation)
    
    if pin.selected == true {
      map.selectAnnotation(annotation, animated: true)
    }
    managedPins.append((pin, annotation))
  }
  
  func addPins(_ pinsData: [Pin], removeOldPins: Bool = true){
    if removeOldPins == true {
      removeAllPins()
    }
    
    for pin in pinsData {
      addPin(pin)
    }
  }

  func removeAllPins(){
    managedPins = []
    if map.annotations.count == 0 { return }
    map.removeAnnotations(map.annotations)
  }
  
  func getPinFromAnnotation(annotation: MKAnnotation) -> Pin? {
    for managedPin in managedPins {
      if managedPin.1 === annotation {
        return managedPin.0
      }
    }
    
    return nil
  }
}

// MARK: map view delegate extension
extension MapManager: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
    for annotationView in views {
      let button = UIButton(type: .detailDisclosure)
      annotationView.canShowCallout = true
      annotationView.rightCalloutAccessoryView = button
    }
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    App.main!.trigger(App.Message.annotationViewSelected, object: view)
  }
}
