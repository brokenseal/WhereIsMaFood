//
//  IntroductionPageViewController.swift
//  WhereIsMaFood
//
//  Created by Davide Callegari on 01/09/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import UIKit

struct PageContent {
  let title: String
  let description: String
  let image: UIImage
  let showButton: Bool
}

class IntroductionPageViewController: UIPageViewController {
  let content = [
    PageContent(
      title: "Welcome to MaFood!",
      description: "MaFood is a very simple way of finding new places to eat around you, wherever you are in the world.",
      image: #imageLiteral(resourceName: "Big Salad"),
      showButton: false
    ),
    PageContent(
      title: "Features",
      description: "- Search restaurants near you\n- Pull to refresh\n- Show restaurant websites\n- Show directions to get there",
      image: #imageLiteral(resourceName: "Big Burger"),
      showButton: false
    ),
    PageContent(
      title: "We love Open Source!",
      description: "MaFood is an open source project, it's free and will always be.\nFeel free to fork it and any feedback, feature request and support is much appreciated.",
      image: #imageLiteral(resourceName: "Big Sushi"),
      showButton: true
    ),
  ]
  let orderedViewControllers: [PageViewController]
  
  required init?(coder: NSCoder) {
    orderedViewControllers = content.map { pageContent in
      let pageViewController = AppDelegate
        .getIntroductionStoryboard()
        .instantiateViewController(withIdentifier: "Page") as! PageViewController
      return pageViewController.setup(content: pageContent)
    }
    
    super.init(coder: coder)
    
    dataSource = self
  }
  
  override func viewDidLoad() {
    setViewControllers(
      [orderedViewControllers.first!],
      direction: .forward,
      animated: true,
      completion: nil
    )
    
    super.viewDidLoad()
  }
  
  override func viewDidLayoutSubviews() {
    view.subviews.forEach { view in
      if view is UIPageControl {
        view.backgroundColor = darkOrange
        view.tintColor = .white
      }
    }
  }
}

extension IntroductionPageViewController: UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let currentIndex = orderedViewControllers.index(of: viewController as! PageViewController) else { return nil }
    let previousIndex = currentIndex - 1
    
    if previousIndex < 0 {
      return nil
    }
    
    return orderedViewControllers[previousIndex]
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let currentIndex = orderedViewControllers.index(of: viewController as! PageViewController) else { return nil }
    let nextIndex = currentIndex + 1
    
    if nextIndex >= orderedViewControllers.count {
      return nil
    }
    
    return orderedViewControllers[nextIndex]
  }
  
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return orderedViewControllers.count
  }
  
  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    guard let currentViewController = viewControllers?.first,
      let currentViewControllerIndex = orderedViewControllers.index(of: currentViewController as! PageViewController) else {
        return 0
    }
    
    return currentViewControllerIndex
  }
}

class PageViewController: UIViewController {
  @IBOutlet weak var image: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var letsStartButton: UIButton!
  @IBOutlet weak var githubButton: UIButton!
  
  var content: PageContent!
  
  func setup(content: PageContent) -> PageViewController {
    self.content = content
    return self
  }
  
  override func viewDidLoad() {
    image.image = content.image
    titleLabel.text = content.title
    descriptionLabel.text = content.description
    letsStartButton.isHidden = !content.showButton
    githubButton.isHidden = !content.showButton

    super.viewDidLoad()
  }
  @IBAction func openGithub(_ sender: UIButton) {
    UIApplication.shared.open(URL(string: "https://github.com/brokenseal/WhereIsMaFood")!)
  }
}
