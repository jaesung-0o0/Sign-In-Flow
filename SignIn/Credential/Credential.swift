//
//  Credential.swift
//  SignIn
//
//  Created by Jaesung Lee on 2020/09/15.
//

import Foundation
import SendBirdCalls

struct Credential: Codable {
    let appID: String
    let userID: String
    let accessToken: String?
    let name: String?
    let profileURL: String?
    
    enum Keys: String, CodingKey {
        case appID = "app_id"
        case userID = "user_id"
        case accessToken = "access_token"
        case name = "name"
        case profileURL = "profile_url"
    }
    
    init(accessToken: String?) {
        self.init(appID: SendBirdCall.appId ?? "",
                  userID: SendBirdCall.currentUser?.userId ?? "",
                  accessToken: accessToken,
                  name: SendBirdCall.currentUser?.nickname,
                  profileURL: SendBirdCall.currentUser?.profileURL)
    }
    
    init(appID: String, userID: String, accessToken: String?, name: String? = nil, profileURL: String? = nil) {
        self.appID = appID
        self.userID = userID
        self.accessToken = accessToken
        self.name = name
        self.profileURL = profileURL
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Credential.Keys.self)
        
        self.appID = try container.decode(String.self, forKey: .appID)
        self.userID = try container.decode(String.self, forKey: .userID)
        self.accessToken = try? container.decode(String.self, forKey: .accessToken)
        self.name = try? container.decode(String.self, forKey: .name)
        self.profileURL = try? container.decode(String.self, forKey: .profileURL)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Credential.Keys.self)
        
        try container.encode(self.appID, forKey: .appID)
        try container.encode(self.userID, forKey: .userID)
        try? container.encode(self.accessToken, forKey: .accessToken)
        try? container.encode(self.name, forKey: .name)
        try? container.encode(self.profileURL, forKey: .profileURL)
    }
}
