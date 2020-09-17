//
//  SignInViewController.swift
//  SignIn
//
//  Created by Jaesung Lee on 2020/09/15.
//

import UIKit
import SendBirdCalls

class SignInViewController: UIViewController {
    @IBOutlet weak var userIDTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    let indicator = UIActivityIndicatorView(style: .large)
    
    @IBAction func didTapSignIn() {
        guard let userID = userIDTextField.text?.trimmingCharacters(in: .whitespaces) else { return }

        // indicator.startAnimating()
        
        // authenticate
        let authParams = AuthenticateParams(userId: userID, accessToken: nil)
        
        SendBirdCall.authenticate(with: authParams) { (user, error) in
            DispatchQueue.main.async { [self] in
                self.indicator.stopAnimating()
            }
            
            guard user != nil else {
                // Failed
                print(error?.localizedDescription ?? CredentialErrors.unknown.localizedDescription)
                return
            }
            
            // create credential object with updated information
            let credential = Credential(accessToken: nil)
            let credentialManager = CredentialManager.shared
            credentialManager.updateCredential(credential)
            
            DispatchQueue.main.async { [self] in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
