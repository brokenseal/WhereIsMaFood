//
//  ShowWebsiteModalViewController.swift
//  WhereIsMaFood
//
//  Created by Davide Callegari on 08/08/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import UIKit

class ShowWebsiteModalViewController: UIViewController {
  @IBOutlet weak var webView: UIWebView!
  var url: URL?
  
  @IBAction func goBack(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // FIXME: bail out?
    if let url = url {
      let request = URLRequest(url: url)
      webView.loadRequest(request)
    }
  }
  
  func setup(url: URL){
    self.url = url
  }
}
