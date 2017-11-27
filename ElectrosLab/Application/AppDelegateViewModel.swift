//
//  AppDelegateViewModel.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 27/11/17.
//  Copyright © 2017 Hussein Jaber. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Firebase

final class AppDelegateViewModel: NSObject {
    var window: UIWindow?
    let disposeBag = DisposeBag()
    weak var applicationCoordinator: Coordinator?
    
    init(applicationCoordinator: Coordinator, window: UIWindow?) {
        self.window = window
        self.applicationCoordinator = applicationCoordinator
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        applicationCoordinator?.start()
        //window?.tintColor = .blue
        return true
    }
    
}
