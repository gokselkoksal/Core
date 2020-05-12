//
//  ActionSubscription.swift
//  Core
//
//  Created by Göksel Köksal on 12.05.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import Foundation

public protocol Disposable {
  func dispose()
}

public protocol SubscriptionProtocol: Disposable {
  var id: String { get }
  var isActive: Bool { get }
  func cancel()
}

extension SubscriptionProtocol {
  public func dispose() {
    cancel()
  }
}

final class Subscription<Value>: SubscriptionProtocol {
  
  let id: String
  
  private let queue: DispatchQueue?
  private let handler: (Value) -> Void
  private var isActiveBox: Atomic<Bool> = Atomic(true)
  
  var isActive: Bool {
    return isActiveBox.value
  }
  
  init(id: String, queue: DispatchQueue?, handler: @escaping (Value) -> Void) {
    self.id = id
    self.queue = queue
    self.handler = handler
  }
  
  func cancel() {
    isActiveBox.value = false
  }
  
  func send(_ value: Value) {
    if let queue = queue {
      queue.async { [weak self] in
        guard let self = self else { return }
        
        if self.isActive {
          self.handler(value)
        }
      }
    } else {
      if isActive {
        handler(value)
      }
    }
  }
}

public protocol Subscribable {
  associatedtype Value
  
  func subscribe(
    on queue: DispatchQueue?,
    id: String,
    handler: @escaping (Value) -> Void) -> SubscriptionProtocol
}

extension Subscribable {
  
  public func subscribe(
    on queue: DispatchQueue? = nil,
    file: String = #file,
    line: UInt = #line,
    handler: @escaping (Value) -> Void) -> SubscriptionProtocol
  {
    let fileId = URL(string: file)?.lastPathComponent ?? file
    return subscribe(on: queue, id: "\(fileId):\(line)", handler: handler)
  }
}

final class SubscriptionStore<Value>: Subscribable {
  
  private var subscriptions: Atomic<WeakArray<Subscription<Value>>> = Atomic(WeakArray())
  
  func subscribe(
    on queue: DispatchQueue? = nil,
    id: String,
    handler: @escaping (Value) -> Void) -> SubscriptionProtocol
  {
    let subscription = Subscription<Value>(id: id, queue: queue, handler: handler)
    subscriptions.asyncWrite { (subs) in
      subs.append(subscription)
    }
    return subscription
  }
  
  public func subscribe(
    on queue: DispatchQueue? = nil,
    file: String = #file,
    line: UInt = #line,
    handler: @escaping (Value) -> Void) -> SubscriptionProtocol
  {
    let fileId = URL(string: file)?.lastPathComponent ?? file
    return subscribe(on: queue, id: "\(fileId):\(line)", handler: handler)
  }
  
  func send(_ value: Value) {
    subscriptions.syncWrite { (subs) in
      subs.compact()
      subs.weakElements.forEach({ $0.value?.send(value) })
    }
  }
  
  func purge() {
    subscriptions.asyncWrite({ $0.compact() })
  }
}
