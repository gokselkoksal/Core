//
//  Core.swift
//  Core
//
//  Created by Göksel Köksal on 04/06/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

public protocol Dispatcher {
  func dispatch(_ action: Action)
  
    func subscribe(
      on queue: DispatchQueue?,
      id: String,
      handler: @escaping (Action) -> Void) -> SubscriptionProtocol
}

extension Dispatcher {
  
  public func subscribe(
    on queue: DispatchQueue? = nil,
    file: String = #file,
    line: UInt = #line,
    handler: @escaping (Action) -> Void) -> SubscriptionProtocol
  {
    let fileId = URL(string: file)?.lastPathComponent ?? file
    return subscribe(on: queue, id: "\(fileId):\(line)", handler: handler)
  }
}

public final class Core: Dispatcher {
  
  private let subscriptionStore = SubscriptionStore<Action>()
  
  public init() { }
  
  public func subscribe(on queue: DispatchQueue?, id: String, handler: @escaping (Action) -> Void) -> SubscriptionProtocol {
    return subscriptionStore.subscribe(on: queue, id: id, handler: handler)
  }
  
  public func dispatch(_ action: Action) {
    subscriptionStore.send(action)
  }
}
