//
//  UserDefaults.Credential.swift
//  SignIn
//
//  Created by Jaesung Lee on 2020/09/16.
//

import Foundation

extension UserDefaults {
    enum Key: String, CaseIterable {
        case credential
        case voipPushToken
        
        var value: String { "com.sendbird.calls.quickstart.\(self.rawValue.lowercased())" }
    }
    
}

extension UserDefaults {
    var credential: Credential? {
        get { UserDefaults.standard.get(objectType: Credential.self,
                                        forKey: Key.credential.value) }
        set { UserDefaults.standard.set(object: newValue,
                                        forKey: Key.credential.value) }
    }
    
    var voipPushToken: Data? {
        get { UserDefaults.standard.value(forKey: Key.voipPushToken.value) as? Data }
        set { UserDefaults.standard.set(newValue, forKey: Key.voipPushToken.value) }
    }
}

extension UserDefaults {
    func clear() {
        let keys = Key.allCases.filter { $0 != .voipPushToken }
        keys.map { $0.value }.forEach(UserDefaults.standard.removeObject)
    }
}

extension UserDefaults {
    func set<T: Codable>(object: T, forKey: String) {
        guard let jsonData = try? JSONEncoder().encode(object) else {
            self.removeObject(forKey: forKey)
            return
        }
        self.set(jsonData, forKey: forKey)
    }
    
    func get<T: Codable>(objectType: T.Type, forKey: String) -> T? {
        guard let result = value(forKey: forKey) as? Data else { return nil }
        return try? JSONDecoder().decode(objectType, from: result)
    }
}
