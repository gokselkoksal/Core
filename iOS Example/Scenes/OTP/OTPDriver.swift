//
//  OTPDriver.swift
//  iOS Example
//
//  Created by Göksel Köksal on 14.05.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import Foundation
import Core

final class OTPDriver: Driver<OTPState, OTPViewUpdate> {
  
  override func update(with state: OTPState) {
    emit(.setLoading(state.isLoading))
  }
}
