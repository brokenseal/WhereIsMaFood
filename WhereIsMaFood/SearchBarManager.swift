//
//  SearchBarManager.swift
//  WhereIsMaFood
//
//  Created by Davide Callegari on 31/07/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import UIKit
import Foundation


typealias SearchBarManagerTextDidChangeListener = (_ searchText: String) -> Void

class SearchBarManager: NSObject {
  private let searchBar: UISearchBar
  let textDidChangeListener:SearchBarManagerTextDidChangeListener
  var lastSearchQuery: String = ""
  
  init(
    _ searchBar: UISearchBar,
    textDidChangeListener: @escaping SearchBarManagerTextDidChangeListener
    ) {
    self.searchBar = searchBar
    self.textDidChangeListener = textDidChangeListener
    
    super.init()
    
    self.searchBar.delegate = self
  }
}


extension SearchBarManager: UISearchBarDelegate {
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    lastSearchQuery = searchBar.text ?? ""
    textDidChangeListener(lastSearchQuery)
  }
}
