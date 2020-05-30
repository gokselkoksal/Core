//
//  Environment+Actions.swift
//  iOS Example
//
//  Created by Göksel Köksal on 1.06.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import Foundation
import Core

func registerActions(to r: CodableActionRegistryProtocol) {
  r.register(LoginAction.VerifyOTP.self)
  r.register(OTPAction.RequestOTP.self)
  r.register(HomeAction.Logout.self)
}
