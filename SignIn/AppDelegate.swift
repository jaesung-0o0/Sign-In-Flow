//
//  AppDelegate.swift
//  SignIn
//
//  Created by Jaesung Lee on 2020/09/15.
//

import UIKit
import SendBirdCalls

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        SendBirdCall.configure(appId: "8FFA9EB5-F1C5-4DAA-AC57-254D07990FD0")
        
        self.autoSignIn { error in
            guard let error = error else { return }
            print(error.localizedDescription)
            self.window?.rootViewController?.showSignInVC()
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        guard SendBirdCall.currentUser == nil else {
            print(CredentialErrors.alreadyAuthenticated.localizedDescription)
            return false
        }
        
        do {
            let pendingCredential = try CredentialManager.shared.handle(url: url)
            self.authenticate(with: pendingCredential) { error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let signInVC = self.window?.rootViewController?.presentedViewController as? SignInViewController else { return }
                signInVC.dismiss(animated: true, completion: nil)
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        return true
    }
    
    func autoSignIn(completionHandler: @escaping (Error?) -> Void) {
        // fetch credential
        guard let pendingCredential = UserDefaults.standard.credential else {
            DispatchQueue.main.async {
                completionHandler(CredentialErrors.empty)
            }
            return
        }
        // authenticate
        self.authenticate(with: pendingCredential, completionHandler: completionHandler)
    }
    
    func authenticate(with credential: Credential, completionHandler: @escaping (Error?) -> Void) {
        SendBirdCall.configure(appId: credential.appID)
        let authParams = AuthenticateParams(userId: credential.userID, accessToken: credential.accessToken)
        SendBirdCall.authenticate(with: authParams) { (user, error) in
            guard user != nil else {
                DispatchQueue.main.async {
                    completionHandler(error ?? CredentialErrors.unknown)
                }
                return
            }
            let credential = Credential(accessToken: credential.accessToken)
            let credentialManager = CredentialManager.shared
            credentialManager.updateCredential(credential)
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
}

extension UIViewController {
    func showSignInVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signInVC = storyboard.instantiateViewController(identifier: "SignInViewController")
        self.present(signInVC, animated: true, completion: nil)
    }
}
