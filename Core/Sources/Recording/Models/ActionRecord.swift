//
//  ActionRecord.swift
//  iOS Example
//
//  Created by Göksel Köksal on 30.05.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import Foundation

public struct ActionRecord<T: CodableAction>: Codable {
  
  public let elapsed: TimeInterval
  public let type: String
  public let action: T
  
  public init(elapsed: TimeInterval, type: String, action: T) {
    self.elapsed = elapsed
    self.type = type
    self.action = action
  }
}

// MARK: - Type-erased

public struct AnyActionRecord {
  
  public let elapsed: TimeInterval
  public let type: String
  public let action: CodableAction
  
  public init(elapsed: TimeInterval, type: String, action: CodableAction) {
    self.elapsed = elapsed
    self.type = type
    self.action = action
  }
}

// MARK: - Convenience

extension AnyActionRecord: CustomStringConvertible {
  public var description: String {
    return """
    { elapsed: \(String(format: "%.1f", elapsed)), type: \(type), action: \(action) }
    """
  }
}

public extension ActionRecord {
  func eraseToAny() -> AnyActionRecord {
    return AnyActionRecord(elapsed: elapsed, type: type, action: action)
  }
}
