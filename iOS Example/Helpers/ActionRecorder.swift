//
//  ActionRecorder.swift
//  iOS Example
//
//  Created by Göksel Köksal on 24.05.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import Foundation
import Core

protocol AppAction: Core.Action, Codable { }

private extension Action {
  static var type: String {
    return String(reflecting: self)
    .components(separatedBy: ".")
    .dropFirst()
    .joined(separator: ".")
  }
}

struct ActionRecord<T: AppAction>: Codable {
  
  let elapsed: TimeInterval
  let type: String
  let action: T
  
  func eraseToAny() -> AnyActionRecord {
    return AnyActionRecord(elapsed: elapsed, type: type, action: action)
  }
}

struct AnyActionRecord {
  let elapsed: TimeInterval
  let type: String
  let action: AppAction
}

final class ActionRecoder {
  
  private let clock: ClockProtocol
  private let createdAt: Date
  private let repository: ActionRepositoryProtocol
  private var coderMap: [String: ActionCoder] = [:]
  
  init(repository: ActionRepositoryProtocol, clock: ClockProtocol) {
    self.repository = repository
    self.clock = clock
    self.createdAt = clock.now()
  }
  
  func record<T: AppAction>(_ action: T) throws {
    let type = T.type
    if coderMap.keys.contains(type) == false {
      coderMap[type] = CodableActionCoder<T>()
    }
    let coder: ActionCoder
    if let cachedCoder = coderMap[type] {
      coder = cachedCoder
    } else {
      coder = CodableActionCoder<T>()
      coderMap[type] = coder
    }
    
    let elapsed = clock.now().timeIntervalSince(createdAt)
    let actionData = try coder.encode(action: action, elapsed: elapsed)
    try repository.add(actionData)
  }
  
  func read() throws -> [AppAction] {
    let actionDataList = try repository.read()
    let actions: [AppAction] = actionDataList.compactMap { actionData in
      for (_, coder) in coderMap {
        do {
          let action = try coder.decode(actionData: actionData)
          return action
        } catch {
          continue
        }
      }
      return nil
    }
    return actions
  }
  
  func debug() {
    print("RECORDED ACTIONS\n", try! repository.read())
  }
}

protocol ActionRepositoryProtocol {
  func add(_ actionData: Data) throws
  func read() throws -> [Data]
  func removeAll() throws
}

final class InMemoryActionRepository: ActionRepositoryProtocol {
  
  private var actionDataList: [Data] = []
  
  func add(_ action: Data) throws {
    actionDataList.append(action)
  }
  
  func read() throws -> [Data] {
    return actionDataList
  }
  
  func removeAll() throws {
    actionDataList.removeAll()
  }
}

// MARK: - Action coders

protocol ActionDecoder {
  func decode(actionData: Data) throws -> AppAction
}

protocol ActionEncoder {
  func encode(action: AppAction, elapsed: TimeInterval) throws -> Data
}

typealias ActionCoder = ActionEncoder & ActionDecoder

final class CodableActionCoder<T: AppAction>: ActionCoder {
  
  enum Error: Swift.Error {
    case cannotEncode
    case cannotDecode
  }
  
  init() { }
  
  private let decoder = JSONDecoder()
  private let encoder = JSONEncoder()
  
  func encode(action: AppAction, elapsed: TimeInterval) throws -> Data {
    guard let action = action as? T else { throw Error.cannotEncode }
    let record = ActionRecord<T>(elapsed: elapsed, type: T.type, action: action)
    return try encoder.encode(record)
  }
  
  func decode(actionData: Data) throws -> AppAction {
    let record = try decoder.decode(ActionRecord<T>.self, from: actionData)
    guard record.type == T.type else {
      throw Error.cannotDecode
    }
    return record.action
  }
}
