//
//  OTPService.swift
//  Core
//
//  Created by Goksel Koksal on 14/07/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

protocol OTPService {
    func requestOTP(completion: @escaping (Result<Void>) -> Void)
    func verifyOTP(completion: @escaping (Result<Void>) -> Void)
}

class MockOTPService: OTPService {
    
    private let delay: TimeInterval?
    private let result: Result<Void>
    
    init(delay: TimeInterval?, result: Result<Void> = .success()) {
        self.delay = delay
        self.result = result
    }
    
    func requestOTP(completion: @escaping (Result<Void>) -> Void) {
        if let delay = delay {
            let deadline = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(delay * 1000))
            DispatchQueue.main.asyncAfter(deadline: deadline) { [weak self] in
                guard let strongSelf = self else { return }
                completion(strongSelf.result)
            }
        } else {
            completion(result)
        }
    }
    
    func verifyOTP(completion: @escaping (Result<Void>) -> Void) {
        if let delay = delay {
            let deadline = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(delay * 1000))
            DispatchQueue.main.asyncAfter(deadline: deadline) { [weak self] in
                guard let strongSelf = self else { return }
                completion(strongSelf.result)
            }
        } else {
            completion(result)
        }
    }
}
