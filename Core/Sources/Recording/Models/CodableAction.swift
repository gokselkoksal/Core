//
//  CodableAction.swift
//  iOS Example
//
//  Created by Göksel Köksal on 30.05.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import Foundation

public protocol CodableAction: Action, Codable {
  static var type: String { get }
}

public extension CodableAction {
  static var type: String {
    return String(reflecting: self)
    .components(separatedBy: ".")
    .dropFirst()
    .joined(separator: ".")
  }
}
