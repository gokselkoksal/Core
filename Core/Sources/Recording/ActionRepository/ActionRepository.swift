//
//  ActionRepository.swift
//  iOS Example
//
//  Created by Göksel Köksal on 30.05.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import Foundation

public protocol ActionRepositoryProtocol {
  func add(record: AnyActionRecord) throws
  func read() throws -> AnyIterator<AnyActionRecord>
  func removeAll() throws
}
