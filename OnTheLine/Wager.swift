//
//  Wager.swift
//  OnTheLine
//
//  Created by Kodiak Conrad on 10/1/19.
//  Copyright © 2019 Kodiak Conrad. All rights reserved.
//

import Foundation

enum EventType {
    case game, statistic, outcome
}

class Event {
    var name: String!
    var choiceA: String! // Right Side
    var choiceB: String! // Left Side
}

class Game: Event {
    var homeTeam: String!
    var awayTeam: String!
    var time: Date!
    var spread: Double! // always with respect to home team
    init(name: String, homeTeam: String, awayTeam: String, time: Date, spread: Double) {
        super.init()
        self.name = name
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.time = time
        self.spread = spread
        self.choiceA = awayTeam
        self.choiceB = homeTeam
        
    }
    
    func setTime(time: Date) {
        self.time = time
    }
    
    func setSpread(spread: Double) {
        self.spread = spread
    }
}

class Statistic: Event {
    var subject: String!
    var statType: String!
    var value: Double!
    
    init(name: String, subject: String, statType: String, value: Double) {
        super.init()
        self.name = name
        self.subject = subject
        self.statType = statType
        self.value = value
        self.choiceA = "Over"
        self.choiceB = "Under"
    }
    
    func setSubject(subject: String) {
        self.subject = subject
    }
    
    func setStatType(statType: String) {
        self.statType = statType
    }
    
    func setValue(value: Double) {
        self.value = value
    }
}

class Outcome: Event {
    var option1: String!
    var option2: String!
    init(name: String, option1: String, option2: String) {
        super.init()
        self.name = name
        self.option1 = option1
        self.option2 = option2
        self.choiceA = option1
        self.choiceB = option2
    }
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
