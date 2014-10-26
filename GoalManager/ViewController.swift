//
//  ViewController.swift
//  GoalManager
//
//  Created by Line_Hu on 14-10-21.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView!
    var goals:[Goal] = []
    override func viewDidLoad()
    {
        super.viewDidLoad()
        goals = GoalHelper.sharedInstance().goals
        
        self.title = "My Goals"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
   override func viewWillAppear(animated: Bool) {
        //goals = GoalHelper.sharedInstance().goals
    }
    
    @IBAction func addNewGoal(sender: AnyObject) {
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        let goal = goals[indexPath.row] as Goal
        cell.textLabel.text = goal.goalName
        cell.detailTextLabel?.text = goal.goalDescription
        //println("\(goal.goalDescription)")
        return cell
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

