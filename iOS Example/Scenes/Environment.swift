//
//  Environment.swift
//  Core
//
//  Created by Göksel Köksal on 02/07/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Core

let env = Environment()

final class Environment {
  
  let dispatcher = Dispatcher(
    middlewares: [
      LoggerMiddleware(id: "1"),
      LoggerMiddleware(id: "2"),
      LoggerMiddleware(id: "3")
    ]
  )
  public let otpService = MockOTPService(delay: 1.5, result: .success)
}

public final class RecorderMiddleware: Middleware {
  
  private let recorder: ActionRecoder
  
  init(repository: ActionRepositoryProtocol, clock: ClockProtocol) {
    self.recorder = ActionRecoder(repository: repository, clock: clock)
  }
  
  public func overrideDispatch(_ dispatch: @escaping DispatchFunction) -> DispatchFunction {
    return dispatch
  }
  
  public func didDispatch<T>(_ action: T) where T : Action {
    // recorder.record(action)
  }
}
