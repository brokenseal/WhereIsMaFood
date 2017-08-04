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
  var selected: Bool
}


class MapManager: NSObject {
  private let map:MKMapView

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
  }
  
  func addPins(_ pinsData: [Pin], removeOldPins: Bool = false){
    if removeOldPins == true {
      removeAllPins()
    }
    
    for pin in pinsData {
      addPin(pin)
    }
  }

  func removeAllPins(){
    if map.annotations.count == 0 { return }
    map.removeAnnotations(map.annotations)
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
    // TODO: select the restaurant ?
  }
}
