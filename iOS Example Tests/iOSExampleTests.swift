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
    
    func testLoginFlow() {
        let otpService = MockOTPService(delay: nil)
        let otpComponent = OTPComponent(service: otpService)
        let core = Core(rootComponent: otpComponent)
        
        // Request OTP:
        core.dispatch(OTPAction.requestOTP(phoneNumber: "+905309998877"))
        
        // Check if login component is pushed:
        var stack = core.navigationTree.flatten()
        XCTAssertEqual(stack.count, 2)
        XCTAssert(stack[0] === otpComponent)
        guard let loginComponent = stack[1] as? LoginComponent else {
            XCTFail("Login component must be available.")
            return
        }
        
        // Check if timer is working on login component:
        core.dispatch(LoginAction.tick)
        XCTAssertEqual(loginComponent.state.timerStatus, TimerStatus.active(seconds: 60))
        
        // Verify OTP:
        core.dispatch(LoginAction.verifyOTP("6754"))
        
        // Check if OTP verified successfully:
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
        
        // Check if home component is pushed:
        stack = core.navigationTree.flatten()
        XCTAssertEqual(stack.count, 3)
        XCTAssert(stack[0] === otpComponent)
        XCTAssert(stack[1] === loginComponent)
        XCTAssert(stack[2] is HomeComponent)
    }
}
