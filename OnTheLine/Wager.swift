//
//  Wager.swift
//  OnTheLine
//
//  Created by Kodiak Conrad on 10/1/19.
//  Copyright © 2019 Kodiak Conrad. All rights reserved.
//

import Foundation

class Event {
    var name: String!
}

enum Status {
    case pending, active, completed
}

class Wager {
    var wagerID: String!
    var event: Event
    var users: [String]
    var value: Int
    var status: Status
    
    init(id: String, event: Event, u1: String, u2: String, value: Int, status: Status) {
        self.wagerID = id
        self.event = event
        self.users = [u1, u2]
        self.value = value
        self.status = status
    }
}
