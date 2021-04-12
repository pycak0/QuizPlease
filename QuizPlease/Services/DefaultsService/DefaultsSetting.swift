//
//  DefaultsSetting.swift
//  QuizPlease
//
//  Created by Владислав on 12.04.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

//MARK:- Defaults Manager Refactoring



//MARK:- 1. Setting Protocol
protocol DefaultsSetting {
    associatedtype Object: Codable
    
    var key: String { get }
    var defaults: UserDefaults { get }
    
    init(defaults: UserDefaults)
    
    func save(_ object: Object)
    func get() -> Object?
    func remove()
}


//MARK:- 2. Default Implementations
extension DefaultsSetting {
    func save(_ object: Object) {
        do {
            let data = try JSONEncoder().encode(object)
            defaults.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    
    func get() -> Object? {
        if let data = defaults.data(forKey: key),
           let object = try? JSONDecoder().decode(Object.self, from: data) {
            return object
        }
        return nil
    }
    
    func remove() {
        defaults.removeObject(forKey: key)
    }
}

//MARK:- 3. Array Extension
protocol DefaultsArraySetting: DefaultsSetting {
    func getArray() -> [Object]?
    func removeAll()
    func remove(object: Object)
}


//MARK:- 4. Setting Implementation
struct UserAuthInfoSetting: DefaultsSetting {
    typealias Object = SavedAuthInfo
    
    let defaults: UserDefaults
    
    var key: String {
        "user-auth-info"
    }
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }
}


//MARK:- 5. Managing class
class DefaultsService {
    private static let defaults = UserDefaults.standard
    static let userAuthInfo = UserAuthInfoSetting(defaults: defaults)
}

//MARK:- Usage example
class A {
    func foo() {
        _ = DefaultsService.userAuthInfo.get()
    }
}
