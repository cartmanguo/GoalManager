//
//  TypeSelectViewController.swift
//  GoalManager
//
//  Created by Line_Hu on 14-10-24.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

import UIKit
protocol DidSelectGoalTypeDelegate
{
    func didSelecteGoalType(goalType:GoalType)
}
class TypeSelectViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    let oneTimeType = GoalType.Progress
    let values:[GoalType] = [.Daily,.Weekly,.Monthly,.OneTime,.Progress]
    var delegate:DidSelectGoalTypeDelegate!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        let type = values[indexPath.row] as GoalType
        cell.textLabel.text = type.toString()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate.didSelecteGoalType(values[indexPath.row])
        self.navigationController?.popViewControllerAnimated(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
