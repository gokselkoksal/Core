//
//  LoginModule.swift
//  Core
//
//  Created by Göksel Köksal on 02/07/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation
import Core

enum LoginAction {
  struct VerifyOTP: AppAction {
    let code: String
  }
}

struct LoginState {
  var isLoading = false
  var timerStatus: TimerStatus = .idle
  var result: Result<Void, Error>?
}

enum LoginError: Error {
  case timeout
}

final class LoginModule: BaseModule<LoginState> {
  
  private let tickProducer: TickProducerProtocol
  private let service: OTPService
  private let router: LoginRouterProtocol
  private let tickInterval: TimeInterval = 1.0
  
  init(tickProducer: TickProducerProtocol, service: OTPService, router: LoginRouterProtocol) {
    self.tickProducer = tickProducer
    self.service = service
    self.router = router
    super.init(state: LoginState())
  }
  
  override func start(with dispatcher: DispatcherProtocol) {
    super.start(with: dispatcher)
    tickProducer.setHandler { [weak self] in
      self?.tick()
    }
    tickProducer.start(interval: tickInterval)
  }
  
  override func process(_ action: Action) {
    switch action {
    case let action as LoginAction.VerifyOTP:
      verifyOTP(action.code)
    default:
      break
    }
  }
  
  private func tick() {
    var state = self.state
    
    switch state.timerStatus {
    case .idle:
      state.timerStatus = .active(remaining: 10, interval: tickInterval)
      commit(state)
    default:
      state.timerStatus.tick()
      if state.timerStatus == .finished {
        state.result = .failure(LoginError.timeout)
        commit(state)
        router.route(to: .back)
      } else {
        commit(state)
      }
    }
  }
  
  private func verifyOTP(_ code: String) {
    var state = self.state
    state.isLoading = true
    commit(state)
    service.verifyOTP { [weak self] (result) in
      guard let self = self else { return }
      state.isLoading = false
      state.result = result
      switch result {
      case .success():
        self.commit(state)
        self.router.route(to: .home)
      case .failure(let error):
        print(error)
        self.commit(state)
      }
    }
  }
}

// MARK: - Helpers

extension Result where Success == Void {
  static var success: Result<Void, Error> { .success(()) }
}

enum TimerStatus {
  
  case idle
  case active(remaining: TimeInterval, interval: TimeInterval)
  case finished
  
  mutating func tick() {
    switch self {
    case .active(remaining: var remaining, interval: let interval):
      if remaining >= interval {
        remaining -= interval
        self = remaining < interval ? .finished : .active(remaining: remaining, interval: interval)
      } else {
        self = .finished
      }
    default:
      break
    }
  }
}

extension TimerStatus: Equatable {
  
  static func ==(a: TimerStatus, b: TimerStatus) -> Bool {
    switch (a, b) {
    case (.idle, .idle):
      return true
    case (.active(let remaining1, let interval1), .active(let remaining2, let interval2)):
      return remaining1 == remaining2 && interval1 == interval2
    case (.finished, .finished):
      return true
    default:
      return false
    }
  }
}
