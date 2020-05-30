//
//  LoginViewBuilder.swift
//  iOS Example
//
//  Created by Göksel Köksal on 14.05.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import UIKit

final class LoginViewBuilder {
  
  static func build() -> LoginViewController {
    let router = LoginRouter()
    let tickProducer = TickProducer()
    let module = LoginModule(tickProducer: tickProducer, service: env.otpService, router: router)
    let driver = LoginDriver(dispatcher: env.dispatcher, module: module.eraseToAny())
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let view = storyboard.instantiateViewController(withIdentifier: String(describing: LoginViewController.self)) as! LoginViewController
    view.driver = driver.eraseToAny()
    router.presentationContext = view
    
    return view
  }
}
