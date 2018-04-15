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
        case .success(let grantedPermissions, _, let token):
            
            print("Success!")

            login(token: token.authenticationToken)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        
        print("Did logout via LoginButton")
    }
}

class LoginViewController: UIViewController  {
    
    var vc: UIViewController? = nil
    
    override func viewDidAppear(_ animated: Bool) {

        //self.performSegue(withIdentifier: "toMain", sender: self)
        
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends, .userPhotos ])
        loginButton.delegate = self
        loginButton.center = view.center
        view.addSubview(loginButton)
        
        if AuthenticationModel().token() == nil {
            let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends, .userPhotos ])
            loginButton.delegate = self
            loginButton.center = view.center
            view.addSubview(loginButton)
        } else {
            //self.performSegue(withIdentifier: "toMain", sender: self)
        }
    }
    
    func login( token: String ) {
        
        _ = defaultRequest(aidlab: .Login(access_token: token), completion: { result in
            
            if case let .success(response) = result {
                
                if 200 ... 299 ~= response.statusCode {
                    
                    do {
                    let key = try response.mapObject(rootKey: "key") as String
                        
                        AuthenticationModel().setToken(token: key)
                        
                        self.performSegue(withIdentifier: "toMain", sender: self)
                        print(key)
                    }
                    catch let error {
                        print(error)
                    }
                    
                }
                
            } else if case let .failure(error) = result {
                
                print("Error: \(error)")
            }
        })
    }
}

