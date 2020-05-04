//
//  Environment.swift
//  Core
//
//  Created by Göksel Köksal on 02/07/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Core

let core = Core(rootComponent: OTPComponent(service: MockOTPService(delay: 1.5, result: .success)))
