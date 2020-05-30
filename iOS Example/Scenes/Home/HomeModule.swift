//
//  HomeModule.swift
//  Core
//
//  Created by Goksel Koksal on 14/07/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation
import Core

enum HomeAction {
  struct Logout: AppAction { }
}

struct HomeState { }

class HomeModule: BaseModule<HomeState> {
  
  private let router: HomeRouterProtocol
  
  init(router: HomeRouterProtocol) {
    self.router = router
    super.init(state: HomeState())
  }
  
  override func process(_ action: Action) {
    switch action {
    case is HomeAction.Logout:
      router.route(to: .login)
    default:
      break
    }
  }
}
