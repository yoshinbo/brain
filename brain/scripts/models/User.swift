//
//  User.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/03.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import Foundation

class User {

    var level: Int = 1 // initial level
    var exp: Int = 0
    var maxEnergy: Int = 1 // initial max energy for using skill
    var energyRecoveryAt: Double = DateUtil.now()
    var bestScores: [Int: Int] = [
        1 : 0,
        2 : 0
    ]

    init() {
        self.loadData()
    }

    func currentEnergy() -> Int {
        var time_to_recovery = max((self.energyRecoveryAt - DateUtil.now()), 0)
        var currentEnergy = max((Double(self.maxEnergy) - ceil(time_to_recovery / energyRecoveryTime)),0)
        return Int(currentEnergy)
    }

    func energyRecoveryRemainTime() -> Double {
        var currentEnergy = self.currentEnergy()
        if (currentEnergy == self.maxEnergy) {
            return 0
        }
        var energyRecoveryRemainTime = max((self.energyRecoveryAt - DateUtil.now()), 0)
        return energyRecoveryRemainTime
    }

    func expRatePercentage() -> Int {
        return Util.calcExpRatePercentage(self.exp, requiredExp: self.requiredExpForNextLevel())
    }

    func requiredExpForNextLevel() -> Int {
        return (self.level + 1) * requiredExpBase
    }

    func remainRequiredExpForNextLevel() -> Int {
        return self.requiredExpForNextLevel() - self.exp
    }


    // bellow update functions
    func commit() {
        self.updateData()
    }

    func addExp(exp: Int) -> Int {
        var levelUpNum = 0
        self.exp += exp
        while((self.requiredExpForNextLevel() > 0) && (self.exp >= self.requiredExpForNextLevel())) {
            self.exp = self.exp - self.requiredExpForNextLevel()
            self.level += 1
            levelUpNum += 1
        }
        return levelUpNum
    }

    func updateBestScoreIfNeed(gameId: Int, score: Int) -> Bool {
        var isNeed: Bool = false
        if self.bestScores[gameId]! < score {
            self.bestScores[gameId] = score
            isNeed = true
        }
        return isNeed
    }

    func useEnergy(useNum: Int) {
        if (self.currentEnergy() >= useNum) {
            var energyRecoveryAt = max(self.energyRecoveryAt, DateUtil.now())
            self.energyRecoveryAt = energyRecoveryAt + Double(useNum) * energyRecoveryTime
        } else {
            // ここには来ない想定
        }
    }

    func recoverEnergy() {
        self.energyRecoveryAt = DateUtil.now()
    }
}

extension User {

    // NSKeyedArchiverからデータロード
    private func loadData() {
        let data:AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithFile(self.path())
        if let unwrapData: AnyObject = data {
            self.level            = unwrapData["level"] as Int
            self.exp              = unwrapData["exp"] as Int
            self.maxEnergy        = unwrapData["maxEnergy"] as Int
            self.energyRecoveryAt = unwrapData["energyRecoveryAt"] as Double
            if let _bestScores: AnyObject = unwrapData["bestScores"] {
                self.bestScores   = unwrapData["bestScores"] as [Int: Int]
            }
        }
    }

    // NSKeyedArchiverにデータセーブ
    private func updateData() {
        let success = NSKeyedArchiver.archiveRootObject([
            "level"            : self.level,
            "exp"              : self.exp,
            "maxEnergy"        : self.maxEnergy,
            "energyRecoveryAt" : self.energyRecoveryAt,
            "bestScores"       : self.bestScores
            ], toFile: self.path())
        if success { NSLog("-> update data") }
    }

    private func path() -> String {
        // /Documentsまでのパス取得
        let paths = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory,
            .UserDomainMask, true)
        // /Documentsまでのパスにファイル名"sample.dat"を付与
        return paths[0].stringByAppendingPathComponent("brain_user.dat")
    }
}
