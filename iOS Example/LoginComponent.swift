//
//  LoginComponent.swift
//  Core
//
//  Created by Göksel Köksal on 02/07/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation
import Core

enum LoginAction: Action {
    case tick
    case verifyOTP(String)
}

struct LoginState: State {
    var isLoading = false
    var timerStatus: TimerStatus = .idle
    var result: Result<Void>?
}

class LoginComponent: Component<LoginState> {
    
    let service: OTPService
    
    init(service: OTPService) {
        self.service = service
        super.init(state: LoginState())
    }
    
    override func process(_ action: Action) {
        guard let action = action as? LoginAction else { return }
        switch action {
        case .tick:
            tick()
        case .verifyOTP(let code):
            verifyOTP(code)
        }
    }
    
    private func tick() {
        var state = self.state
        switch state.timerStatus {
        case .idle:
            state.timerStatus = .active(seconds: 60)
        default:
            do {
                try state.timerStatus.tick()
            } catch {
                state.result = .failure(error)
                commit(state, BasicNavigation.pop([self]))
                return
            }
        }
        commit(state)
    }
    
    private func verifyOTP(_ code: String) {
        var state = self.state
        state.isLoading = true
        commit(state)
        service.verifyOTP { [weak self] (result) in
            guard let strongSelf = self else { return }
            state.isLoading = false
            state.timerStatus = .finished
            state.result = result
            switch result {
            case .success():
                let navigation = BasicNavigation.push(HomeComponent(), from: strongSelf)
                strongSelf.commit(state, navigation)
            case .failure(let error):
                print(error)
                strongSelf.commit(state)
            }
        }
    }
}

// MARK: - Helpers

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

enum TimerStatus {
    
    enum Error: Swift.Error {
        case expired
    }
    
    case idle
    case active(seconds: TimeInterval)
    case finished
    
    mutating func tick() throws {
        switch self {
        case .active(seconds: let seconds):
            if seconds > 1.0 {
                self = .active(seconds: seconds - 1.0)
            } else {
                self = .finished
                throw Error.expired
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
        case (.active(let seconds1), .active(let seconds2)):
            return seconds1 == seconds2
        case (.finished, .finished):
            return true
        default:
            return false
        }
    }
}
