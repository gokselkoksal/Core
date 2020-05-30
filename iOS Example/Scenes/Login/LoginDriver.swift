//
//  LoginDriver.swift
//  iOS Example
//
//  Created by Göksel Köksal on 14.05.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import Foundation
import Core

protocol UserAction: Core.Action { }
protocol SystemAction: Core.Action { }

final class LoginDriver: Driver<LoginState, LoginViewUpdate> {
  
  override func update(with state: LoginState) {
    emit(.setLoading(state.isLoading))
    emit(.updateTimer(state.timerStatus))
  }
}
