//
//  LoginRouter.swift
//  iOS Example
//
//  Created by Göksel Köksal on 14.05.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import UIKit

enum LoginDestination {
  case back
  case home
}

protocol LoginRouterProtocol {
  func route(to destination: LoginDestination)
}

final class LoginRouter: LoginRouterProtocol {
  
  weak var presentationContext: UIViewController?
  
  func route(to destination: LoginDestination) {
    switch destination {
    case .back:
      presentationContext?.navigationController?.popViewController(animated: true)
    case .home:
      let view = HomeViewBuilder.build()
      presentationContext?.navigationController?.setViewControllers([view], animated: true)
    }
  }
}
