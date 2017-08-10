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
  @IBOutlet weak var showWebsite: UIBarButtonItem!
  @IBOutlet weak var toolbar: UIToolbar!
  
  var restaurantData: RestaurantData?
  
  func setup(with restaurantData: RestaurantData){
    self.restaurantData = restaurantData
    
    isSelected = restaurantData.selected
    restaurantName.text = restaurantData.name
    
    if let url = restaurantData.url {
      self.url.text = url.absoluteString
    }
    
    self.backgroundColor = isSelected ? UIColor.lightGray : nil
    toolbar.isHidden = !isSelected
    showWebsite.isEnabled = restaurantData.url != nil && isSelected == true
  }
}
