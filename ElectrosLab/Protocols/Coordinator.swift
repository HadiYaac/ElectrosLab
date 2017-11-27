//
//  Coordinator.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 27/11/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import Foundation
///A coordinator is an object that bosses one or more view controllers around. Taking all of the driving logic out of your view controllers, and moving that stuff one layer up is gonna make your life a lot more awesome.
protocol Coordinator: class {
    ///if you want to run a new flow you need to create a Coordinator using a factory and call start().
    func start()
    ///if you want to run a new flow with deeplink info you need to create a Coordinator using a factory and call start(with option: DeepLinkOption?).
    //func start(with option: DeepLinkOption?)
    //func startWithController(_ controller: SelectedController?)
}
