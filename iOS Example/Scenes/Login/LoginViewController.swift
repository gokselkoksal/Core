//
//  LoginViewController.swift
//  Core
//
//  Created by Göksel Köksal on 02/07/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit
import Core

enum LoginViewUpdate {
  case setLoading(Bool)
  case updateTimer(TimerStatus)
}

protocol LoginView {
  var driver: AnyDriver<LoginViewUpdate>! { get set }
}

// MARK: Implementation

class LoginViewController: UIViewController, LoginView {
  
  @IBOutlet weak var timerLabel: UILabel!
  @IBOutlet weak var otpTextField: UITextField!
  
  var driver: AnyDriver<LoginViewUpdate>!
  
  static func instantiate(with driver: AnyDriver<LoginViewUpdate>!) -> LoginViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! LoginViewController
    vc.driver = driver
    return vc
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Login"
    
    driver.start(on: .main) { [weak self] (update) in
      self?.handleUpdate(update)
    }
  }
  
  @IBAction func submitTapped(_ sender: UIButton) {
    guard let code = otpTextField.text else { return }
    driver.dispatch(LoginAction.verifyOTP(code))
  }
  
  private func handleUpdate(_ update: LoginViewUpdate) {
    switch update {
    case .setLoading(let isLoading):
      UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
    case .updateTimer(let timerStatus):
      switch timerStatus {
      case .idle:
        timerLabel.isHidden = true
      case .active(remaining: let remaining, interval: _):
        timerLabel.isHidden = false
        timerLabel.text = "\(UInt(remaining)) seconds remaning..."
      case .finished:
        timerLabel.isHidden = true
      }
    }
  }
}
