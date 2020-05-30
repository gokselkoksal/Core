//
//  FileBasedActionRepository.swift
//  iOS Example
//
//  Created by Göksel Köksal on 1.06.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import Foundation

// TODO: Actually write to file here.

public final class FileBasedActionRepository: ActionRepositoryProtocol {
  
  private let decoder: ActionRecordJSONDecoderProtocol
  private var lines: [[String: Any]] = []
  
  public init(decoder: ActionRecordJSONDecoderProtocol) {
    self.decoder = decoder
  }
  
  public func add(record: AnyActionRecord) throws {
    let recordEncoder = record.action.makeRecordEncoder()
    let json = try recordEncoder.encode(record: record)
    lines.append(json)
  }
  
  public func read() throws -> AnyIterator<AnyActionRecord> {
    let decodedRecords = try self.lines.map { try decoder.decode(recordJSON: $0) }
    return AnyIterator(decodedRecords.makeIterator())
  }
  
  public func removeAll() throws {
    lines.removeAll()
  }
}

// MARK: - Helpers

private extension CodableAction {
  func makeRecordEncoder() -> ActionRecordJSONEncoderProtocol {
    return ActionRecordJSONEncoder<Self>()
  }
}
