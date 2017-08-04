//
//  RestaurantsDataSource.swift
//  WhereIsMaFood
//
//  Created by Davide Callegari on 27/07/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import MapKit
import Foundation
import CoreLocation


class RestaurantsDataSource {
  private let app: App
  var currentDataSet: RestaurantsDataSet = [] {
    didSet {
      self.app.trigger(
        App.Message.newRestaurantsDataSet,
        object: self.currentDataSet
      )
    }
  }
  let dataGenerator: RestaurantDataSetGeneratorProtocol
  
  init(
    app: App,
    dataGenerator: RestaurantDataSetGeneratorProtocol
  ) {
    self.app = app
    self.dataGenerator = dataGenerator
  }
  
  func selectRestaurantData(at: Int) {
    var current = currentDataSet[at]
    current.selected = true
    currentDataSet[at] = current
  }
  
  func updateData(
    for region: MKCoordinateRegion,
    searchQuery: String = ""
    ) {
    self.dataGenerator.getDataSet(
      ofLength: 30,
      for: region,
      searchQuery: searchQuery
    ) { [weak self] error, updatedDataSet in
      // FIXME: bailout?
      guard let this = self else { return }
      
      if error != nil {
        print("\(error!.localizedDescription)")
        this.app.trigger(App.Message.warnUser, object: "Error while searching for restaurants")
        return
      }
      
      // FIXME: bailout?
      guard let dataSet = updatedDataSet else { return }
      this.currentDataSet = dataSet
    }
  }
}

struct RestaurantData {
  let name: String
  let type: String
  let shortDescription: String
  let location: CLLocation
  var selected: Bool
}

typealias RestaurantsDataSet = [RestaurantData]

protocol RestaurantDataSetGeneratorProtocol {
  func getDataSet(
    ofLength: Int,
    for region: MKCoordinateRegion,
    searchQuery: String,
    completion: @escaping (Error?, RestaurantsDataSet?) -> Void
  ) -> Void
}

class MKRestaurantDataSetGenerator: RestaurantDataSetGeneratorProtocol {
  func getDataSet(
    ofLength: Int,
    for region: MKCoordinateRegion,
    searchQuery: String = "",
    completion: @escaping (Error?, RestaurantsDataSet?) -> Void
  ) -> Void {
    mkSearch(searchQuery: searchQuery, region: region) { response, error in
      if let error = error {
        completion(error, nil)
        return
      }
      
      if let response = response {
        let UNKNOWN = "Unknown"
        
        let restaurantsDataSet = response.mapItems.map { mapItem in
          return RestaurantData(
            name: mapItem.name ?? UNKNOWN,
            type: UNKNOWN, //areasOfInterest?
            shortDescription: UNKNOWN,
            location: CLLocation(
              latitude: mapItem.placemark.coordinate.latitude,
              longitude: mapItem.placemark.coordinate.longitude
            ),
            selected: false
          )
        }
        
        completion(nil, restaurantsDataSet)
        return
      }
      
      completion(ErrorsManager.appError(), nil)
    }
  }
}

func mkSearch(
  searchQuery: String,
  region: MKCoordinateRegion,
  completion: @escaping MKLocalSearchCompletionHandler
) {
  let searchRequest = MKLocalSearchRequest()
  searchRequest.naturalLanguageQuery = "restaurant \(searchQuery)"
  searchRequest.region = region
  
  let localSearch = MKLocalSearch(request: searchRequest)
  localSearch.start(completionHandler: completion)
}
