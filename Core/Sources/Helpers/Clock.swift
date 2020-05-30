//
//  ActionRecorderMiddleware.swift
//  iOS Example
//
//  Created by Göksel Köksal on 31.05.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import Foundation

public protocol ClockProtocol {
  func now() -> Date
}

// MARK: - Implementation

public class Clock: ClockProtocol {
  
  public static let shared = Clock()
  
  public func now() -> Date {
    return Date()
  }
}

// MARK: - Mock

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
