//
//  Middleware.swift
//  Core
//
//  Created by Göksel Köksal on 04/06/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

public typealias DispatchFunction = (Action) -> Void

public protocol Middleware: class {
  func overrideDispatch(_ dispatch: @escaping DispatchFunction) -> DispatchFunction
}
