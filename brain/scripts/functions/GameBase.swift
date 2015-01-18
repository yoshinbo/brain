//
//  GameBase.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/03.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import Foundation

let panelStockNum = 3
let directionToAns = [ // フリックの正当判定用
    "right" : true,
    "left"  : false
]

protocol GameBaseProtocol {
    func start()
    func renderTime(sec: Int)
    func renderScore(score: Int)
    func renderResultView(result:[String:Int])
}

class GameBase: NSObject {

    var delegate: GameBaseProtocol!

    var user: User
    var game: Game
    var skills: [Skill]
    var isExpBonus: Bool
    var score: Int = 0
    var timeLimitSec: Int
    var setUpTimeSec: Int
    var hasStarted: Bool
    var isGameOver: Bool

    var continuousCollectAnsNum: Int = 0 // 連続正解の場合の得点ボーナス用
    var continuousCollectBonusCoef: Int = 1 // 連続正解得点ボーナスの実数値

    init(game: Game, skills: [Skill], isExpBonus: Bool) {
        self.user = User()

        self.game = game
        self.skills = skills
        self.isExpBonus = isExpBonus
        self.hasStarted = false
        self.isGameOver = false

        var additionalTime: Int = self.skills
            .filter { $0.isTimePlus() }
            .map { $0.value }
            .reduce( 0, { $0 + $1 } )

        self.timeLimitSec = game.timeLimitSec + additionalTime
        self.setUpTimeSec = game.setUpTimeSec
    }

    func start() {
        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "update", userInfo: nil, repeats: true)
        self.delegate.renderTime(
            self.setUpTimeSec > 0
            ? self.setUpTimeSec
            : self.timeLimitSec
        )
    }

    func over() {
        var result: [String:Int] = [
            "score": self.score,
            "beforeLevel" : user.level,
            "beforeExpRatePercentage" : user.expRatePercentage()
        ]
        let addExpRet = user.addExp(self.score * self.expBonusCoef())
        result["levelUpNum"] = addExpRet.levelUpNum
        result["maxEnergyUpNum"] = addExpRet.maxEnergyUpNum
        result["afterLevel"] = user.level
        result["afterExpRatePercent"] = user.expRatePercentage()
        result["isBestScore"] = user.updateBestScoreIfNeed(game.id, score: self.score) ? 1 : 0
        result["bestScore"] = user.bestScores[game.id]
        result["newBrainId"] = user.updateBrain()
        result["gameId"] = game.id
        result["remainRequiredExpForNextLevel"] = user.remainRequiredExpForNextLevel()
        user.commit()
        self.delegate.renderResultView(result)
    }

    func update() {
        if (!self.isGameOver) {
            self.hasStarted
                ? self.countDown()
                : self.setUpTimeSecCountDown()
        }
    }

    func collect() {
        var BonusCoef =
            self.continuousCollectAnsNum >= continuousCollectAnsBonusCoef
            ? self.continuousCollectAnsNum / continuousCollectAnsBonusCoef + 1
            : 1
        self.continuousCollectBonusCoef = min(
            BonusCoef,
            self.maxContinuousCollectBonusCoef()
        )
        self.addScore(self.continuousCollectBonusCoef)
        self.continuousCollectAnsNum++
    }

    func incollect() {
        self.continuousCollectAnsNum = 0
        self.continuousCollectBonusCoef = 1
    }
}

extension GameBase {
    private func addScore(bonusCoef: Int) {
        self.score += 1 * bonusCoef
        self.delegate.renderScore(self.score)
    }

    private func setUpTimeSecCountDown() {
        self.setUpTimeSec -= 1
        if (self.setUpTimeSec <= 0) {
            self.setUpTimeSec = self.game.setUpTimeSec
            self.hasStarted = true
            self.delegate.start()
            self.delegate.renderTime(self.timeLimitSec)
        } else {
            self.delegate.renderTime(self.setUpTimeSec)
        }

    }

    private func countDown() {
        self.timeLimitSec -= 1
        if (self.timeLimitSec <= 0) {
            self.timeLimitSec = 0
            self.hasStarted = false
            self.isGameOver = true
            self.over()
        }
        self.delegate.renderTime(self.timeLimitSec)
    }

    private func additionalTime() -> Int {
        return self.skills
            .filter { $0.isTimePlus() }
            .map { $0.value }
            .reduce( 0, { $0 + $1 } )
    }

    private func maxContinuousCollectBonusCoef() -> Int {
        var bonusPlusValue = self.skills
            .filter { $0.isBonusPlus() }
            .map { $0.value }
            .reduce( 0, { $0 + $1 } )
        return max(bonusPlusValue, defaultMaxContinuousCollectAnsBonus)
    }

    private func expBonusCoef() -> Int {
        var expPlusValue = self.skills
            .filter { $0.isExpPlus() }
            .map { $0.value }
            .reduce( 0, { $0 + $1 } )
        var expBonusCoef = max(expPlusValue, 1)
        if self.isExpBonus {
            expBonusCoef *= 2
        }
        return expBonusCoef
    }
}
