//
//  OTPViewBuilder.swift
//  iOS Example
//
//  Created by Göksel Köksal on 24.05.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import UIKit

final class OTPViewBuilder {
  
  static func build() -> OTPViewController {
    let router = OTPRouter()
    let module = OTPModule(service: env.otpService, router: router)
    let driver = OTPDriver(dispatcher: env.dispatcher, module: module.eraseToAny())
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let view = storyboard.instantiateViewController(withIdentifier: String(describing: OTPViewController.self)) as! OTPViewController
    view.driver = driver.eraseToAny()
    router.presentationContext = view
    
    return view
  }
}
