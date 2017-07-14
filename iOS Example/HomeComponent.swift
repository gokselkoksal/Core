//
//  HomeComponent.swift
//  Core
//
//  Created by Goksel Koksal on 14/07/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation
import Core

enum HomeNavigatorAction: NavigatorAction {
    case logout
}

struct HomeState: State { }

class HomeComponent: Component<HomeState> {
    
    init() {
        super.init(state: HomeState())
    }
    
    override func process(_ action: Action) {
        if let navigatorAction = action as? HomeNavigatorAction {
            switch navigatorAction {
            case .logout:
                let login = self.parent!
                let otp = login.parent!
                commit(BasicNavigation.pop([login, otp]))
                return
            }
        }
    }
}
