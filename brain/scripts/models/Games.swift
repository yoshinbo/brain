//
//  Games.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/02.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import Foundation

class Game {
    
    var id: Int = 0
    var title: String = ""
    var bestScore: Int = 0
    
    init(id: Int, title: String, bestScore: Int) {
        self.id = id
        self.title = title
        self.bestScore = bestScore
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
                bestScore: 0
            )
            self.games.append([game][0])
        }
    }
    
    func totalGameNum() -> Int {
        return self.games.count
    }
    
    func getById(index: Int) -> Game {
        return self.games[index]
    }
}