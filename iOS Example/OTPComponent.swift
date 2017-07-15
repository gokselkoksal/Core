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
    case setResult(Result<Void>)
}

struct OTPState: State {
    var isLoading = false
    var result: Result<Void>?
}

class OTPComponent: Component<OTPState> {
    
    let service: OTPService
    
    init(service: OTPService) {
        self.service = service
        super.init(state: OTPState())
    }
    
    func commandToRequestOTP(withPhoneNumber phoneNumber: String) -> RequestOTPCommand {
        return RequestOTPCommand(service: service, phoneNumber: phoneNumber)
    }
    
    override func process(_ action: Action) {
        guard let action = action as? OTPAction else { return }
        var state = self.state
        switch action {
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        case .setResult(let result):
            state.result = result
            switch result {
            case .success():
                let component = LoginComponent(service: service)
                commit(state)
                commit(BasicNavigation.push(component, from: self))
                return
            default:
                break
            }
        }
        commit(state)
    }
}

class RequestOTPCommand: Command {
    
    let service: OTPService
    let phoneNumber: String
    
    init(service: OTPService, phoneNumber: String) {
        self.service = service
        self.phoneNumber = phoneNumber
    }
    
    func execute(on component: Component<OTPState>, core: Core) {
        core.dispatch(OTPAction.setLoading(true))
        service.requestOTP { (result) in
            core.dispatch(OTPAction.setLoading(false))
            core.dispatch(OTPAction.setResult(result))
        }
    }
}
