//
//  OTPModule.swift
//  Core
//
//  Created by Göksel Köksal on 02/07/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation
import Core

enum OTPAction {
  struct RequestOTP: AppAction {
    let phoneNumber: String
  }
}

struct OTPState {
  var isLoading = false
  var result: Result<Void, Error>?
}

class BaseModule<StateType>: Module<StateType> {
  
  public private(set) var state: StateType
  
  public init(state: StateType, actionQueue: DispatchQueue? = nil) {
    self.state = state
    super.init(actionQueue: actionQueue)
  }
  
  public final func commit(_ newState: StateType) {
    state = newState
    send(state)
  }
}

class OTPModule: BaseModule<OTPState> {
  
  let service: OTPService
  let router: OTPRouterProtocol
  
  init(service: OTPService, router: OTPRouterProtocol) {
    self.service = service
    self.router = router
    super.init(state: OTPState())
  }
  
  override func process(_ action: Action) {
    switch action {
    case let action as OTPAction.RequestOTP:
      requestOTP(toPhoneNumber: action.phoneNumber)
    default:
      break
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
