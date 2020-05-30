//
//  ActionRecordJSONDecoder.swift
//  iOS Example
//
//  Created by Göksel Köksal on 1.06.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import Foundation

public protocol CodableActionRegistryProtocol {
  func register<T: CodableAction>(_ actionType: T.Type)
}

public protocol ActionRecordJSONDecoderProtocol {
  func decode(recordJSON: [String: Any]) throws -> AnyActionRecord
}

public final class ActionRecordJSONDecoder: ActionRecordJSONDecoderProtocol, CodableActionRegistryProtocol {
  
  public enum Error: Swift.Error {
    case corruptedJSON([String: Any])
    case couldNotFindRegisteredDecoder(type: String)
  }
  
  private let decoder: JSONDecoder
  private var actionRecordDataDecoderMap: [String: ActionRecordDataDecoderProtocol] = [:]
  
  public init(decoder: JSONDecoder = JSONDecoder()) {
    self.decoder = decoder
  }
  
  public func register<T: CodableAction>(_ actionType: T.Type) {
    actionRecordDataDecoderMap[T.type] = ActionRecordDataDecoder<T>(decoder: decoder)
  }
  
  public func decode(recordJSON: [String : Any]) throws -> AnyActionRecord {
    guard let type = recordJSON["type"] as? String else {
      throw Error.corruptedJSON(recordJSON)
    }
    guard let actionRecordDataDecoder = actionRecordDataDecoderMap[type] else {
      throw Error.couldNotFindRegisteredDecoder(type: type)
    }
    let recordData = try JSONSerialization.data(withJSONObject: recordJSON, options: [])
    return try actionRecordDataDecoder.decode(recordData)
  }
}

// MARK: - Helpers

private protocol ActionRecordDataDecoderProtocol {
  func decode(_ data: Data) throws -> AnyActionRecord
}

private final class ActionRecordDataDecoder<T: CodableAction>: ActionRecordDataDecoderProtocol {
  
  private let decoder: JSONDecoder
  
  init(decoder: JSONDecoder = JSONDecoder()) {
    self.decoder = decoder
  }
  
  func decode(_ data: Data) throws -> AnyActionRecord {
    let actionRecord = try decoder.decode(ActionRecord<T>.self, from: data)
    return actionRecord.eraseToAny()
  }
}
