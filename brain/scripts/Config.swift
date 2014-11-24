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
let requiredExpBase: Int = 100 // この値×levelが必要経験値

// for brain
let brainKinds: [(id: Int, name: String, requiredLevel: Int)] =
[
    (
        id: 1,
        name: "BrainNo1",
        requiredLevel: 1
    ),
    (
        id: 2,
        name: "BrainNo1",
        requiredLevel: 5
    ),
    (
        id: 3,
        name: "BrainNo1",
        requiredLevel: 10
    ),
    (
        id: 4,
        name: "BrainNo1",
        requiredLevel: 20
    ),
    (
        id: 5,
        name: "BrainNo1",
        requiredLevel: 30
    )
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