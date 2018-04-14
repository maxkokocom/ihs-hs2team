//
//  Synchronization.swift
//  ihs-hackathon-hs2
//
//  Created by Kuba Domaszewicz on 14.04.2018.
//  Copyright © 2018 hs2. All rights reserved.
//

import Foundation
import SwiftDate

class Synchronization {
    
    init() {
        
        
    }
    
    func synchronize() {
        
        Session.getSession( lastSessionDate: lastSessionDate(), completion: { session in
            
            if let session = session {
                
                send( session: session )
            }
        })
    }
    
    func lastSessionDate() -> Date {
        
        return Date()
    }
}

func send( session: Session ) {
    
    _ = defaultRequest(aidlab: .PostSession(session: session), completion: { result in
        
        if case let .success(response) = result {
            
            if 200 ... 299 ~= response.statusCode {}
            
        } else if case let .failure(error) = result {
            
            print("Error: \(error)")
        }
    })
}
