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
    var latitude: Double
    var longitude: Double
}


class MapManager: NSObject {
    private let map:MKMapView

    var regionRadius: Double

    init(_ map: MKMapView, regionRadius: Double?){
        self.map = map
        self.regionRadius = regionRadius ?? 1000.0
        super.init()
        map.delegate = self
    }

    func showRegion(latitude: Double, longitude: Double){
        let location = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        let region = MKCoordinateRegionMakeWithDistance(location, regionRadius * 2, regionRadius * 2)
        map.setRegion(region, animated: true)
    }

    func addPin(_ pin: Pin){
        let annotation = MKPointAnnotation()
        annotation.title = pin.title
        annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        map.addAnnotation(annotation)
    }

    func addPins(_ pinsData: [Pin]){
        for pinData in pinsData {
            addPin(Pin(title: pinData.title, latitude: pinData.latitude, longitude: pinData.longitude))
        }
    }

    func removeAllPins(){
        if map.annotations.count == 0 { return }
        map.removeAnnotations(map.annotations)
    }
}

extension MapManager: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        for annotationView in views {
            let button = UIButton(type: .detailDisclosure)
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = button
        }
        /*
         MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
         annotationView.canShowCallout = YES;
         annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
         */
    }
}
