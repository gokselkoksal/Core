//
//  Driver.swift
//  Core iOS
//
//  Created by Göksel Köksal on 13.05.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import Foundation

public protocol DriverProtocol: class {
  associatedtype ViewUpdate
  
  func start(on queue: DispatchQueue?, handler: @escaping (ViewUpdate) -> Void)
  func dispatch<T: Action>(_ action: T)
}

public extension DriverProtocol {
  
  func start(handler: @escaping (ViewUpdate) -> Void) {
    start(on: nil, handler: handler)
  }
  
  func eraseToAny() -> AnyDriver<ViewUpdate> {
    return AnyDriver(self)
  }
}

public final class AnyDriver<ViewUpdate>: DriverProtocol {
  
  private let driver: AnyDriverBase<ViewUpdate>
  
  public init<T: DriverProtocol>(_ driver: T) where T.ViewUpdate == ViewUpdate {
    self.driver = AnyDriverBox(driver)
  }
  
  public func start(on queue: DispatchQueue?, handler: @escaping (ViewUpdate) -> Void) {
    driver.start(on: queue, handler: handler)
  }
  
  public func dispatch<T>(_ action: T) where T : Action {
    driver.dispatch(action)
  }
}

private class AnyDriverBox<T: DriverProtocol>: AnyDriverBase<T.ViewUpdate> {
  
  private let driver: T
  
  init(_ driver: T) {
    self.driver = driver
  }
  
  override func start(on queue: DispatchQueue?, handler: @escaping (T.ViewUpdate) -> Void) {
    driver.start(on: queue, handler: handler)
  }
  
  override func dispatch<T>(_ action: T) where T : Action {
    driver.dispatch(action)
  }
}

private class AnyDriverBase<ViewUpdate>: DriverProtocol {
  
  func start(on queue: DispatchQueue?, handler: @escaping (ViewUpdate) -> Void) {
    fatalError()
  }
  
  func dispatch<T>(_ action: T) where T : Action {
    fatalError()
  }
}

open class Driver<ModuleOutput, ViewUpdate>: DriverProtocol {
  
  private let dispatcher: DispatcherProtocol
  private let module: AnyModule<ModuleOutput>
  private var stateSubscription: SubscriptionProtocol?
  
  private var updateHandler: ((ViewUpdate) -> Void)?
  
  public init(dispatcher: DispatcherProtocol, module: AnyModule<ModuleOutput>) {
    self.dispatcher = dispatcher
    self.module = module
  }
  
  public func start(on queue: DispatchQueue?, handler: @escaping (ViewUpdate) -> Void) {
    updateHandler = handler
    stateSubscription = module.subscribe(on: queue) { [weak self] (state) in
      self?.update(with: state)
    }
    module.start(with: dispatcher)
  }
  
  public func dispatch<T>(_ action: T) where T : Action {
    dispatcher.dispatch(action)
  }
  
  open func update(with state: ModuleOutput) {
    // Subclasses should override.
  }
  
  open func emit(_ update: ViewUpdate) {
    updateHandler?(update)
  }
}
