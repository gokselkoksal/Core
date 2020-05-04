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
    
    var component: OTPComponent! = core.navigationTree.root.value as? OTPComponent
 
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        phoneNumberField.text = "+90530999XXXX"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        component.subscribe(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        component.unsubscribe(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sendOTPTapped(_ sender: UIButton) {
        guard let phoneNumber = phoneNumberField.text else { return }
        core.dispatch(OTPAction.requestOTP(phoneNumber: phoneNumber))
    }
}

extension OTPViewController: Subscriber {
    
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
