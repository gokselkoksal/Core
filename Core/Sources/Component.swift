//
//  Component.swift
//  Core
//
//  Created by Göksel Köksal on 22/05/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

public protocol ComponentProtocol: Subscribable where Value == StateType {
  associatedtype StateType: State
  
  var state: StateType { get }
  func start(with dispatcher: Dispatcher)
}

open class Component<StateType: State>: ComponentProtocol {
  
  public private(set) var state: StateType
  
  private let subscriptionStore = SubscriptionStore<StateType>()
  private let actionQueue: DispatchQueue?
  private var actionSubscription: SubscriptionProtocol?
  
  public init(state: StateType, actionQueue: DispatchQueue? = nil) {
    self.state = state
    self.actionQueue = actionQueue
  }
  
  public func start(with dispatcher: Dispatcher) {
    actionSubscription = dispatcher.subscribe(on: actionQueue, handler: { [weak self] (action) in
      self?.process(action)
    })
  }
  
  open func process(_ action: Action) {
    // Should be implemented by subclasses. Does nothing by default.
  }
  
  public final func subscribe(on queue: DispatchQueue?, id: String, handler: @escaping (StateType) -> Void) -> SubscriptionProtocol {
    return subscriptionStore.subscribe(on: queue, id: id, handler: handler)
  }
  
  public final func commit(_ newState: StateType) {
    state = newState
    subscriptionStore.send(state)
  }
}

// MARK: - AnyComponent<T>

public extension ComponentProtocol {
  func eraseToAny() -> AnyComponent<StateType> {
    return AnyComponent(self)
  }
}

public final class AnyComponent<StateType: State>: ComponentProtocol {
  
  private let component: AnyComponentBase<StateType>
  
  public var state: StateType {
    return component.state
  }
  
  public init<T: ComponentProtocol>(_ component: T) where T.StateType == StateType {
    self.component = AnyComponentBox(component)
  }
  
  public func start(with dispatcher: Dispatcher) {
    component.start(with: dispatcher)
  }
  
  public func subscribe(on queue: DispatchQueue?, id: String, handler: @escaping (StateType) -> Void) -> SubscriptionProtocol {
    component.subscribe(on: queue, id: id, handler: handler)
  }
}

private final class AnyComponentBox<T: ComponentProtocol>: AnyComponentBase<T.StateType> {
  
  private let component: T
  
  override var state: T.StateType {
    return component.state
  }
  
  init(_ component: T) {
    self.component = component
  }
  
  override func start(with dispatcher: Dispatcher) {
    component.start(with: dispatcher)
  }
  
  override func subscribe(on queue: DispatchQueue?, id: String, handler: @escaping (StateType) -> Void) -> SubscriptionProtocol {
    component.subscribe(on: queue, id: id, handler: handler)
  }
}

private class AnyComponentBase<StateType: State>: ComponentProtocol {
  
  var state: StateType {
    fatalError()
  }
  
  func start(with dispatcher: Dispatcher) {
    fatalError()
  }
  
  func subscribe(on queue: DispatchQueue?, id: String, handler: @escaping (StateType) -> Void) -> SubscriptionProtocol {
    fatalError()
  }
}
