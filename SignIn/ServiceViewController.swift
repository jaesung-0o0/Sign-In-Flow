//
//  ServiceViewController.swift
//  SignIn
//
//  Created by Jaesung Lee on 2020/09/15.
//

import UIKit

class ServiceViewController: UIViewController {
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileURLLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        CredentialManager.shared.addDelegate(self, forKey: "Service")
    }


    func updateUI(with credential: Credential?) {
        self.userIDLabel.text = credential?.userID
        self.usernameLabel.text = credential?.name
        self.profileURLLabel.text = credential?.profileURL
    }
}

extension ServiceViewController: CredentialDelegate {
    func didUpdateCredential(_ credential: Credential?) {
        self.updateUI(with: credential)
    }
}
