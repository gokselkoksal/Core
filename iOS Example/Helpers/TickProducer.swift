//
//  TickProducer.swift
//  DropLogic
//
//  Created by Goksel Koksal on 20/05/2019.
//  Copyright © 2019 Adaptics. All rights reserved.
//

import Foundation

/// An abstraction on top of timers to produce ticks.
public protocol TickProducerProtocol: class {
  func setHandler(_ handler: (() -> Void)?)
  func start(interval: TimeInterval)
  func stop()
}

// MARK: - Implementation

public final class TickProducer: TickProducerProtocol {
  
  private enum Status {
    
    case idle
    case running(interval: TimeInterval)
    case paused(interval: TimeInterval)
    
    var isRunning: Bool {
      switch self {
      case .running:
        return true
      default:
        return false
      }
    }
  }
  
  private var handler: (() -> Void)?
  private var timer: Foundation.Timer?
  private var status: Status = .idle
  private let backgroundTimeRecorder: AppBackgroundTimeRecorderProtocol?
  
  public init(backgroundTimeRecorder: AppBackgroundTimeRecorderProtocol? = nil) {
    self.backgroundTimeRecorder = backgroundTimeRecorder
  }
  
  public func setHandler(_ handler: (() -> Void)?) {
    self.handler = handler
  }
  
  public func start(interval: TimeInterval) {
    guard status.isRunning == false else { return }
    
    backgroundTimeRecorder?.start { [weak self] (event) in
      self?.handleEvent(event)
    }
    
    let timer = Timer(timeInterval: interval, repeats: true) { [weak self] _ in
      self?.handler?()
    }
    // This is an effort to save power. This will tell the scheduling system:
    // "Look, I want this to run every second, but I don’t care if it’s x
    // seconds too late." The tolerance will never cause a timer to fire early,
    // only later. And the tolerance will neither cause a timer to "drift",
    // i.e. when one timer fire is too late, it won’t affect the scheduled time
    // of the next timer fire.
    timer.tolerance = 0.1
    // Using `Timer.scheduledTimer(...)` method adds the timer in the default
    // run loop, which can be busy with UI events at times. When it's busy (if
    // the user is scrolling like crazy, for example) timer ticks we receive
    // can get delayed (few seconds!) which is disastrous for an app like Drop.
    // That's why we create the timer manually and schedule it with common mode.
    // For more: https://learnappmaking.com/timer-swift-how-to/
    RunLoop.main.add(timer, forMode: .common)
    self.timer = timer
    self.status = .running(interval: interval)
  }
  
  public func stop() {
    timer?.invalidate()
    timer = nil
    status = .idle
    backgroundTimeRecorder?.stop()
  }
  
  private func handleEvent(_ event: AppBackgroundTimeRecorderEvent) {
    switch event {
    case .appInBackground:
      guard case .running(let interval) = status else { return }
      timer?.invalidate()
      timer = nil
      status = .paused(interval: interval)
    case .appInForeground(timePassedInBackground: let timePassed):
      guard case .paused(let interval) = status else { return }
      let tickCount = Int(timePassed / interval)
      for _ in 0..<tickCount {
        handler?()
      }
      start(interval: interval)
    }
  }
}

public final class MockTickProducer: TickProducerProtocol {
  
  public enum Event: Equatable {
    case start(interval: TimeInterval)
    case stop
  }
  
  private var handler: (() -> Void)?
  public private(set) var events: [Event] = []
  
  public init() { }
  
  public func setHandler(_ handler: (() -> Void)?) {
    self.handler = handler
  }
  
  public func start(interval: TimeInterval) {
    events.append(.start(interval: interval))
  }
  
  public func stop() {
    events.append(.stop)
  }
  
  public func resetEvents() {
    events.removeAll()
  }
  
  public func tick(times: Int = 1) {
    for _ in 0..<times {
      handler?()
    }
  }
}
