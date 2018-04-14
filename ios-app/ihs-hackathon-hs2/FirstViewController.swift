//
//  FirstViewController.swift
//  ihs-hackathon-hs2
//
//  Created by Kuba Domaszewicz on 14.04.2018.
//  Copyright © 2018 hs2. All rights reserved.
//

import UIKit
import HealthKit

class FirstViewController: UITabBarController {
    
}

class DashboardViewController: UIViewController {
    
    let healthKitManager = HealthKitManager()
    
    @IBOutlet var thisWeekStepsLabel: UILabel!
    @IBOutlet var thisWeekFloorsLabel: UILabel!
    @IBOutlet var thisWeekDistanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if thisWeekStepsLabel == nil { return }
        
        healthKitManager.getQuantity(HKQuantityTypeIdentifier.stepCount, startDate: Date().startWeek, endDate: Date().endWeek) { (value, error) in
            
            print(error)
            
            DispatchQueue.main.async {
                self.thisWeekStepsLabel.text = "\(value)"
            }
        }
        
        healthKitManager.getQuantity(HKQuantityTypeIdentifier.flightsClimbed, startDate: Date().startWeek, endDate: Date().endWeek) { (value, error) in
            
            DispatchQueue.main.async {
                self.thisWeekFloorsLabel.text = "\(value)"
            }
        }
        
        healthKitManager.getQuantity(HKQuantityTypeIdentifier.distanceWalkingRunning, startDate: Date().startWeek, endDate: Date().endWeek) { (value, error) in
            
            let km = String(format:"%.1f", Double(value) / 1000.0 )
            
            DispatchQueue.main.async {
                self.thisWeekDistanceLabel.text = "\(km) km"
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

