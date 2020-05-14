//
//  Middleware.swift
//  Core
//
//  Created by Göksel Köksal on 04/06/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

public typealias DispatchFunction = (Action) -> Void

public protocol Middleware {
  func overrideDispatch(_ dispatch: @escaping DispatchFunction) -> DispatchFunction
}

public final class LoggerMiddleware: Middleware {
  
  private let id: String
  
  public init(id: String) {
    self.id = id
  }
  
  public func overrideDispatch(_ dispatch: @escaping DispatchFunction) -> DispatchFunction {
    return { action in
      print(self.id, ": will dispatch", action)
      dispatch(action)
      print(self.id, ": did dispatch", action)
    }
  }
}
