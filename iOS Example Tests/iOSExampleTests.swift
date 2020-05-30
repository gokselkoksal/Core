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
  
  func testOTPFlow() {
    let service = MockOTPService(delay: nil, result: .success)
    let router = MockOTPRouter()
    let module = OTPModule(service: service, router: router)
    let driver = OTPDriver(dispatcher: Dispatcher(middlewares: []), module: module.eraseToAny())
    
    var updates: [OTPViewUpdate] = []
    driver.start(on: nil) { (update) in
      updates.append(update)
    }
    
    driver.dispatch(OTPAction.RequestOTP(phoneNumber: "+353891234567"))
    XCTAssertEqual(updates.count, 2)
    XCTAssertEqual(updates[0], OTPViewUpdate.setLoading(true))
    XCTAssertEqual(updates[1], OTPViewUpdate.setLoading(false))
    XCTAssertEqual(router.latestDestination, OTPDestination.login)
  }
  
  func testLoginFlow() {
    let tickProducer = MockTickProducer()
    let service = MockOTPService(delay: nil, result: .success)
    let router = MockLoginRouter()
    let module = LoginModule(tickProducer: tickProducer, service: service, router: router, otpExpirationTime: 10)
    let driver = LoginDriver(dispatcher: Dispatcher(middlewares: []), module: module.eraseToAny())
    
    var updates: [LoginViewUpdate] = []
    driver.start(on: nil) { (update) in
      updates.append(update)
    }
    
    tickProducer.tick()
    tickProducer.tick()
    XCTAssertEqual(updates.count, 4)
    XCTAssertEqual(updates[0], LoginViewUpdate.setLoading(false)) // TODO: Fix this.
    XCTAssertEqual(updates[1], LoginViewUpdate.updateTimer(TimerStatus.active(remaining: 10, interval: 1)))
    XCTAssertEqual(updates[2], LoginViewUpdate.setLoading(false)) // TODO: Fix this.
    XCTAssertEqual(updates[3], LoginViewUpdate.updateTimer(TimerStatus.active(remaining: 9, interval: 1)))
    
    driver.dispatch(LoginAction.VerifyOTP(code: "1234"))
    XCTAssertEqual(router.latestDestination, LoginDestination.home)
  }
  
}

private final class MockOTPRouter: OTPRouterProtocol {
  
  private(set) var latestDestination: OTPDestination?
  
  func route(to destination: OTPDestination) {
    self.latestDestination = destination
  }
}

private final class MockLoginRouter: LoginRouterProtocol {
  
  private(set) var latestDestination: LoginDestination?
  
  func route(to destination: LoginDestination) {
    self.latestDestination = destination
  }
}

