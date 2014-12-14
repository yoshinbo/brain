//
//  BookViewController.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/12/14.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import UIKit

class BookViewController: ModalBaseViewController {

    @IBOutlet weak var tableView: UITableView!

    class func build() -> (UINavigationController, BookViewController) {
        var storyboad: UIStoryboard = UIStoryboard(name: "Book", bundle: nil)
        var navigationController = storyboad.instantiateInitialViewController() as UINavigationController
        return (navigationController, navigationController.topViewController as BookViewController)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.navigationItem.title = "Book"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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

extension BookViewController: UITableViewDelegate, UITableViewDataSource {
    // for UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }

    // for UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brainKinds.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ContentCell", forIndexPath: indexPath) as BookViewContentCell
        self.aduptCell(cell, indexPath: indexPath)
        return cell
    }
}

extension BookViewController {
    private func aduptCell(cell:BookViewContentCell, indexPath:NSIndexPath) {
        var brain = User.getBrainByIndex(indexPath.row)
        cell.setParams(brain.id)
    }
}
