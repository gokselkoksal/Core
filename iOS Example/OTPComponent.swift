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
    case setLoading(Bool)
    case setError(Error)
}

enum OTPNavigatorAction: NavigatorAction {
    case otpSent
}

struct OTPState: State {
    var isLoading = false
    var error: Error? = nil
}

class OTPComponent: Component<OTPState> {
    
    init() {
        super.init(state: OTPState())
    }
    
    override func process(_ action: Action) {
        if let action = action as? OTPAction {
            var state = self.state
            state.error = nil
            switch action {
            case .setLoading(let isLoading):
                state.isLoading = isLoading
            case .setError(let error):
                state.error = error
            }
            commit(state)
        }
        
        if let action = action as? OTPNavigatorAction {
            switch action {
            case .otpSent:
                commit(BasicNavigation.push(LoginComponent(), from: self))
            }
        }
    }
}

class SendOTPCommand: Command {
    
    let phoneNumber: String
    
    init(phoneNumber: String) {
        self.phoneNumber = phoneNumber
    }
    
    func execute(on component: Component<OTPState>, core: Core) {
        // Mocking:
        core.dispatch(OTPAction.setLoading(true))
        let deadline = DispatchTime.now() + DispatchTimeInterval.seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadline) { 
            core.dispatch(OTPAction.setLoading(false))
            core.dispatch(OTPNavigatorAction.otpSent)
        }
    }
}
