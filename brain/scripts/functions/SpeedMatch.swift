//
//  SpeedMatch.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/03.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import Foundation

protocol SpeedMatchProtocol {
    func renderPanel(name: String)
}

class SpeedMatch: GameBase {
    
    var SpeedMatchDelegate: SpeedMatchProtocol!

    var panels: [(id: Int, name: String)] = []
    var previousId: Int = 0
    
    override init(game: Game, skills: [Skill], isExpBonus: Bool) {
        super.init(game: game, skills: skills, isExpBonus: isExpBonus)
        
        for i in 0..<panelStockNum {
            self.addPanel()
        }
        self.previousId = self.currentPanelId()
    }
    
    func addAndRenderPanel() {
        self.addPanel()
        self.SpeedMatchDelegate.renderPanel(self.currentPanelName())
    }
    
    func isCollectAnswer(ans: Bool) -> Bool {
        let removedPanel = self.panels.removeAtIndex(0)
        let isSame = removedPanel.id == self.previousId
        self.previousId = removedPanel.id
        return isSame == ans
    }
    
    func currentPanelId() -> Int {
        return self.panels[0].id
    }
    
    func currentPanelName() -> String {
        return self.panels[0].name
    }
}

extension SpeedMatch {
    private func lastPanelId() -> Int {
        var id: Int = 0
        if (self.panels.count > 0) {
            id = self.panels[self.panels.endIndex-1].id
        }
        return id
    }
    
    private func lastPanelName() -> String {
        var name: String = ""
        if (self.panels.count > 0) {
            name = self.panels[self.panels.endIndex-1].name
        }
        return name
    }
    
    private func addPanel() {
        var panels = speedMatchPanels
        let isOneTwo: Bool = Util.oneTwo()
        if (self.panels.count > 0 && isOneTwo) {
            self.panels.append([(
                id: self.lastPanelId(),
                name: self.lastPanelName()
            )][0])
        } else {
            self.appendFromExceptPanels(self.lastPanelId())
        }
        //self.dumpPanels()
    }
    
    private func appendFromExceptPanels(id: Int) {
        var panels: [(id: Int, name: String)] = []
        for tmpPanel in speedMatchPanels {
            if tmpPanel.id != id {
                panels.append(tmpPanel)
            }
        }
        var randomIndex: Int = Int(arc4random_uniform(UInt32(panels.count)))
        self.panels.append([(
            id: panels[randomIndex].id,
            name: panels[randomIndex].name
        )][0])
        
    }

    private func dumpPanels() {
        println("dump panels of speed match --->");
        for panel in self.panels {
            println("id:\(panel.id), name:\(panel.name)");
        }
    }
}