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
  
  func hideKeyboard(){
    searchBar.resignFirstResponder()
  }
}

extension SearchBarManager: UISearchBarDelegate {
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    hideKeyboard()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    hideKeyboard()
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    lastSearchQuery = searchText
    textDidChangeListener(lastSearchQuery)
  }
}
