//
//  RestaurantTableCell.swift
//  WhereIsMaFood
//
//  Created by Davide Callegari on 07/08/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//
import UIKit
import Foundation


class RestaurantTableCell: UITableViewCell {
  @IBOutlet weak var restaurantName: UILabel!
  @IBOutlet weak var url: UILabel!
  
  var restaurantData: RestaurantData?
  
  func setup(with restaurantData: RestaurantData){
    self.restaurantData = restaurantData
    
    self.isSelected = restaurantData.selected
    /*
    if restaurantData.selected == true {
      self.backgroundColor = UIColor.lightGray
    } else {
      self.backgroundColor = nil
    }
    */
    self.restaurantName.text = restaurantData.name
    
    if let url = restaurantData.url {
      self.url.text = url.absoluteString
    }
  }
}
