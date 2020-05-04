//
//  iOSExampleNavigationPerformer.swift
//  Core
//
//  Created by Göksel Köksal on 02/07/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit
import Core

extension NavigationPerformer where Self: UIViewController {
  
  func perform(_ navigation: Navigation) {
    guard let navigation = navigation as? BasicNavigation else { return }
    switch navigation {
    case .push(let destination, from: _):
      guard let navigationController = navigationController else { return }
      var vc: UIViewController?
      if let destination = destination as? LoginComponent {
        vc = LoginViewController.instantiate(with: destination)
      } else if let destination = destination as? HomeComponent {
        vc = HomeViewController.instantiate(with: destination)
      }
      if let vc = vc {
        navigationController.pushViewController(vc, animated: true)
      }
    case .pop(let components):
      guard let navigationController = navigationController else { return }
      let allViewControllers = navigationController.viewControllers
      let viewControllers = Array(allViewControllers.dropLast(components.count))
      navigationController.setViewControllers(viewControllers, animated: true)
    default:
      // Not needed for now.
      break
    }
  }
}
