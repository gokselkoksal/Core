//
//  HomeViewController.swift
//  Core
//
//  Created by Goksel Koksal on 14/07/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit
import Core

class HomeViewController: UIViewController {
  
  var dispatcher: Dispatcher!
  var component: HomeComponent!
  private var stateSubscription: SubscriptionProtocol?
  
  static func instantiate(with component: HomeComponent) -> HomeViewController {
    let vc = HomeViewController()
    vc.component = component
    return vc
  }
  
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
    stateSubscription = component.subscribe(on: .main) { [weak self] (state) in
      self?.update(with: state)
    }
    component.start(with: dispatcher)
  }
  
  @objc private func logoutTapped() {
    dispatcher.dispatch(HomeAction.logout)
  }
  
  func update(with state: HomeState) {
    // Update...
  }
}
