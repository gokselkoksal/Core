//
//  Environment.swift
//  Core
//
//  Created by Göksel Köksal on 02/07/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Core

protocol AppAction: CodableAction { }

let env = Environment()

final class Environment {
  
  lazy var dispatcher = Dispatcher(
    middlewares: [
      ActionLoggerMiddleware(),
      ActionRecorderMiddleware(repository: self.actionRepository, clock: self.clock)
    ]
  )
  var clock: Clock { Clock.shared }
  private(set) lazy var actionRepository = FileBasedActionRepository(decoder: actionDecoder)
  private(set) lazy var otpService = MockOTPService(delay: 1.5, result: .success)
  private(set) lazy var actionDecoder: ActionRecordJSONDecoderProtocol = {
    let decoder = ActionRecordJSONDecoder()
    registerActions(to: decoder)
    return decoder
  }()
}
