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
    case setLoading(Bool)
    case tick
    case setResult(Result<Void>)
}

struct LoginState: State {
    var isLoading = false
    var timerStatus: TimerStatus = .idle
    var result: Result<Void>?
}

class LoginComponent: Component<LoginState> {
    
    init() {
        super.init(state: LoginState())
    }
    
    override func process(_ action: Action) {
        guard let action = action as? LoginAction else { return }
        var state = self.state
        state.result = nil
        switch action {
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        case .tick:
            switch state.timerStatus {
            case .idle:
                state.timerStatus = .active(seconds: 60)
            default:
                do {
                    try state.timerStatus.tick()
                } catch {
                    state.result = .failure(error)
                    commit(state)
                    commit(BasicNavigation.pop([self]))
                    return
                }
            }
        case .setResult(let result):
            state.timerStatus = .finished
            state.result = result
            commit(state)
            commit(BasicNavigation.push(HomeComponent(), from: self))
            return
        }
        commit(state)
    }
}

class SubmitOTPCommand: Command {
    
    let code: String
    
    init(code: String) {
        self.code = code
    }
    
    func execute(on component: Component<LoginState>, core: Core) {
        // Mocking:
        core.dispatch(LoginAction.setLoading(true))
        let deadline = DispatchTime.now() + DispatchTimeInterval.seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadline) { 
            core.dispatch(LoginAction.setLoading(false))
            core.dispatch(LoginAction.setResult(.success()))
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
