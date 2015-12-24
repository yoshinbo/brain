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
    var brainId: Int = 1 // initial brainId
    var energyRecoveryAt: Double = DateUtil.now()
    var bestScores: [Int: Int] = [
        1 : 0,
        2 : 0,
        3 : 0
    ]

    init() {
        self.loadData()
    }

    func currentBrain() -> (id: Int, name: String, unnamed: String, desc: String, levelUpComment: String, requiredLevel: Int, requiredGameId: Int, requiredScore: Int) {
        return brainKinds.filter({ $0.id == self.brainId })[0]
    }

    func currentEnergy() -> Int {
        let time_to_recovery = max((self.energyRecoveryAt - DateUtil.now()), 0)
        let currentEnergy = max((Double(self.maxEnergy) - ceil(time_to_recovery / energyRecoveryTime)),0)
        return Int(currentEnergy)
    }

    func energyRecoveryRemainTime() -> Double {
        let currentEnergy = self.currentEnergy()
        if (currentEnergy == self.maxEnergy) {
            return 0
        }
        let energyRecoveryRemainTime = max((self.energyRecoveryAt - DateUtil.now()), 0)
        return energyRecoveryRemainTime
    }

    func expRatePercentage() -> Int {
        return Util.calcExpRatePercentage(self.exp, requiredExp: self.requiredExpForNextLevel())
    }

    func requiredExpForNextLevel() -> Int {
        return min((self.level + 1) * requiredExpBase, maxRequiredExp)
    }

    func remainRequiredExpForNextLevel() -> Int {
        return self.requiredExpForNextLevel() - self.exp
    }


    // bellow update functions
    func commit() {
        self.updateData()
    }

    func addExp(exp: Int) -> (levelUpNum: Int, maxEnergyUpNum: Int) {
        var levelUpNum = 0
        var maxEnergyUpNum = 0
        self.exp += exp
        while((self.requiredExpForNextLevel() > 0) && (self.exp >= self.requiredExpForNextLevel())) {
            self.exp = self.exp - self.requiredExpForNextLevel()
            self.level += 1
            levelUpNum += 1
            if self.level % updateMaxEnergyPerLevel == 0 {
                self.maxEnergy += 1
                maxEnergyUpNum += 1
            }
        }
        return (levelUpNum, maxEnergyUpNum)
    }

    func updateBrain() -> Int {
        var newBrainId = 0
        let nextBrainId = min(self.brainId+1, brainKinds.count)
        let nextBrain = brainKinds.filter({ $0.id == nextBrainId})[0]
        if     nextBrainId != self.brainId
            && self.level >= nextBrain.requiredLevel
            && self.bestScores[nextBrain.requiredGameId] >= nextBrain.requiredScore
        {
            self.brainId = nextBrainId
            newBrainId = nextBrainId
        }
        return newBrainId
    }

    func updateBestScoreIfNeed(gameId: Int, score: Int) -> Bool {
        var isNeed: Bool = false
        if self.bestScores[gameId] == nil || self.bestScores[gameId]! < score {
            self.bestScores[gameId] = score
            isNeed = true
        }
        return isNeed
    }

    func useEnergy(useNum: Int) {
        if (self.currentEnergy() >= useNum) {
            let energyRecoveryAt = max(self.energyRecoveryAt, DateUtil.now())
            self.energyRecoveryAt = energyRecoveryAt + Double(useNum) * energyRecoveryTime
        } else {
            // ここには来ない想定
        }
        self.commit()
        NSNotificationCenter.defaultCenter().postNotificationName(
            notificationUseEnergy,
            object: nil
        )
    }

    func recoverEnergy() {
        self.energyRecoveryAt = DateUtil.now()
        self.commit()
    }

    func isFullEnergy() -> Bool {
        let untilSec = self.energyRecoveryAt - DateUtil.now()
        return untilSec <= 0
    }
}

extension User {
    class func getBrainById(brainId: Int) -> (id: Int, name: String, unnamed: String, desc: String, levelUpComment: String, requiredLevel: Int, requiredGameId: Int, requiredScore: Int) {
        return brainKinds.filter({ $0.id == brainId })[0]
    }

    class func getBrainByIndex(index: Int) -> (id: Int, name: String, unnamed: String, desc: String, levelUpComment: String, requiredLevel: Int, requiredGameId: Int, requiredScore: Int) {
        return brainKinds[index]
    }
}

extension User {

    // NSKeyedArchiverからデータロード
    private func loadData() {
        let data:AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithFile(self.path())
        if let unwrapData = data as? Dictionary<String, AnyObject> {
            if let level = unwrapData["level"] as? Int {
                self.level = level
            }
            if let exp = unwrapData["exp"] as? Int {
                self.exp = exp
            }
            if let maxEnergy = unwrapData["maxEnergy"] as? Int {
                self.maxEnergy = maxEnergy
            }
            if let brainId = unwrapData["brainId"] as? Int {
                self.brainId = brainId
            }
            if let energyRecoveryAt = unwrapData["energyRecoveryAt"] as? Double {
                self.energyRecoveryAt = energyRecoveryAt
            }
            if let bestScores = unwrapData["bestScores"] as? [Int: Int] {
                self.bestScores = bestScores
            }
        }
    }

    // NSKeyedArchiverにデータセーブ
    private func updateData() {
        let success = NSKeyedArchiver.archiveRootObject([
            "level"            : self.level,
            "exp"              : self.exp,
            "maxEnergy"        : self.maxEnergy,
            "brainId"          : self.brainId,
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
