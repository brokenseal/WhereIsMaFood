//
//  TestUtils.swift
//  WhereIsMaFood
//
//  Created by Davide Callegari on 27/07/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import MapKit
import Foundation


class RandomRestaurantDataSetGenerator: RestaurantDataSetGeneratorProtocol {
  let seed: UInt32
  
  required init(seed: UInt32) {
    // FIXME: seed is actually not used at the moment
    self.seed = seed
    //arc4random(self.seed)
  }
  
  func next() -> RestaurantData {
    let restaurantId = arc4random()
    
    return RestaurantData(
      name: "Restaurant #\(restaurantId)",
      type: "Test",
      shortDescription: "Short description of restaurant #\(restaurantId)",
      location: CLLocation(
        latitude: 12.0,
        longitude: 12.0
      ),
      selected: false
    )
  }
  
  func getDataSet(
    ofLength: Int,
    for region: MKCoordinateRegion,
    searchQuery: String,
    completion: @escaping (Error?, RestaurantsDataSet?) -> Void
  ) -> Void {
    var restaurantsDataSet: RestaurantsDataSet = []
    
    for _ in 0...ofLength {
      restaurantsDataSet.append(next())
    }
    
    completion(nil, restaurantsDataSet)
  }
}
