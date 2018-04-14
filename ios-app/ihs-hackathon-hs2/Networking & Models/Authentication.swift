//
//  Authentication.swift
//  ihs-hackathon-hs2
//
//  Created by Kuba Domaszewicz on 14.04.2018.
//  Copyright © 2018 hs2. All rights reserved.
//

import Foundation

import Argo
import Curry
import Runes

struct Authentication: Argo.Decodable {
    
    let token: String
    
    static func decode(_ json: JSON) -> Decoded<Authentication> {
        return curry(Authentication.init)
            <^> json <| "token"
    }
}
