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
import UserNotifications

import IQKeyboardManagerSwift
import GoogleMaps

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
        Messaging.messaging().subscribe(toTopic: "all")
        GMSServices.provideAPIKey("AIzaSyAc1M8vz0ZjPFOVjzy--QDiG1gi9kiVE4g")
        applicationCoordinator?.start()
        UIApplication.shared.statusBarStyle = .lightContent
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        UINavigationBar.appearance().barTintColor = UIColor.electrosLabBlue()
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = UIColor.white
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
        }

        application.registerForRemoteNotifications()
        application.applicationIconBadgeNumber = 0
        return true
    }
    
}
