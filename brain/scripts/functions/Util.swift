//
//  Util.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/03.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import Foundation

class Util {

    // 1/2の確率でBool値を返す
    class func oneTwo() -> Bool {
        var rand: Int = Int(arc4random_uniform(10))
        return (rand % 2) == 0
    }

    class func conevertExpRatePercentageToRate(expRatePercentage: Int) -> Float {
        return Float(expRatePercentage)/100
    }

    class func calcExpRatePercentage(exp: Int, requiredExp: Int) -> Int {
        return Int(Float(exp)/Float(requiredExp)*100)
    }

    class func randomWithWeight(randomPicks: [String: Int]) -> String {
        var result = ""
        var totalWeight = 0
        for weight in randomPicks.values {
            totalWeight += weight
        }
        var randomValue: Int = Int(arc4random_uniform(UInt32(totalWeight))) + 1
        for key in randomPicks.keys {
            randomValue -= randomPicks[key]!
            if 0 >= randomValue {
                result = key
                break
            }
        }
        return result
    }
}
