//
//  IntroductionPageViewController.swift
//  WhereIsMaFood
//
//  Created by Davide Callegari on 01/09/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import UIKit

class IntroductionPageViewController: UIPageViewController {
  lazy var orderedViewControllers: [UIViewController] = {
    let storyBoard = AppDelegate.getIntroductionStoryboard()
    
    return [
      storyBoard.instantiateViewController(withIdentifier: "Page1"),
      storyBoard.instantiateViewController(withIdentifier: "Page2"),
      storyBoard.instantiateViewController(withIdentifier: "Page3")
    ]
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dataSource = self
    
    setViewControllers(
      [orderedViewControllers.first!],
      direction: .forward,
      animated: true,
      completion: nil
    )
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
    guard let currentIndex = orderedViewControllers.index(of: viewController) else { return nil }
    let previousIndex = currentIndex - 1
    
    if previousIndex < 0 {
      return nil
    }
    
    return orderedViewControllers[previousIndex]
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let currentIndex = orderedViewControllers.index(of: viewController) else { return nil }
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
      let currentViewControllerIndex = orderedViewControllers.index(of: currentViewController) else {
        return 0
    }
    
    return currentViewControllerIndex
  }
}

