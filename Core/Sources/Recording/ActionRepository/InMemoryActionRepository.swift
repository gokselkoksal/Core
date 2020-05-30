//
//  InMemoryActionRepository.swift
//  iOS Example
//
//  Created by Göksel Köksal on 1.06.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import Foundation

public final class InMemoryActionRepository: ActionRepositoryProtocol {
  
  private var records: [AnyActionRecord] = []
  
  public func add(record: AnyActionRecord) throws {
    records.append(record)
  }
  
  public func read() throws -> AnyIterator<AnyActionRecord> {
    return AnyIterator(records.makeIterator())
  }
  
  public func removeAll() throws {
    records.removeAll()
  }
}
