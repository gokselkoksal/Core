//
//  HomeComponent.swift
//  Core
//
//  Created by Goksel Koksal on 14/07/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation
import Core

enum HomeAction: Action {
  case logout
}

struct HomeState: State { }

class HomeComponent: Component<HomeState> {
  
  private let router: HomeRouterProtocol
  
  init(router: HomeRouterProtocol) {
    self.router = router
    super.init(state: HomeState())
  }
  
  override func process(_ action: Action) {
    guard let action = action as? HomeAction else { return }
    switch action {
    case .logout:
      router.route(to: .login)
    }
  }
}
