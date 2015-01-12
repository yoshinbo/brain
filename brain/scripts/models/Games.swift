//
//  Games.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/02.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import Foundation

class Game {

    var id: Int
    var title: String
    var helpDesc: String
    var timeLimitSec: Int
    var setUpTimeSec: Int

    init(id: Int, title: String, helpDesc: String, timeLimitSec: Int, setUpTimeSec: Int) {
        self.id = id
        self.title = title
        self.helpDesc = helpDesc
        self.timeLimitSec = timeLimitSec
        self.setUpTimeSec = setUpTimeSec
    }

    func isSpeedMatch() -> Bool {
        return self.id == 1
    }

    func isColorMatch() -> Bool {
        return self.id == 2
    }

    func isCalcCompare() -> Bool {
        return self.id == 3
    }
}

class Games: NSObject {

    var games:[Game] = []

    override init() {
        super.init()
        for gameKind in gameKinds {
            var game = Game(
                id: gameKind.id,
                title: gameKind.title,
                helpDesc: gameKind.help,
                timeLimitSec: gameKind.timeLimitSec,
                setUpTimeSec: gameKind.setUpTimeSec
            )
            self.games.append([game][0])
        }
    }

    func totalGameNum() -> Int {
        return self.games.count
    }

    func getByIndex(indexId: Int) -> Game {
        return self.games[indexId]
    }

    func getById(id: Int) -> Game? {
        for game in self.games {
            if game.id == id {
                return game
            }
        }
        return nil
    }
}
