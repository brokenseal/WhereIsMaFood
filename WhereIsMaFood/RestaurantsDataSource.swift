//
//  RestaurantsDataSource.swift
//  WhereIsMaFood
//
//  Created by Davide Callegari on 27/07/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import Foundation
import CoreLocation


class RestaurantsDataSource {
  private let app: App
  var currentDataSet: RestaurantsDataSet = []
  
  init(app: App) {
    self.app = app
  }
  
  func updateData(
    for location: CLLocation,
    searchQuery: String?
    ) {
    currentDataSet = RandomRestaurantDataSetGenerator(
      seed: 10
      ).getDataSet(ofLength: 30)
    
    app.trigger(
      App.Message.newRestaurantsDataSet,
      object: currentDataSet
    )
  }
}

struct RestaurantData {
  let name: String
  let type: String
  let shortDescription: String
  let location: CLLocation
}

typealias RestaurantsDataSet = [RestaurantData]
