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
        name: "BrainNo1",
        desc: "",
        requiredLevel: 5
    ),
    (
        id: 3,
        name: "BrainNo1",
        desc: "",
        requiredLevel: 10
    ),
    (
        id: 4,
        name: "BrainNo1",
        desc: "",
        requiredLevel: 20
    ),
    (
        id: 5,
        name: "BrainNo1",
        desc: "",
        requiredLevel: 30
    )
]

// for brain
let skillKinds: [(id: Int, name: String, cost: Int, type: Int, value: Int, desc: String, requiredBrainId: Int)] =
[
    (
        id: 1,
        name: "TIME PLUS",
        cost: 2,
        type: 1,
        value: 5,
        desc: "",
        requiredBrainId: 2
    ),
    (
        id: 2,
        name: "TIME PLUS+",
        cost: 3,
        type: 1,
        value: 10,
        desc: "",
        requiredBrainId: 3
    ),
    (
        id: 3,
        name: "BONUS PLUS",
        cost: 5,
        type: 2,
        value: 5,
        desc: "",
        requiredBrainId: 4
    ),
    (
        id: 4,
        name: "EXP PLUS",
        cost: 5,
        type: 3,
        value: 2,
        desc: "",
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