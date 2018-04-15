//
//  FirstViewController.swift
//  ihs-hackathon-hs2
//
//  Created by Kuba Domaszewicz on 14.04.2018.
//  Copyright © 2018 hs2. All rights reserved.
//

import UIKit
import HealthKit
import SwiftDate

class FirstViewController: UITabBarController {
    
}

class DashboardViewController: UIViewController {
    
    let healthKitManager = HealthKitManager()
    
    @IBOutlet var thisWeekStepsLabel: UILabel!
    @IBOutlet var thisWeekFloorsLabel: UILabel!
    @IBOutlet var thisWeekDistanceLabel: UILabel!
    
    @IBOutlet var lastWeekStepsLabel: UILabel!
    @IBOutlet var lastWeekFloorsLabel: UILabel!
    @IBOutlet var lastWeekDistanceLabel: UILabel!
    
    private func authorizeHealthkitAndUpdateData() {
        
        let completion: ((Bool, Error?) -> Void)! = {
            (success, error) -> Void in
            
            if !success {
                print("You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: \(error). If you're using a simulator, try it on a device.")
                
                return
            }
            
            self.updateData()
        }
        
        healthKitManager.authorizeHealthKit(completion)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authorizeHealthkitAndUpdateData()
        
        Synchronization().synchronize()
    }
    
    private func updateData() {
        
        healthKitManager.getQuantity(HKQuantityTypeIdentifier.stepCount, startDate: Date().startWeek, endDate: Date().endWeek) { (value, error) in
            
            DispatchQueue.main.async {
                self.thisWeekStepsLabel.text = "\(Int(value))"
            }
        }
        
        healthKitManager.getQuantity(HKQuantityTypeIdentifier.flightsClimbed, startDate: Date().startWeek, endDate: Date().endWeek) { (value, error) in
            
            DispatchQueue.main.async {
                self.thisWeekFloorsLabel.text = "\(Int(value))"
            }
        }
        
        healthKitManager.getQuantity(HKQuantityTypeIdentifier.distanceWalkingRunning, startDate: Date().startWeek, endDate: Date().endWeek) { (value, error) in
            
            let km = String(format:"%.1f", Double(value) / 1000.0 )
            
            DispatchQueue.main.async {
                self.thisWeekDistanceLabel.text = "\(km) km"
            }
        }
        
        /// Last week
        
        let startDate = (Date() - 1.weeks).startWeek
        let endDate = (Date() - 1.weeks).endWeek
        
        healthKitManager.getQuantity(HKQuantityTypeIdentifier.stepCount, startDate: startDate, endDate: endDate) { (value, error) in
            
            DispatchQueue.main.async {
                self.lastWeekStepsLabel.text = "\(Int(value))"
            }
        }
        
        healthKitManager.getQuantity(HKQuantityTypeIdentifier.flightsClimbed, startDate: startDate, endDate: endDate) { (value, error) in
            
            DispatchQueue.main.async {
                self.lastWeekFloorsLabel.text = "\(Int(value))"
            }
        }
        
        healthKitManager.getQuantity(HKQuantityTypeIdentifier.distanceWalkingRunning, startDate: startDate, endDate: endDate) { (value, error) in
            
            let km = String(format:"%.1f", Double(value) / 1000.0 )
            
            DispatchQueue.main.async {
                self.lastWeekDistanceLabel.text = "\(km) km"
            }
        }
    }
}

