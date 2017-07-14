//
//  HomeViewController.swift
//  Core
//
//  Created by Goksel Koksal on 14/07/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit
import Core

class HomeViewController: UIViewController {
    
    var component: HomeComponent!
    
    static func instantiate(with component: HomeComponent) -> HomeViewController {
        let vc = HomeViewController()
        vc.component = component
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .white
        let logoutButton = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )
        navigationItem.leftBarButtonItem = logoutButton
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        component.subscribe(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        component.unsubscribe(self)
        
    }
    
    @objc private func logoutTapped() {
        core.dispatch(HomeNavigatorAction.logout)
    }
}

extension HomeViewController: Subscriber {
    
    func update(with state: HomeState) {
        // Update...
    }
}
