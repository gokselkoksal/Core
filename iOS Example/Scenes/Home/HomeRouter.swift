//
//  HomeRouter.swift
//  iOS Example
//
//  Created by Göksel Köksal on 14.05.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import UIKit

enum HomeDestination {
  case login
}

protocol HomeRouterProtocol {
  func route(to destination: HomeDestination)
}

final class HomeRouter: HomeRouterProtocol {
  
  weak var presentationContext: UIViewController?
  
  func route(to destination: HomeDestination) {
    switch destination {
    case .login:
      let view = OTPViewBuilder.build()
      presentationContext?.navigationController?.setViewControllers([view], animated: false)
    }
  }
}
