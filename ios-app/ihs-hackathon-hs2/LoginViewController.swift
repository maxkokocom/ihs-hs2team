//
//  LoginViewController.swift
//  ihs-hackathon-hs2
//
//  Created by Kuba Domaszewicz on 14.04.2018.
//  Copyright © 2018 hs2. All rights reserved.
//

import UIKit
import Foundation
import FacebookLogin

extension LoginViewController: LoginButtonDelegate {
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        
        print("Did complete login via LoginButton with result \(result)")
        
        let alertController: UIAlertController
        switch result {
        case .cancelled:
            alertController = UIAlertController(title: "Login Cancelled", message: "User cancelled login.", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Yes", style: .default, handler: nil )
            alertController.addAction( actionOk )
            present(alertController, animated: true, completion: nil)
        case .failed(let error):
            alertController = UIAlertController(title: "Login Fail", message: "Login failed with error \(error)", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Yes", style: .default, handler: nil )
            alertController.addAction( actionOk )
            present(alertController, animated: true, completion: nil)
        case .success(let grantedPermissions, _, _):

            vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
            present(vc!, animated: true)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        
        print("Did logout via LoginButton")
    }
}

class LoginViewController: UIViewController  {
    
    var vc: UIViewController? = nil
    
    override func viewDidAppear(_ animated: Bool) {

        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
        loginButton.delegate = self
        loginButton.center = view.center
        view.addSubview(loginButton)
    }
}

