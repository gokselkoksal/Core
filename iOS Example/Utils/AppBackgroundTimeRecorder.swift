//
//  AppBackgroundTimeRecorder.swift
//  DropLogic
//
//  Created by Göksel Köksal on 4.07.2019.
//  Copyright © 2019 Adaptics. All rights reserved.
//

import Foundation
import Core

public enum AppBackgroundTimeRecorderEvent: Equatable {
  case appInBackground
  case appInForeground(timePassedInBackground: TimeInterval)
}

public protocol AppBackgroundTimeRecorderProtocol {
  func start(_ handler: @escaping (AppBackgroundTimeRecorderEvent) -> Void)
  func stop()
}

// MARK: - Implementation

public final class AppBackgroundTimeRecorder: AppBackgroundTimeRecorderProtocol {
  
  private let clock: ClockProtocol
  private let notificationCenter: NotificationCenter
  private var timestamp: Date?
  private var handler: ((AppBackgroundTimeRecorderEvent) -> Void)?
  private let backgroundNotificationName: Notification.Name
  private let foregroundNotificationName: Notification.Name
  
  public init(clock: ClockProtocol,
              notificationCenter: NotificationCenter,
              backgroundNotificationName: Notification.Name,
              foregroundNotificationName: Notification.Name)
  {
    self.clock = clock
    self.notificationCenter = notificationCenter
    self.backgroundNotificationName = backgroundNotificationName
    self.foregroundNotificationName = foregroundNotificationName
  }
  
  deinit {
    self.notificationCenter.removeObserver(self)
  }
    
  public func start(_ handler: @escaping (AppBackgroundTimeRecorderEvent) -> Void) {
    self.handler = handler
    self.notificationCenter.addObserver(self, selector: #selector(appInBackground), name: backgroundNotificationName, object: nil)
    self.notificationCenter.addObserver(self, selector: #selector(appInForeground), name: foregroundNotificationName, object: nil)
  }
  
  public func stop() {
    self.notificationCenter.removeObserver(self)
    self.handler = nil
  }
  
  @objc private func appInBackground() {
    guard timestamp == nil else { return }
    timestamp = clock.now()
    handler?(.appInBackground)
  }
  
  @objc private func appInForeground() {
    guard let timestamp = self.timestamp else { return }
    self.timestamp = nil
    var timePassed = clock.now().timeIntervalSince(timestamp)
    timePassed = timePassed > 0 ? timePassed : 0
    handler?(.appInForeground(timePassedInBackground: timePassed))
  }
}
