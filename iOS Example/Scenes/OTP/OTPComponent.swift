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
  var result: Result<Void>?
}

class OTPComponent: Component<OTPState> {
  
  let service: OTPService
  
  init(service: OTPService) {
    self.service = service
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
      guard let strongSelf = self else { return }
      state.isLoading = false
      state.result = result
      switch result {
      case .success():
        let component = LoginComponent(service: strongSelf.service)
        let navigation = BasicNavigation.push(component, from: strongSelf)
        strongSelf.commit(state, navigation)
      default:
        strongSelf.commit(state)
      }
    }
  }
}
