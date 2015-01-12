//
//  ColorMatch.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/03.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import Foundation

protocol ColorMatchProtocol {
    func renderPanel(name: String, color: String)
}

class ColorMatch: GameBase {
    
    var matchDelegate: ColorMatchProtocol!
    
    var panels: [(name: String, color: String)] = []
    var previousName: String = ""
    
    override init(game: Game, skills: [Skill], isExpBonus: Bool) {
        super.init(game: game, skills: skills, isExpBonus: isExpBonus)
        
        for i in 0..<panelStockNum {
            self.addPanel()
        }
        self.previousName = self.currentPanelName()
    }

    func addAndRenderPanel() {
        self.addPanel()
        self.matchDelegate.renderPanel(self.currentPanelName(), color: self.currentPanelColor())
    }
    
    func isCollectAnswer(ans: Bool) -> Bool {
        let removedPanel = self.panels.removeAtIndex(0)
        let isSame = removedPanel.color == self.previousName
        self.previousName = removedPanel.name
        return isSame == ans
    }
    
    func removeCurrentPanel() {
        let removedPanel = self.panels.removeAtIndex(0)
        self.previousName = removedPanel.name
    }
}

extension ColorMatch {
    
    private func currentPanelName() -> String {
        return self.panels[0].name
    }
    
    private func currentPanelColor() -> String {
        return self.panels[0].color
    }
    
    private func addPanel() {
        var seed: UInt32 = UInt32(colorMatchColors.count);
        var nameString: String = colorMatchColors[Int(arc4random_uniform(seed))]
        var colorString: String = ""
        let isOneTwo: Bool = Util.oneTwo()
        if (self.panels.count > 0 && isOneTwo) {
            var lastPanel = self.panels[self.panels.endIndex-1]
            colorString = lastPanel.name
        } else {
            colorString = colorMatchColors[Int(arc4random_uniform(seed))]
        }
        self.panels.append([(
            name: nameString,
            color: colorString
        )][0])
        //self.dumpPanels()
    }
    
    private func dumpPanels() {
        println("dump panels of color match --->");
        for panel in self.panels {
            println("name:\(panel.name), color:\(panel.color)");
        }
    }
}