//
//  OTPComponent.swift
//  Core
//
//  Created by Göksel Köksal on 02/07/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation
import Core

enum OTPAction: Action {
  case requestOTP(phoneNumber: String)
}

struct OTPState: State {
  var isLoading = false
  var result: Result<Void, Error>?
}

class OTPComponent: Component<OTPState> {
  
  let service: OTPService
  let router: OTPRouterProtocol
  
  init(service: OTPService, router: OTPRouterProtocol) {
    self.service = service
    self.router = router
    super.init(state: OTPState())
  }
  
  override func process(_ action: Action) {
    guard let action = action as? OTPAction else { return }
    switch action {
    case .requestOTP(phoneNumber: let phoneNumber):
      requestOTP(toPhoneNumber: phoneNumber)
    }
  }
  
  private func requestOTP(toPhoneNumber phoneNumber: String) {
    var state = self.state
    state.isLoading = true
    commit(state)
    service.requestOTP { [weak self] (result) in
      guard let self = self else { return }
      state.isLoading = false
      state.result = result
      switch result {
      case .success():
        self.commit(state)
        self.router.route(to: .login)
      default:
        self.commit(state)
      }
    }
  }
}
