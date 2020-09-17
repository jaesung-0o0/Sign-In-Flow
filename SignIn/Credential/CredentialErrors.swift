//
//  CredentialErrors.swift
//  SignIn
//
//  Created by Jaesung Lee on 2020/09/17.
//

import Foundation

enum CredentialErrors: String, Error {
    case empty = "There is no stored credential"
    case unknown = "Unknown error"
    case invalidURL = "URL is invalid"
    case alreadyAuthenticated = "Already signed in. Please sign out current account."
    
    var localizedDescription: String { self.rawValue }
}
