//
//  CoordinatorFactory.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 27/11/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import UIKit

protocol CoordinatorFactory {
    func makeAuthCoordinator(router: Router) -> Coordinator & AuthCoordinatorOutput
    func makeTabbarCoordinator() -> (configurator: Coordinator, toPresent: Presentable?)
}
