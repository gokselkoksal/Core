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
      let router = HomeRouter()
      let component = HomeComponent(router: router)
      let driver = HomeDriver(dispatcher: env.dispatcher, component: component.eraseToAny())
      let view = HomeViewController.instantiate(with: driver.eraseToAny())
      router.presentationContext = view
      
      presentationContext?.navigationController?.pushViewController(view, animated: true)
    }
  }
}
