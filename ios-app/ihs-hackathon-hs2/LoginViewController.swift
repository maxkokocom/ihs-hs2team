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
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        
        print("Did logout via LoginButton")
    }
}

class LoginViewController: UIViewController  {
    
    override func viewDidLoad() {
        
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
        loginButton.delegate = self
        loginButton.center = view.center
        view.addSubview(loginButton)
    }
}

