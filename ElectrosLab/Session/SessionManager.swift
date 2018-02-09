//
//  SessionManager.swift
//  ElectrosLab
//
//  Created by Hussein Jaber on 6/2/18.
//  Copyright © 2018 Hussein Jaber. All rights reserved.
//

import Foundation

final class SessionManager {
    
}

final class Session: Codable {
    private var user: ELUser?
    private static var privateShared: Session?
    private static var isSetup: Bool = false
    private static let sessionSetupHelper = SessionSetupHelper()
    
    static func shared() -> Session {
        guard let myShared = privateShared else {
            privateShared = Session()
            return privateShared!
        }
        return myShared
    }
    
    static func destroy() {
        isSetup = false
        privateShared = nil
    }
    
    deinit {
        printD("session destroyed")
    }
    
    fileprivate static func setupSessionWithUser(user: ELUser) {
        self.sessionSetupHelper.user = user
        isSetup = true
    }
    
    static func getCurrentUser() -> ELUser? {
        if isSetup {
            if let user = shared().user {
                return user
            }
        }
        return nil
    }
    
    static func setCurrentUser(user: ELUser) {
        if isSetup {
            shared().user = user
        }
    }
    
    private init() {
        if let user = Session.sessionSetupHelper.user {
            self.user = user
        }
    }
    
    
}

private class SessionSetupHelper: Codable {
    var user: ELUser?
}
