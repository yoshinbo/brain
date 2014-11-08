//
//  GameBase.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/03.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import Foundation

let panelStockNum = 3

protocol GameBaseProtocol {
    func start()
    func renderTime(sec: Int)
    func renderScore(score: Int)
    func renderResultView()
}

class GameBase: NSObject {

    var delegate: GameBaseProtocol!

    var game: Game
    var score: Int = 0
    var timeLimitSec: Int
    var setUpTimeSec: Int
    var hasStarted: Bool
    var isGameOver: Bool

    var continuousCollectAnsNum: Int = 0 // 連続正解の場合の得点ボーナス用
    var continuousCollectBonusCoef: Int = 1 // 連続正解得点ボーナスの実数値

    init(game: Game) {
        self.game = game
        self.hasStarted = false
        self.isGameOver = false

        self.timeLimitSec = game.timeLimitSec
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
        // need to override
    }

    func update() {
        if (!self.isGameOver) {
            self.hasStarted
                ? self.countDown()
                : self.setUpTimeSecCountDown()
        }
    }

    func collect() {
        self.continuousCollectBonusCoef =
            self.continuousCollectAnsNum >= continuousCollectAnsBonusCoef
            ? self.continuousCollectAnsNum / continuousCollectAnsBonusCoef + 1
            : 1
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
        if (self.setUpTimeSec < 0) {
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
        if (self.timeLimitSec < 0) {
            self.timeLimitSec = 0
            self.hasStarted = false
            self.isGameOver = true
            self.over()
        }
        self.delegate.renderTime(self.timeLimitSec)
    }
}
