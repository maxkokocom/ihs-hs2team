//
//  Friends.swift
//  ihs-hackathon-hs2
//
//  Created by Kuba Domaszewicz on 14.04.2018.
//  Copyright © 2018 hs2. All rights reserved.
//

import Foundation

struct Friend {
    
    let avatarURL: String
    let fullname: String
    let bestIn: String
    let value: Int
    
    static func getFriendsHallOfFame( startDate: Date, endDate: Date, category: String, completion: @escaping (_ session: [Friend]) -> Void  ) {
        
        let friends =
            [
                Friend(avatarURL: "https://raw.githubusercontent.com/Ashwinvalento/cartoon-avatar/master/lib/images/male/41.png", fullname: "Dominic Purcell", bestIn: "Steps", value: 1206),
                Friend(avatarURL: "https://raw.githubusercontent.com/Ashwinvalento/cartoon-avatar/master/lib/images/male/42.png", fullname: "John Smith Jr.", bestIn: "Steps", value: 1001),
                Friend(avatarURL: "https://raw.githubusercontent.com/Ashwinvalento/cartoon-avatar/master/lib/images/female/43.png", fullname: "Kamila Hućko", bestIn: "Push-Ups", value: 921),
                Friend(avatarURL: "https://raw.githubusercontent.com/Ashwinvalento/cartoon-avatar/master/lib/images/male/44.png", fullname: "Bronisław Wójcicki", bestIn: "Sit-Ups", value: 821),
                Friend(avatarURL: "https://raw.githubusercontent.com/Ashwinvalento/cartoon-avatar/master/lib/images/male/45.png", fullname: "Hector Carbonell", bestIn: "Hiking", value: 572),
                Friend(avatarURL: "https://raw.githubusercontent.com/Ashwinvalento/cartoon-avatar/master/lib/images/male/46.png", fullname: "Sebastian Mater", bestIn: "Running", value: 411),
                Friend(avatarURL: "https://raw.githubusercontent.com/Ashwinvalento/cartoon-avatar/master/lib/images/male/47.png", fullname: "Jimmy Hector", bestIn: "Running", value: 400),
                Friend(avatarURL: "https://raw.githubusercontent.com/Ashwinvalento/cartoon-avatar/master/lib/images/male/48.png", fullname: "Konrad Michalczuk", bestIn: "Running", value: 399),
                Friend(avatarURL: "https://raw.githubusercontent.com/Ashwinvalento/cartoon-avatar/master/lib/images/female/49.png", fullname: "Ewa Ninistko", bestIn: "Running", value: 252)
        ]
        
        completion(friends)
    }
}
