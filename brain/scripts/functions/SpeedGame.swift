//
//  SpeedGame.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/03.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import Foundation

let PANEL_STOCK_NUM = 3

protocol SpeedGameProtocol {
    func renderPanel(name: String)
}

class SpeedGame: GameBase {
    
    var speedGameDelegate: SpeedGameProtocol!

    var panels: [(id: Int, name: String)] = []
    var previousId: Int = 0
    
    override init(game: Game) {
        super.init(game: game)
        
        for i in 0..<PANEL_STOCK_NUM {
            self.addPanel()
        }
        self.previousId = self.currentPanelId()
    }
    
    func addAndRenderPanel() {
        self.addPanel()
        self.speedGameDelegate.renderPanel(self.currentPanelName())
    }
    
    func isCollectAnswer(ans: Bool) -> Bool {
        let removedPanel = self.panels.removeAtIndex(0)
        let isSame = removedPanel.id == self.previousId
        self.previousId = removedPanel.id
        return isSame == ans
    }
    
    override func gameOver() {
        self.delegate.renderResultView()
    }
}

extension SpeedGame {
    
    private func currentPanelId() -> Int {
        return self.panels[0].id
    }
    
    private func currentPanelName() -> String {
        return self.panels[0].name
    }
    
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
        var panels = SPEED_GAME_PANELS
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
        for tmpPanel in SPEED_GAME_PANELS {
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
        println("dump panels of speed game --->");
        for panel in self.panels {
            println("id:\(panel.id), name:\(panel.name)");
        }
    }
}