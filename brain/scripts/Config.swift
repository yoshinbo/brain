//
//  Config.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/02.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import Foundation

let gameKinds: [(id: Int, title: String, timeLimitSec: Int, setUpTimeSec: Int)] = [
    (
        id: 1,
        title: "Speed Match",
        timeLimitSec: 60,
        setUpTimeSec: 3
    ),
    (
        id: 2,
        title: "Color Match",
        timeLimitSec: 60,
        setUpTimeSec: 3
    )
]

let CONTINUOUS_COLLECT_ANS_BONUS_COEF: Int = 5 // 連続正解の場合のボーナス係数

// for SpeedGame
let SPEED_GAME_PANELS: [(id: Int, name: String)] = [
    (
        id: 1,
        name: "panel1.png"
    ),
    (
        id: 2,
        name: "panel2.png"
    ),
    (
        id: 3,
        name: "panel3.png"
    )
]