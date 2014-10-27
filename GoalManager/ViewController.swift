//
//  ViewController.swift
//  GoalManager
//
//  Created by Line_Hu on 14-10-21.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,SaveSuccessDelegate
{
    @IBOutlet weak var tableView: UITableView!
    var goals:[Goal] = []
    override func viewDidLoad()
    {
        super.viewDidLoad()
        goals = GoalHelper.sharedInstance().goals
        
        self.title = "My Goals"
        //tableView.registerClass(GoalInfoCell.self, forCellReuseIdentifier: "Cell")
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
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? GoalInfoCell
//        if cell == nil
//        {
//            cell = GoalInfoCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
//        }
        let goal = goals[indexPath.row] as Goal
        cell?.goalDesLabel.text = goal.goalDescription;
        cell?.goalNameLabel.text = goal.goalName
        //println("\(goal.goalDescription)")
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 71.0
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Add"
        {
            let destinationVC = segue.destinationViewController as UINavigationController
            var addVC = destinationVC.viewControllers.first as AddNewGoalViewController
            addVC.delegate = self
        }
    }
    
    func saveGoalSuccess() {
        println("refresh")
        
            self.goals = GoalHelper.sharedInstance().retrieveData()
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
    }
}

