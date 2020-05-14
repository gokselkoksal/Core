//
//  Clock.swift
//  DropLogic
//
//  Created by Goksel Koksal on 19/11/2018.
//  Copyright © 2018 Adaptics. All rights reserved.
//

import Foundation

public protocol ClockProtocol {
  func now() -> Date
}

public class Clock: ClockProtocol {
  
  public static let shared = Clock()
  
  public func now() -> Date {
    return Date()
  }
}

public class MockClock: ClockProtocol {
  
  public var date: Date
  
  public init(date: Date = Date()) {
    self.date = date
  }
  
  public func now() -> Date {
    return date
  }
  
  public func timetravel(by interval: TimeInterval) {
    self.date += interval
  }
}

