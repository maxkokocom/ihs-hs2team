//
//  Session.swift
//  ihs-hackathon-hs2
//
//  Created by Kuba Domaszewicz on 14.04.2018.
//  Copyright © 2018 hs2. All rights reserved.
//

import Foundation

import Argo
import Curry
import Runes
import HealthKit
import SwiftDate

func dateFromISO8601String(string: String) -> Date? {
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    return dateFormatter.date(from: string)
}

func iso8601ToDate(iso8601String: String) -> Decoded<Date> {
    
    if let date = dateFromISO8601String(string: iso8601String) {
        return pure(date)
    }
    return Decoded<Date>.failure(.custom("Wrong iso8601 format: \(iso8601String)"))
}

struct Session: Argo.Decodable {
    
    let startDate: Date
    let endDate: Date
    let steps: Double?
    
    static func decode(_ json: JSON) -> Decoded<Session> {
        return curry(Session.init)
            
            <^> (json <| "startDate" >>- iso8601ToDate)
            <*> (json <| "endDate" >>- iso8601ToDate)
            <*> json <|? "steps"
    }
    
    func encode() -> [String: AnyObject] {
        
        var result: [String: AnyObject] = ["startDate": startDate.iso8601() as AnyObject, "endDate": endDate.iso8601() as AnyObject]
        
        if let steps = steps { result["steps"] = steps as AnyObject }
        
        return result
    }
    
    static func getSession( lastSessionDate: Date, completion: @escaping (_ session: Session?) -> Void ) {
        
        let hkm = HealthKitManager()
        
        let endDate: Date
        
        if Date() - lastSessionDate > 3000 {
            endDate = lastSessionDate + 3.minutes
        } else {
            endDate = Date()
        }
        
        hkm.getQuantity(HKQuantityTypeIdentifier.stepCount, startDate: lastSessionDate, endDate: endDate) { (value, error) in
            
            if value == 0 {
                
                completion(nil)
                
            } else {
                
                let session = Session(startDate: lastSessionDate, endDate: endDate, steps: value)
                
                completion(session)
            }
        }
    }
}
