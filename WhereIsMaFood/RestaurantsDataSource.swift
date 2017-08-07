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
    let selected = currentDataSet[at]
    
    currentDataSet = currentDataSet.map { dataSet in
      if dataSet == selected {
        return dataSet.clone(selected: true)
      } else {
        return dataSet.clone(selected: false)
      }
    }
  }
  
  func select(_ restauranData: RestaurantData) {
    let toBeSelected = restauranData
    
    currentDataSet = currentDataSet.map { dataSet in
      if dataSet == toBeSelected {
        return dataSet.clone(selected: true)
      } else {
        return dataSet.clone(selected: false)
      }
    }
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

struct RestaurantData: Equatable {
  let name: String
  let type: String
  let shortDescription: String
  let location: CLLocation
  var selected: Bool
  
  static func == (
    lhs: RestaurantData,
    rhs: RestaurantData
  ) -> Bool {
    return lhs.name == rhs.name
      && lhs.type == rhs.type
      && lhs.shortDescription == rhs.shortDescription
  }
  
  func clone(selected: Bool?) -> RestaurantData {
    return RestaurantData(
      name: name,
      type: type,
      shortDescription: shortDescription,
      location: location,
      selected: selected ?? self.selected
    )
  }
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
