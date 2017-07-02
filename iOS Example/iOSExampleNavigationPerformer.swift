//
//  iOSExampleNavigationPerformer.swift
//  Core
//
//  Created by Göksel Köksal on 02/07/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit
import Core

extension NavigationPerformer where Self: UIViewController {
    
    func perform(_ navigation: Navigation) {
        guard let navigation = navigation as? BasicNavigation else { return }
        switch navigation {
        case .push(let destination, from: _):
            if let destination = destination as? LoginComponent {
                let vc = LoginViewController.instantiate(with: destination)
                navigationController?.pushViewController(vc, animated: true)
            }
        case .pop(_):
            navigationController?.popViewController(animated: true)
        default:
            // Not needed for now.
            break
        }
    }
}
