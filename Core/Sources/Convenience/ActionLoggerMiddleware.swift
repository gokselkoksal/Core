//
//  ActionLoggerMiddleware.swift
//  Core iOS
//
//  Created by Göksel Köksal on 1.06.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import Foundation

public final class ActionLoggerMiddleware: Middleware {
  
  public init() { }
  
  public func overrideDispatch(_ dispatch: @escaping DispatchFunction) -> DispatchFunction {
    return { action in
      dispatch(action)
      print("Dispatched:", action)
    }
  }
}
