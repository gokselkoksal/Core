//
//  HomeViewController.swift
//  Core
//
//  Created by Goksel Koksal on 14/07/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit
import Core

enum HomeViewUpdate {
  case noop
}

protocol HomeViewProtocol {
  var driver: AnyDriver<HomeViewUpdate>! { get set }
}

// MARK: - Implementation

class HomeViewController: UIViewController, HomeViewProtocol {
  
  var driver: AnyDriver<HomeViewUpdate>!
  private var stateSubscription: SubscriptionProtocol?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Home"
    view.backgroundColor = .white
    let logoutButton = UIBarButtonItem(
      title: "Logout",
      style: .plain,
      target: self,
      action: #selector(logoutTapped)
    )
    navigationItem.leftBarButtonItem = logoutButton
    driver.start(on: .main) { [weak self] (update) in
      self?.handleUpdate(update)
    }
  }
  
  @objc private func logoutTapped() {
    driver.dispatch(HomeAction.Logout())
  }
  
  private func handleUpdate(_ update: HomeViewUpdate) {
    // Implement...
  }
}
