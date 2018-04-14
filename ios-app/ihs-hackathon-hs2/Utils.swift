//
//  Utils.swift
//  ihs-hackathon-hs2
//
//  Created by Kuba Domaszewicz on 14.04.2018.
//  Copyright © 2018 hs2. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift

func presentToast( _ message: String, viewController: UIViewController ) {
    
    viewController.view.makeToast(message, duration: 4.0, position: ToastPosition.bottom )
}

func presentToast( _ message: String ) {
    
    if let topViewController = UIApplication.topViewController() {
        presentToast( message, viewController: topViewController )
    }
}
