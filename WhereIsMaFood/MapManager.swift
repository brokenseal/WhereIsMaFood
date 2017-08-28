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
  
  var location: CLLocation {
    return CLLocation(
      latitude: latitude,
      longitude: longitude
    )
  }
}

class MapManager: NSObject {
  enum ExternalMapDirectionsProvider {
    case apple
    case google
    
    func getDirectionsUrlsUsing(
      from: CLLocation,
      to: CLLocation
    ) -> URL {
      var directionsUrl: String
      switch self {
        case .apple: directionsUrl = "http://maps.apple.com/?saddr=\(from.coordinate.latitude),\(from.coordinate.longitude)&daddr=\(to.coordinate.latitude),\(to.coordinate.longitude)"
        case .google: directionsUrl = "comgooglemaps://?saddr=&daddr=\(from.coordinate.latitude),\(from.coordinate.longitude)"
      }
      
      return URL(string: directionsUrl)!
    }

    func getDirections(
      from: CLLocation,
      to: CLLocation
    ){
      let directionsUrl = getDirectionsUrlsUsing(
        from: from,
        to: to
      )
      
      if UIApplication.shared.canOpenURL(directionsUrl) {
        UIApplication.shared.open(
          directionsUrl,
          options: [:],
          completionHandler: nil
        )
      } else {
        App.main!.trigger(App.Message.warnUser, object: "Can't open directions app: is it installed?")
      }
    }
  }
  
  internal let map:MKMapView
  private var managedPins: [(Pin, MKAnnotation)] = []

  var regionRadius: Double

  init(
    _ map: MKMapView,
    regionRadius: Double = 2000.0
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
  
  func getCurrentlySelectedPin() -> Pin? {
    if map.selectedAnnotations.count == 0 {
      return nil
    }
    
    let selectedAnnotation = map.selectedAnnotations[0]
    
    return Pin(
      title: selectedAnnotation.title!!,
      latitude: selectedAnnotation.coordinate.latitude,
      longitude: selectedAnnotation.coordinate.longitude,
      rawData: nil,
      selected: true
    )
  }
}

// MARK: map view delegate extension
extension MapManager: MKMapViewDelegate {
  func mapView(
    _ mapView: MKMapView,
    didAdd views: [MKAnnotationView]
  ) {
    //addInformationButtonTo(views)
  }
  
  func addInformationButtonTo(_ views: [MKAnnotationView]){
    for annotationView in views {
      let button = UIButton(type: .detailDisclosure)
      annotationView.canShowCallout = true
      annotationView.rightCalloutAccessoryView = button
      button.addTarget(
        self,
        action: #selector(MapManager.showDirectionsUsingCurrentLocations),
        for: UIControlEvents.touchDown
      )
    }
  }
  
  func getLocationsForDirections() -> (CLLocation, CLLocation)? {
    guard let currentlySelectedPin = getCurrentlySelectedPin(),
      let userLocation = map.userLocation.location else { return nil }
    
    return (currentlySelectedPin.location, userLocation)
  }
  
  func showDirectionsUsingCurrentLocations() {
    // FIXME: Inform user?
    if let (selectedPinLocation, userLocation) = getLocationsForDirections() {
      showDirectionsUsing(
        provider: .apple,
        from: userLocation,
        to: selectedPinLocation
      )
    }
  }
  
  func showDirectionsUsing(
    provider: ExternalMapDirectionsProvider,
    from: CLLocation,
    to: CLLocation
  ){
    provider.getDirections(from: from, to: to)
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    App.main.trigger(App.Message.annotationViewSelected, object: view)
  }
}
