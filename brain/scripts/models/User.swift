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
    var energyRecoveryAt: Double = Util.now()

    init() {
        self.loadData()
    }

    func currentEnergy() -> Int {
        var time_to_recovery = max((self.energyRecoveryAt - Util.now()), 0)
        var currentEnergy = max((Double(self.maxEnergy) - ceil(time_to_recovery / energyRecoveryTime)),0)
        return Int(currentEnergy)
    }

    func energyRecoveryRemainTime() -> Double {
        var currentEnergy = self.currentEnergy()
        if (currentEnergy == self.maxEnergy) {
            return 0
        }
        var energyRecoveryRemainTime = max((self.energyRecoveryAt - Util.now()), 0)
        return energyRecoveryRemainTime
    }

    func useEnergy(useNum: Int) {
        if (self.currentEnergy() >= useNum) {
            var energyRecoveryAt = max(self.energyRecoveryAt, Util.now())
            self.energyRecoveryAt = energyRecoveryAt + Double(useNum) * energyRecoveryTime
        } else {
            // ここには来ない想定
        }
        self.updateData()
    }

    func recoverEnergy() {
        self.energyRecoveryAt = Util.now()
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
        self.updateData()
        return levelUpNum
    }

    func requiredExpForNextLevel() -> Int {
        return (self.level + 1) * requiredExpBase
    }

    func expAndRequiredExpWithFormat() -> String {
        return NSString(format: expAndRequiredExpFormat, self.exp, self.requiredExpForNextLevel())
    }

    func energyAndMaxEnergyWithFormat() -> String {
        return NSString(format: expAndRequiredExpFormat, self.currentEnergy(), self.maxEnergy)
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
        }
    }

    // NSKeyedArchiverにデータセーブ
    private func updateData() {
        let success = NSKeyedArchiver.archiveRootObject([
            "level"            : self.level,
            "exp"              : self.exp,
            "maxEnergy"        : self.maxEnergy,
            "energyRecoveryAt" : self.energyRecoveryAt
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
