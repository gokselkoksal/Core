//
//  OTPViewController.swift
//  iOS Example
//
//  Created by Göksel Köksal on 02/07/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit
import Core

enum OTPViewUpdate: Equatable {
  case setLoading(Bool)
}

protocol OTPView {
  var driver: AnyDriver<OTPViewUpdate>! { get set }
}

// MARK: - Implementation

class OTPViewController: UIViewController, OTPView {
  
  @IBOutlet weak var phoneNumberField: UITextField!
  
  var driver: AnyDriver<OTPViewUpdate>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Login"
    phoneNumberField.text = "+90530999XXXX"
    
    driver.start(on: .main) { [weak self] (update) in
      self?.handleUpdate(update)
    }
  }
  
  @IBAction func sendOTPTapped(_ sender: UIButton) {
    guard let phoneNumber = phoneNumberField.text else { return }
    driver.dispatch(OTPAction.RequestOTP(phoneNumber: phoneNumber))
  }
  
  private func handleUpdate(_ update: OTPViewUpdate) {
    switch update {
    case .setLoading(let isLoading):
      UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
    }
  }
}
