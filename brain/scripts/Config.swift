//
//  Config.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/02.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import Foundation

let storeURL: String = "http://yahoo.co.jp"

// for User
let realStockNum: Int = 10
let energyRecoveryTime: Double = 60 * 3 // 3分で1回復
let requiredExpBase: Int = 50 // この値×levelが必要経験値
let updateMaxEnergyPerLevel: Int = 5 // この値レベル毎にMaxEnergy更新

// for brain
let brainKinds: [(id: Int, name: String, desc: String, requiredLevel: Int)] =
[
    (
        id: 1,
        name: "BrainNo1",
        desc: "",
        requiredLevel: 1
    ),
    (
        id: 2,
        name: "BrainNo2",
        desc: "",
        requiredLevel: 5
    ),
    (
        id: 3,
        name: "BrainNo3",
        desc: "",
        requiredLevel: 10
    ),
    (
        id: 4,
        name: "BrainNo4",
        desc: "",
        requiredLevel: 20
    ),
    (
        id: 5,
        name: "BrainNo5",
        desc: "",
        requiredLevel: 30
    )
]

// for skill
let typeTimePlus = 1
let typeBonusPlus = 2
let typeExpPlus = 3
let skillKinds: [(id: Int, name: String, cost: Int, type: Int, value: Int, desc: String, requiredBrainId: Int)] =
[
    (
        id: 1,
        name: "TIME PLUS",
        cost: 2,
        type: typeTimePlus,
        value: 5,
        desc: NSLocalizedString("timePlusDescription", comment: ""),
        requiredBrainId: 2
    ),
    (
        id: 2,
        name: "TIME PLUS+",
        cost: 3,
        type: typeTimePlus,
        value: 10,
        desc: NSLocalizedString("timePlus+Description", comment: ""),
        requiredBrainId: 3
    ),
    (
        id: 3,
        name: "BONUS PLUS",
        cost: 5,
        type: typeBonusPlus,
        value: 5,
        desc: NSLocalizedString("bonusPlusDescription", comment: ""),
        requiredBrainId: 4
    ),
    (
        id: 4,
        name: "EXP PLUS",
        cost: 5,
        type: typeExpPlus,
        value: 2,
        desc: NSLocalizedString("expPlusDescription", comment: ""),
        requiredBrainId: 5
    ),
]

// for general game setting
let gameKinds: [(id: Int, title: String, timeLimitSec: Int, setUpTimeSec: Int)] =
[
    (
        id: 1,
        title: "Speed Match",
        timeLimitSec: 30,
        setUpTimeSec: 3
    ),
    (
        id: 2,
        title: "Color Match",
        timeLimitSec: 30,
        setUpTimeSec: 3
    )
]

let continuousCollectAnsBonusCoef: Int = 5 // 連続正解の場合のボーナス係数
let defaultMaxContinuousCollectAnsBonus: Int = 3 // 連続正解ボーナスの最大倍率

// for Speed Match
let speedMatchPanels: [(id: Int, name: String)] = [
    (
        id: 1,
        name: "panel1"
    ),
    (
        id: 2,
        name: "panel2"
    ),
    (
        id: 3,
        name: "panel3"
    )
]

// for Color Match
let colorMatchColors: [String] = [
    "Red", "Blue", "Green", "Yellow"
]