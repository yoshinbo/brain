//
//  GameSelectViewController.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/02.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit

class GameSelectViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var gameModel: Games!
    
    class func build() -> GameSelectViewController {
        var storyboad: UIStoryboard = UIStoryboard(name: "GameSelect", bundle: nil)
        var viewController = storyboad.instantiateInitialViewController() as GameSelectViewController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.gameModel = Games()
        
        //self.addBackButton()
        self.navigationItem.title = "Game Select"
        // For removing misterious space on table view header
        //self.automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GameSelectViewController {
    
    private func aduptCell(cell:GameSelectContentCell, indexPath:NSIndexPath) {
        var game = self.gameModel.getById(indexPath.row)
        cell.setParams(game);
    }
    
    // タッチした座興からNSIndexPathを返す
    private func indexPathForControlEvent(event: UIEvent) -> NSIndexPath {
        var point = event.allTouches()?.anyObject()?.locationInView(self.tableView)
        return self.tableView.indexPathForRowAtPoint(point!)!
    }
    
    func onClickHelpButton(sender: UIButton, event: UIEvent) {
        var indexPath = self.indexPathForControlEvent(event)
        var cell = tableView.cellForRowAtIndexPath(indexPath) as GameSelectContentCell
        if cell.game!.isSpeedMatch() {
            var (navigationController, viewController) = HelpViewController.build()
            viewController.gameTitle = cell.game!.title
            self.moveTo(navigationController)
        } else
        if cell.game!.isColorMatch() {
            println("color")
        }

    }
}

extension GameSelectViewController: UITableViewDelegate, UITableViewDataSource {
    // for UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath) as GameSelectContentCell
        if cell.game!.isSpeedMatch() {
            self.moveToInNavigationController(SpeedMatchViewController.build())
        } else
        if cell.game!.isColorMatch() {
            println("color")
        }
    }
    
    // for UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gameModel.totalGameNum()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ContentCell", forIndexPath: indexPath) as GameSelectContentCell
        self.aduptCell(cell, indexPath: indexPath)
        cell.helpButton.addTarget(self, action: "onClickHelpButton:event:", forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
}
