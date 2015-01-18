//
//  Config.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/02.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import Foundation

let storeURL: String = "https://itunes.apple.com/us/app/the-brains/id955054182"
let spaceRangerStoreURL: String = "https://itunes.apple.com/us/app/space-ranger-bouncing-astronaut/id894369150"

// for AD
let adColonyAppId: String = "appca317c8cca724ab9ae"
let adColonyZoneId: String = "vz466b9493eb11438fa2"
let adMobUnitId: String = "ca-app-pub-4352710131585096/5315105560"
let nendApiKey: String = "6f16afa152cb712531f230a25a8b54c280a890ad"
let nendSpotId: String = "292491"
// for Test
//let nendApiKey: String = "2349edefe7c2742dfb9f434de23bc3c7ca55ad22"
//let nendSpotId: String = "101281"

// for Traking
let gaTrackingId: String = "UA-58054351-1"

// for User
let realStockNum: Int = 10
let energyRecoveryTime: Double = 60 * 3 // 3分で1回復
let requiredExpBase: Int = 20 // この値×levelが必要経験値
let updateMaxEnergyPerLevel: Int = 5 // この値レベル毎にMaxEnergy更新
let levelLeaderboardId: String = "brain.level" // レベルに関するリーダーズボードID

// for brain
let brainKinds: [(id: Int, name: String, unnamed: String, desc: String, levelUpComment: String, requiredLevel: Int, requiredGameId: Int, requiredScore: Int)] =
[
    (
        id: 1,
        name: NSLocalizedString("brain1Name", comment: ""),
        unnamed: NSLocalizedString("brain1Unnamed", comment: ""),
        desc: NSLocalizedString("brain1Description", comment: ""),
        levelUpComment: NSLocalizedString("brain2LevelUpComment", comment: ""),
        requiredLevel: 1,
        requiredGameId: 1,
        requiredScore: 50
    ),
    (
        id: 2,
        name: NSLocalizedString("brain2Name", comment: ""),
        unnamed: NSLocalizedString("brain2Unnamed", comment: ""),
        desc: NSLocalizedString("brain2Description", comment: ""),
        levelUpComment: NSLocalizedString("brain2LevelUpComment", comment: ""),
        requiredLevel: 5,
        requiredGameId: 1,
        requiredScore: 60
    ),
    (
        id: 3,
        name: NSLocalizedString("brain3Name", comment: ""),
        unnamed: NSLocalizedString("brain3Unnamed", comment: ""),
        desc: NSLocalizedString("brain3Description", comment: ""),
        levelUpComment: NSLocalizedString("brain3LevelUpComment", comment: ""),
        requiredLevel: 10,
        requiredGameId: 2,
        requiredScore: 60
    ),
    (
        id: 4,
        name: NSLocalizedString("brain4Name", comment: ""),
        unnamed: NSLocalizedString("brain4Unnamed", comment: ""),
        desc: NSLocalizedString("brain4Description", comment: ""),
        levelUpComment: NSLocalizedString("brain4LevelUpComment", comment: ""),
        requiredLevel: 20,
        requiredGameId: 2,
        requiredScore: 90
    ),
    (
        id: 5,
        name: NSLocalizedString("brain5Name", comment: ""),
        unnamed: NSLocalizedString("brain5Unnamed", comment: ""),
        desc: NSLocalizedString("brain5Description", comment: ""),
        levelUpComment: NSLocalizedString("brain5LevelUpComment", comment: ""),
        requiredLevel: 30,
        requiredGameId: 3,
        requiredScore: 90
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
        name: "BONUS PLUS",
        cost: 3,
        type: typeBonusPlus,
        value: 5,
        desc: NSLocalizedString("bonusPlusDescription", comment: ""),
        requiredBrainId: 3
    ),
    (
        id: 3,
        name: "TIME PLUS+",
        cost: 5,
        type: typeTimePlus,
        value: 10,
        desc: NSLocalizedString("timePlus+Description", comment: ""),
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
    )
]

// for general game setting
let gameKinds: [(id: Int, title: String, help: String, timeLimitSec: Int, setUpTimeSec: Int, leaderboardId: String)] =
[
    (
        id: 1,
        title: "Speed Match",
        help: NSLocalizedString("brain1Help", comment: ""),
        timeLimitSec: 30,
        setUpTimeSec: 3,
        leaderboardId: "brain.spead_match.score"
    ),
    (
        id: 2,
        title: "Color Match",
        help: NSLocalizedString("brain2Help", comment: ""),
        timeLimitSec: 30,
        setUpTimeSec: 3,
        leaderboardId: "brain.color_match.score"
    ),
    (
        id: 3,
        title: "Calc Compare",
        help: NSLocalizedString("brain3Help", comment: ""),
        timeLimitSec: 30,
        setUpTimeSec: 3,
        leaderboardId: "brain.calc_compare.score"
    )
]

let continuousCollectAnsBonusCoef: Int = 3 // 連続正解の場合のボーナス係数
let defaultMaxContinuousCollectAnsBonus: Int = 3 // 連続正解ボーナスの最大倍率

// for Speed Match
let speedMatchPanels: [(id: Int, name: String)] =
[
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

// for Calc Compare
let calcCompareDifficulity: Dictionary<Int, Int> =
[
    1: 0,
    2: 1,
    3: 1,
    4: 2,
    5: 2
]

let formulaOperationSeed: [[String: Int]] =
[
    [
        "+": 50,
        "-": 50,
        "*": 0,
        "/": 0
    ],
    [
        "+": 30,
        "-": 30,
        "*": 15,
        "/": 15
    ],
    [
        "+": 25,
        "-": 25,
        "*": 25,
        "/": 25
    ]
]

let addSubFormulaSeed: [(leftSideRandSeed: Int, rightSideRandSeed: Int)] =
[
    (
        leftSideRandSeed: 10,
        rightSideRandSeed: 10
    ),
    (
        leftSideRandSeed: 25,
        rightSideRandSeed: 25
    ),
    (
        leftSideRandSeed: 50,
        rightSideRandSeed: 50
    )
]

let multiDivFormulaSeed: [(leftSideRandSeed: Int, rightSideRandSeed: Int)] =
[
    (
        leftSideRandSeed: 10,
        rightSideRandSeed: 5
    ),
    (
        leftSideRandSeed: 10,
        rightSideRandSeed: 10
    ),
    (
        leftSideRandSeed: 10,
        rightSideRandSeed: 10
    )
]
