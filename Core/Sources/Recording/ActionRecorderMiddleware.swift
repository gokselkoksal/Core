//
//  ActionRecorderMiddleware.swift
//  iOS Example
//
//  Created by Göksel Köksal on 31.05.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import Foundation

open class ActionRecorderMiddleware: Middleware {
  
  private let clock: ClockProtocol
  private let createdAt: Date
  private let repository: ActionRepositoryProtocol
  
  public init(repository: ActionRepositoryProtocol, clock: ClockProtocol) {
    self.repository = repository
    self.clock = clock
    self.createdAt = clock.now()
  }
  
  open func overrideDispatch(_ dispatch: @escaping DispatchFunction) -> DispatchFunction {
    return { [weak self] action in
      guard let self = self else { return }
      dispatch(action)
      if let action = action as? CodableAction {
        try? self.record(action)
      }
    }
  }
  
  private func record(_ action: CodableAction) throws {
    let elapsed = clock.now().timeIntervalSince(createdAt)
    let record = AnyActionRecord(elapsed: elapsed, type: type(of: action).type, action: action)
    try repository.add(record: record)
  }
}
