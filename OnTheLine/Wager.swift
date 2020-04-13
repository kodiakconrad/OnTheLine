//
//  Wager.swift
//  OnTheLine
//
//  Created by Kodiak Conrad on 10/1/19.
//  Copyright © 2019 Kodiak Conrad. All rights reserved.
//

import Foundation

// MARK: Enum
enum EventType {
    case game, statistic, outcome
}

// MARK: Event
class Event {
    var name: String!
    
    // for Game
    var homeTeam: String!
    var awayTeam: String!
    var timestamp: Date!
    var spread: Double! // always with respect to home team
    
    //for statistic
    var subject: String!
    var statType: String!
    var statValue: Double!
    
    // for outcome
    var option1: String!
    var option2: String!
    
    init() {
        self.awayTeam = nil
        self.homeTeam = nil
        self.timestamp = nil
        self.spread = nil
        self.subject = nil
        self.statType = nil
        self.statValue = nil
        self.option1 = nil
        self.option2 = nil
    }
    
}


// MARK: GAME
class Game: Event {
    
    init(name: String, homeTeam: String, awayTeam: String, timestamp: Date, spread: Double) {
        super.init()
        self.name = name
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.timestamp = timestamp
        self.spread = spread
    }
    
    init(data: [String: Any]) {
        super.init()
        self.homeTeam = data["Home"] as? String
        self.awayTeam = data["Away"] as? String
        self.spread = data["Spread"] as? Double
        self.timestamp = data["Timestamp"] as? Date
    }
    
    func setTime(timestamp: Date) {
        self.timestamp = timestamp
    }
    
    func setSpread(spread: Double) {
        self.spread = spread
    }
    
    func toString() { // prototype
        print("\(self.awayTeam!) at \(self.homeTeam!) (\(self.spread!)) at \(self.timestamp!)")
    }
    
    func getData() -> [String: Any] {
        var data = [String: Any]()
        data["EventType"] = "Game"
        data["Away"] = self.awayTeam!
        data["Home"] = self.homeTeam!
        data["Spread"] = self.spread!
        data["Timestamp"] = self.timestamp!
        return data
    }
}

// MARK: Statistic
class Statistic: Event {
    
    init(name: String, subject: String, statType: String, value: Double) {
        super.init()
        self.name = name
        self.subject = subject
        self.statType = statType
        self.statValue = value
    }
    
    func setSubject(subject: String) {
        self.subject = subject
    }
    
    func setStatType(statType: String) {
        self.statType = statType
    }
    
    func setValue(value: Double) {
        self.statValue = value
    }
}

// MARK: Outcome
class Outcome: Event {

    init(name: String, option1: String, option2: String) {
        super.init()
        self.name = name
        self.option1 = option1
        self.option2 = option2
    }
}

// MARK: Wager
class Wager {
    var wagerID: String!
    var event: Event
    var type: EventType
    var users: [String]
    var value: Int
    var status: String
    
    init(type: EventType, event: Event) {
        self.type = type
        self.event = event
        self.users = []
        self.value = 0
        self.status = "Pending"
    }
    
    init(type: EventType, id: String, event: Event, u1: String, u2: String, value: Int, status: String) {
        self.type = type
        self.wagerID = id
        self.event = event
        self.users = [u1, u2]
        self.value = value
        self.status = status
    }
}
