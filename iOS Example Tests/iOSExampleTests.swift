//
//  iOSExampleTests.swift
//  iOS Example Tests
//
//  Created by Goksel Koksal on 14/07/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import XCTest
import Core
@testable import iOS_Example

class iOSExampleTests: XCTestCase {
    
    func testExample() {
        let otpService = MockOTPService(delay: nil)
        let otpComponent = OTPComponent(service: otpService)
        let core = Core(rootComponent: otpComponent)
        
        core.dispatch(otpComponent.commandToRequestOTP(withPhoneNumber: "XXXX"))
        var stack = core.navigationTree.flatten()
        XCTAssertEqual(stack.count, 2)
        XCTAssert(stack[0] === otpComponent)
        guard let loginComponent = stack[1] as? LoginComponent else {
            XCTFail("Login component must be available.")
            return
        }
        core.dispatch(LoginAction.tick)
        switch loginComponent.state.timerStatus {
        case .active(seconds: let seconds):
            XCTAssertEqual(seconds, 60)
        default:
            XCTFail("Timer seconds should be equal to 60 after first tick.")
        }
        
        core.dispatch(loginComponent.commandToVerifyOTP(withCode: "XXXX"))
        
        if let loginResult = loginComponent.state.result {
            switch loginResult {
            case .failure(_):
                XCTFail("Login result should be success.")
            default:
                break
            }
        } else {
            XCTFail("Login state should not be nil.")
        }
        
        stack = core.navigationTree.flatten()
        XCTAssertEqual(stack.count, 3)
        XCTAssert(stack[0] === otpComponent)
        XCTAssert(stack[1] === loginComponent)
        XCTAssert(stack[2] is HomeComponent)
    }
}
