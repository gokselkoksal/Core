//
//  OTPRouter.swift
//  iOS Example
//
//  Created by Göksel Köksal on 14.05.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import UIKit

enum OTPDestination {
  case login
}

protocol OTPRouterProtocol {
  func route(to destination: OTPDestination)
}

final class OTPRouter: OTPRouterProtocol {
  
  weak var presentationContext: UIViewController?
  
  func route(to destination: OTPDestination) {
    switch destination {
    case .login:
      let view = LoginBuilder.build()
      presentationContext?.navigationController?.pushViewController(view, animated: true)
    }
  }
}
