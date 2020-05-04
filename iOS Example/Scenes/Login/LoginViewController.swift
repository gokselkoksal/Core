//
//  LoginViewController.swift
//  Core
//
//  Created by Göksel Köksal on 02/07/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit
import Core

class LoginViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var otpTextField: UITextField!
    
    var component: LoginComponent!
    var timer: Timer?
    
    static func instantiate(with component: LoginComponent) -> LoginViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! LoginViewController
        vc.component = component
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        core.dispatch(LoginAction.tick) // Activate with first tick.
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            core.dispatch(LoginAction.tick)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        component.subscribe(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        component.unsubscribe(self)
        timer?.invalidate()
        timer = nil
    }

    @IBAction func submitTapped(_ sender: UIButton) {
        guard let code = otpTextField.text else { return }
        core.dispatch(LoginAction.verifyOTP(code))
    }
}

extension LoginViewController: Subscriber {
    
    func update(with state: LoginState) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = state.isLoading
        
        switch state.timerStatus {
        case .idle:
            timerLabel.isHidden = true
        case .active(seconds: let seconds):
            timerLabel.isHidden = false
            timerLabel.text = "\(UInt(seconds)) seconds remaning..."
        case .finished:
            timer?.invalidate()
            timer = nil
            timerLabel.isHidden = true
        }
        
        if let result = state.result {
            switch result {
            case .success():
                print("Success!") // TODO: Replace with navigator action.
            case .failure(let error):
                print("Failure! \(error)") // TODO: Alert.
            }
        }
    }
}
