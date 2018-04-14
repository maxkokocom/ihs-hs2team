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
import SwiftDate

func presentToast( _ message: String, viewController: UIViewController ) {
    
    viewController.view.makeToast(message, duration: 4.0, position: ToastPosition.bottom )
}

func presentToast( _ message: String ) {
    
    if let topViewController = UIApplication.topViewController() {
        presentToast( message, viewController: topViewController )
    }
}

class Utils {
    
    static func generateWeeks( _ numberOfWeeks: Int, startingFrom: Date = Date() ) -> [Date] {
        
        var dates = [Date]()
        
        /// Get beggining of this week...
        var sWeek = startingFrom.startOf(component: Calendar.Component.weekOfMonth )
        
        /// ...But let's start with the beggining of the next week
        sWeek = sWeek + 1.weeks
        
        /// Fill `dates` with every week until `numberOfWeeks`
        for _ in 0 ..< numberOfWeeks {
            
            dates.append(sWeek)
            
            sWeek = sWeek - 1.weeks
        }
        
        return dates
    }
    
    static func generateDaysForWeek( since: Date, _ week: Int ) -> [Date] {
        
        let daysInWeek: Int = 7
        
        var dates: [Date] = []
        
        let date = since - week.weeks
        
        /// Get beggining of the week
        var sWeek = date.endOf(component: Calendar.Component.weekOfMonth )
        
        /// Fill `dates` with every week until `numberOfWeeks`
        for _ in 0 ..< daysInWeek {
            
            dates.append(sWeek)
            
            sWeek = sWeek - 1.days
        }
        
        dates.append(sWeek)
        
        return dates
    }
}

