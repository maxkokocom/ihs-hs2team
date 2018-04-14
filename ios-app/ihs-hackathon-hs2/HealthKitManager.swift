//
//  HealthKitManager.swift
//  ihs-hackathon-hs2
//
//  Created by Kuba Domaszewicz on 14.04.2018.
//  Copyright © 2018 hs2. All rights reserved.
//

import Foundation
import HealthKit
import SwiftDate

protocol HealthKitManagerDelegate: class {
    
    func didFinishStepsCollection( _ healthKitManager: HealthKitManager, quantityIdentifier: HKQuantityTypeIdentifier, quantities: [Double] )
    
    func didReceiveError( _ error: NSError )
}

class HealthKitManager {
    
    weak var delegate: HealthKitManagerDelegate!
    
    /// Where:
    /// week = 0 -> Current week
    /// week = 1 -> Last week
    /// week = 2 -> Two weeks ago
    /// week = 3 -> etc...
    func getQuantitiesForWeek( _ quantityIdentifier: HKQuantityTypeIdentifier, week: Int ) {
        
        let completion: ((Bool, Error?) -> Void)! = {
            (success, error) -> Void in
            
            if !success {
                
                print("You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: \(error). If you're using a simulator, try it on a device.")
                
                return
            }
            
            let dates: [Date] = Utils.generateDaysForWeek( since: Date(), week )
            
            self.collect( quantityIdentifier, dates: dates )
        }
        
        self.authorizeHealthKit(completion)
    }
    
    func getQuantitiesForWeeks( _ quantityIdentifier: HKQuantityTypeIdentifier, numberOfWeeks: Int ) {
        
        let completion: ((Bool, Error?) -> Void)! = {
            (success, error) -> Void in
            
            if !success {
                print("You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: \(error). If you're using a simulator, try it on a device.")
                
                return
            }
            
            DispatchQueue.main.async(execute: {
                () -> Void in
                
                let dates: [Date] = Utils.generateWeeks( numberOfWeeks )
                
                self.collect( quantityIdentifier, dates: dates )
            })
        }
        
        self.authorizeHealthKit(completion)
    }
    
    func getQuantity( _ quantityIdentifier: HKQuantityTypeIdentifier, startDate: Date, endDate: Date, completion: @escaping ( _ quantity: Double, _ error: Error? ) -> Void ) {
        
        // The type of data we are requesting (this is redundant and could probably be an enumeration
        guard let type = HKSampleType.quantityType(forIdentifier: quantityIdentifier) else {
            assert(false, "Wrong quantityIdentifier: \(quantityIdentifier)")
            completion(0, NSError(domain: "", code: -1, userInfo: nil))
            return
        }
        
        // Our search predicate which will fetch data from now until a day ago
        // (Note, 1.day comes from an extension
        // You'll want to change that to your own NSDate
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: HKQueryOptions())
        
        // The actual HealthKit Query which will fetch all of the steps and sub them up for us.
        let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: 0, sortDescriptors: nil) { _, results, error in
            
            var unit: HKUnit!
            
            if quantityIdentifier == HKQuantityTypeIdentifier.distanceWalkingRunning {
                
                unit = HKUnit.meter()
                
            } else if quantityIdentifier == HKQuantityTypeIdentifier.stepCount {
                
                unit = HKUnit.count()
                
            } else if quantityIdentifier == HKQuantityTypeIdentifier.flightsClimbed {
                
                unit = HKUnit.count()
                
            } else {
                
                assert(false, "Unsupported quantity type")
            }
            
            var quantity: Double = 0
            
            if let results = results as? [HKQuantitySample] {
                
                quantity = results.reduce(0, { $0 + $1.quantity.doubleValue(for: unit) })
            }
            
            completion( quantity, error )
        }
        
        HealthKitManager.healthKitStore.execute(query)
    }
    
    func authorizeHealthKit(_ completion: @escaping (_ success: Bool, _ error: Error?) -> Void!) {
        
        // If the store is not available (for instance, iPad) return an error and don't go on.
        if HKHealthStore.isHealthDataAvailable() {
            
            let healthKitTypesToRead: Set = dataTypesToRead()
            let healthKitTypesToWrite: Set = dataTypesToWrite()
            
            HealthKitManager.healthKitStore.requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead, completion: { (success, error) in
                
                completion(success, error)
            })
            
        } else {
            
            print("Health data unavailable")
        }
    }
    
    //-- Private ----------------------------------------
    
    private static let healthKitStore: HKHealthStore = HKHealthStore()
    
    private func collect( _ quantityIdentifier: HKQuantityTypeIdentifier, dates: [Date] ) {
        
        var quantities: [Double] = [Double](repeating: 0, count: dates.count-1)
        
        var progress = dates.count-1
        
        for i in 0 ..< dates.count-1 {
            
            getQuantity(quantityIdentifier, startDate: dates[i+1], endDate: dates[i], completion: { (quantity, _) in
                
                quantities[i] = quantity
                
                progress -= 1
                
                if progress == 0 {
                    
                    self.delegate.didFinishStepsCollection(self, quantityIdentifier: quantityIdentifier, quantities: quantities.reversed())
                }
            })
        }
    }
    
    private func dataTypesToWrite() -> Set<HKSampleType> {

        let writeDataTypes: Set<HKSampleType> = []
        
        return writeDataTypes
    }
    
    private func dataTypesToRead() -> Set<HKObjectType> {

        let stepCount: HKQuantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        let distanceWalkingRunning: HKQuantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!
        let flightsClimbed: HKQuantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.flightsClimbed)!
        
        let readDataTypes: Set<HKObjectType> = [stepCount, distanceWalkingRunning, flightsClimbed]

        return readDataTypes
    }
}
