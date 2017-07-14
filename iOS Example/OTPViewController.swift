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
    
    var component: OTPComponent! = core.navigationTree.root.value as! OTPComponent
 
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "OTP"
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
        core.dispatch(component.commandToRequestOTP(withPhoneNumber: phoneNumber))
    }
}

extension OTPViewController: Subscriber {
    
    func update(with state: OTPState) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = state.isLoading
        if let error = state.error {
            print(error) // TODO: Alert.
        }
    }
}
