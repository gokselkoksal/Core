//
//  HomeDriver.swift
//  iOS Example
//
//  Created by Göksel Köksal on 14.05.2020.
//  Copyright © 2020 GK. All rights reserved.
//

import Foundation
import Core

final class HomeDriver: Driver<HomeState, HomeViewUpdate> {
  override func update(with state: HomeState) {
    emit(.noop)
  }
}
