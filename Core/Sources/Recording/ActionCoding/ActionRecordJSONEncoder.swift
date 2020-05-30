//
//  ActionRecordJSONEncoder.swift
//  iOS Example
//
//  Created by Göksel Köksal on 1.06.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import Foundation

public protocol ActionRecordJSONEncoderProtocol {
  func encode(record: AnyActionRecord) throws -> [String: Any]
}

public final class ActionRecordJSONEncoder<T: CodableAction>: ActionRecordJSONEncoderProtocol {
  
  public enum Error: Swift.Error {
    case typeMismatch(expected: String, actual: String)
    case invalidJSONObject(Any)
  }
  
  private let encoder: JSONEncoder
  
  public init(encoder: JSONEncoder = JSONEncoder()) {
    self.encoder = encoder
  }
  
  public func encode(record: AnyActionRecord) throws -> [String : Any] {
    guard record.type == T.type, let action = record.action as? T else {
      throw Error.typeMismatch(expected: T.type, actual: record.type)
    }
    let record = ActionRecord<T>(elapsed: record.elapsed, type: record.type, action: action)
    let data = try encoder.encode(record)
    let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
    guard let json = jsonObject as? [String: Any] else {
      throw Error.invalidJSONObject(jsonObject)
    }
    return json
  }
}
