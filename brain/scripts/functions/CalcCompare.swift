//
//  CalcCompare.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/12/31.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import Foundation

protocol CalcCompareProtocol {
    func renderPanel(formula: String)
}

class CalcCompare: GameBase {

    var matchDelegate: CalcCompareProtocol!

    var panels: [(formula: String, ans: Int)] = []
    var previousAns: Int = 0

    override init(game: Game, skills: [Skill], isExpBonus: Bool) {
        super.init(game: game, skills: skills, isExpBonus: isExpBonus)

        for i in 0..<2 {
            self.addPanel()
        }
        self.previousAns = self.currentPanelAns()
    }

    func addAndRenderPanel() {
        self.addPanel()
        self.matchDelegate.renderPanel(self.currentPanelFormula())
    }

    func isCollectAnswer(ans: Bool) -> Bool {
        let removedPanel = self.panels.removeAtIndex(0)
        let isGreater = removedPanel.ans >= self.previousAns
        self.previousAns = removedPanel.ans
        return isGreater == ans
    }

    func removeCurrentPanel() {
        let removedPanel = self.panels.removeAtIndex(0)
        self.previousAns = removedPanel.ans
    }
}

extension CalcCompare {

    private func currentPanelFormula() -> String {
        return self.panels[0].formula
    }

    private func currentPanelAns() -> Int {
        return self.panels[0].ans
    }

    private func addPanel() {
        var difficulityIndex = calcCompareDifficulity[self.continuousCollectBonusCoef]!
        var operationSeed = formulaOperationSeed[difficulityIndex]
        var operation = Util.randomWithWeight(formulaOperationSeed[difficulityIndex])

        switch operation {
        case "+":
            self.additionPanel(difficulityIndex)
        case "-":
            self.subtractionPanel(difficulityIndex)
        case "*":
            self.multiplicationPanel(difficulityIndex)
        case "/":
            self.divisionPanel(difficulityIndex)
        default:
            break
        }

        //self.dumpPanels()
    }

    private func dumpPanels() {
        println("dump panels of calc compare --->");
        for panel in self.panels {
            println("formula:\(panel.formula), ans:\(panel.ans)");
        }
    }

    private func additionPanel(difficulityIndex: Int) {
        var seed = addSubFormulaSeed[difficulityIndex]
        var leftSideValue = Int(arc4random_uniform(UInt32(seed.leftSideRandSeed))) + 1
        var rightSideValue = Int(arc4random_uniform(UInt32(seed.rightSideRandSeed))) + 1
        var formulaString = "\(leftSideValue) + \(rightSideValue)"
        self.panels.append([(
            formula: formulaString,
            ans: leftSideValue + rightSideValue
        )][0])
    }

    private func subtractionPanel(difficulityIndex: Int) {
        var seed = addSubFormulaSeed[difficulityIndex]
        var leftSideValue = Int(arc4random_uniform(UInt32(seed.leftSideRandSeed))) + 1
        var rightSideValue = Int(arc4random_uniform(UInt32(seed.rightSideRandSeed))) + 1
        var formulaString = "\(leftSideValue) - \(rightSideValue)"
        var ans = leftSideValue - rightSideValue
        if leftSideValue < rightSideValue {
            formulaString = "\(rightSideValue) - \(leftSideValue)"
            ans = rightSideValue - leftSideValue
        }
        self.panels.append([(
            formula: formulaString,
            ans: ans
        )][0])
    }

    private func multiplicationPanel(difficulityIndex: Int) {
        var seed = multiDivFormulaSeed[difficulityIndex]
        var leftSideValue = Int(arc4random_uniform(UInt32(seed.leftSideRandSeed))) + 1
        var rightSideValue = Int(arc4random_uniform(UInt32(seed.rightSideRandSeed))) + 1
        var formulaString = "\(leftSideValue) × \(rightSideValue)"
        self.panels.append([(
            formula: formulaString,
            ans: leftSideValue * rightSideValue
        )][0])
    }

    private func divisionPanel(difficulityIndex: Int) {
        var seed = multiDivFormulaSeed[difficulityIndex]
        var leftSideValue = Int(arc4random_uniform(UInt32(seed.leftSideRandSeed))) + 1
        var rightSideValue = Int(arc4random_uniform(UInt32(seed.rightSideRandSeed))) + 1
        var newLeftSideValue = leftSideValue * rightSideValue
        var formulaString = "\(newLeftSideValue) ÷ \(rightSideValue)"
        self.panels.append([(
            formula: formulaString,
            ans: leftSideValue
        )][0])
    }
}
