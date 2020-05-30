//
//  HomeViewBuilder.swift
//  iOS Example
//
//  Created by Göksel Köksal on 24.05.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import Foundation

final class HomeViewBuilder {
  static func build() -> HomeViewController {
    let router = HomeRouter()
    let module = HomeModule(router: router)
    let driver = HomeDriver(dispatcher: env.dispatcher, module: module.eraseToAny())
    let view = HomeViewController.instantiate(with: driver.eraseToAny())
    router.presentationContext = view
    return view
  }
}
