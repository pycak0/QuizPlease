//
//  Utilities.swift
//  QuizPlease
//
//  Created by Владислав on 09.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

class Utilities {
    private init() {}
    
    static let main = Utilities()
    
    ///Gets saved user auth info from UserDefaults, checks token expire date. If needed, updates token and assignes a new token value in Globals
    func updateToken(completion: (() -> Void)? = nil) {
        if let info = DefaultsManager.shared.getUserAuthInfo(),
           let expireDate = info.expireDate,
           let refreshToken = info.refreshToken {
            if Date() >= expireDate {
                print("Token is out of date. Updating ...")
                NetworkService.shared.updateToken(with: refreshToken) { (serverResult) in
                    switch serverResult {
                    case let .failure(error):
                        print("Error updating user token: \n\(error).\nAssigning nil to the 'Globals' token variable.")
                        Globals.userToken = nil
                        
                    case let .success(newAuthInfo):
                        Globals.userToken = newAuthInfo.accessToken
                        DefaultsManager.shared.saveAuthInfo(newAuthInfo)
                        print("\n\n>>>> Updated user token. New user info:\n \(newAuthInfo)\n\n")
                    }
                    completion?()
                }
            } else {
                Globals.userToken = info.accessToken
                print(">>>> Token is still valid. Saved User Info:\n \(info)\n\n")
                completion?()
            }
            
        }
    }
    
    func updateDefaultCity() {
        if let city = DefaultsManager.shared.getDefaultCity() {
            Globals.defaultCity = city
        }
    }
}
