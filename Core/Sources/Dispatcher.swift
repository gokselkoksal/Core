//
//  Dispatcher.swift
//  Core
//
//  Created by Göksel Köksal on 04/06/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

public protocol DispatcherProtocol {
  
  func dispatch<T: Action>(_ action: T)
  
  func subscribe(
    on queue: DispatchQueue?,
    id: String,
    handler: @escaping (Action) -> Void) -> SubscriptionProtocol
}

extension DispatcherProtocol {
  
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

public final class Dispatcher: DispatcherProtocol {
  
  private let subscriptionStore: SubscriptionStore<Action>
  private let dispatchFunction: DispatchFunction
  
  public init(middlewares: [Middleware]) {
    let subscriptionStore = SubscriptionStore<Action>()
    let defaultDispatchFunction: DispatchFunction = { [weak subscriptionStore] action in
      print("dispatch", action)
      subscriptionStore?.send(action)
    }
    self.subscriptionStore = subscriptionStore
    self.dispatchFunction = middlewares.reversed().reduce(defaultDispatchFunction) { (partialDispatchFunction, middleware) -> DispatchFunction in
      return middleware.overrideDispatch(partialDispatchFunction)
    }
  }
  
  public func subscribe(on queue: DispatchQueue?, id: String, handler: @escaping (Action) -> Void) -> SubscriptionProtocol {
    return subscriptionStore.subscribe(on: queue, id: id, handler: handler)
  }
  
  public func dispatch<T>(_ action: T) where T : Action {
    dispatchFunction(action)
  }
}
