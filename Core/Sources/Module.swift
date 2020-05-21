//
//  Module.swift
//  Core
//
//  Created by Göksel Köksal on 22/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

public protocol ModuleProtocol: Subscribable where Value == Output {
  associatedtype Output
  
  func start(with dispatcher: DispatcherProtocol)
}

open class Module<Output>: ModuleProtocol {
  
  private let subscriptionStore = SubscriptionStore<Output>()
  private let actionQueue: DispatchQueue?
  private var actionSubscription: SubscriptionProtocol?
  
  public init(actionQueue: DispatchQueue? = nil) {
    self.actionQueue = actionQueue
  }
  
  open func start(with dispatcher: DispatcherProtocol) {
    actionSubscription = dispatcher.subscribe(on: actionQueue, handler: { [weak self] (action) in
      self?.process(action)
    })
  }
  
  open func process(_ action: Action) {
    // Should be implemented by subclasses. Does nothing by default.
  }
  
  public final func subscribe(on queue: DispatchQueue?, id: String, handler: @escaping (Output) -> Void) -> SubscriptionProtocol {
    return subscriptionStore.subscribe(on: queue, id: id, handler: handler)
  }
  
  public final func send(_ output: Output) {
    subscriptionStore.send(output)
  }
}

// MARK: - AnyModule<T>

public extension ModuleProtocol {
  func eraseToAny() -> AnyModule<Output> {
    return AnyModule(self)
  }
}

public final class AnyModule<Output>: ModuleProtocol {
  
  private let module: AnyModuleBase<Output>
  
  public init<T: ModuleProtocol>(_ component: T) where T.Output == Output {
    self.module = AnyModuleBox(component)
  }
  
  public func start(with dispatcher: DispatcherProtocol) {
    module.start(with: dispatcher)
  }
  
  public func subscribe(on queue: DispatchQueue?, id: String, handler: @escaping (Output) -> Void) -> SubscriptionProtocol {
    module.subscribe(on: queue, id: id, handler: handler)
  }
}

private final class AnyModuleBox<T: ModuleProtocol>: AnyModuleBase<T.Output> {
  
  private let module: T
  
  init(_ component: T) {
    self.module = component
  }
  
  override func start(with dispatcher: DispatcherProtocol) {
    module.start(with: dispatcher)
  }
  
  override func subscribe(on queue: DispatchQueue?, id: String, handler: @escaping (Output) -> Void) -> SubscriptionProtocol {
    module.subscribe(on: queue, id: id, handler: handler)
  }
}

private class AnyModuleBase<Output>: ModuleProtocol {
  
  func start(with dispatcher: DispatcherProtocol) {
    fatalError()
  }
  
  func subscribe(on queue: DispatchQueue?, id: String, handler: @escaping (Output) -> Void) -> SubscriptionProtocol {
    fatalError()
  }
}
