//
//  OTPViewController.swift
//  iOS Example
//
//  Created by Göksel Köksal on 02/07/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit
import Core

class OTPViewController: UIViewController {
  
  @IBOutlet weak var phoneNumberField: UITextField!
  
  var dispatcher: Dispatcher!
  var component: AnyComponent<OTPState>!
  private var stateSubscription: SubscriptionProtocol?
  
  static func instantiate(with dispatcher: Dispatcher, component: AnyComponent<OTPState>) -> OTPViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! OTPViewController
    vc.dispatcher = dispatcher
    vc.component = component
    return vc
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Login"
    phoneNumberField.text = "+90530999XXXX"
    
    component.start(with: dispatcher)
    stateSubscription = component.subscribe { [weak self] (state) in
      self?.update(with: state)
    }
  }
  
  @IBAction func sendOTPTapped(_ sender: UIButton) {
    guard let phoneNumber = phoneNumberField.text else { return }
    dispatcher.dispatch(OTPAction.requestOTP(phoneNumber: phoneNumber))
  }
  
  func update(with state: OTPState) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = state.isLoading
    if let result = state.result {
      switch result {
      case .failure(let error):
        print(error) // TODO: Alert.
      default:
        break
      }
    }
  }
}
