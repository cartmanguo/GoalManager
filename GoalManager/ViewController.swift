//
//  ViewController.swift
//  GoalManager
//
//  Created by Line_Hu on 14-10-21.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,SaveSuccessDelegate,SWTableViewCellDelegate
{
    @IBOutlet weak var tableView: UITableView!
    var goals = [GoalType:[Goal]]()
    var selectedGoal:Goal?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //goals = GoalHelper.sharedInstance().goals
        self.title = "My Goals"
        //tableView.registerClass(GoalInfoCell.self, forCellReuseIdentifier: "Cell")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
   override func viewWillAppear(animated: Bool) {
        //goals = GoalHelper.sharedInstance().goals
    }
    
    func leftButtons()->[UIButton]
    {
        var buttons = [UIButton]()
        var completeButton = UIButton.buttonWithType(.Custom) as UIButton
        completeButton.backgroundColor = UIColor.greenColor()
        completeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        completeButton.setTitle("完成", forState: .Normal)
        buttons.append(completeButton)
//        var btn = UIButton.buttonWithType(.Custom) as UIButton
//        btn.backgroundColor = UIColor.orangeColor()

        return buttons
    }
    
    @IBAction func addNewGoal(sender: AnyObject) {
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var keys = [GoalType]()
        var dics = GoalHelper.sharedInstance().goalsDic
        for (key ,arr) in dics
        {
            keys.append(key)
        }
        let type = keys[section]
        return type.toString()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var goalsInTypes = [Goal]()
        var keys = [GoalType]()
        var dics = GoalHelper.sharedInstance().goalsDic
        for (key ,arr) in dics
        {
            keys.append(key)
        }
        let type = keys[section]
        if let g = dics[type]
        {
            return g.count
        }
        else
        {
            return 0
        }
        //return goalsInTypes.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return GoalHelper.sharedInstance().goalsDic.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? SWTableViewCell
//        if cell == nil
//        {
//            cell = GoalInfoCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
//        }
        var dics = GoalHelper.sharedInstance().goalsDic
        var keys = [GoalType]()
        for (key ,arr) in dics
        {
            keys.append(key)
        }
        let type = keys[indexPath.section]
        if let g = dics[type]
        {
            let goal = g[indexPath.row] as Goal
            cell?.textLabel.text = goal.goalDescription;
            cell?.detailTextLabel?.text = goal.goalName
            cell?.leftUtilityButtons = leftButtons()
            //println("\(goal.goalDescription)")
            return cell!
        }
//        goalsInTypes = GoalHelper.sharedInstance().goalsDic["\(indexPath.section)"]
//        let goal = goalsInTypes[indexPath.row] as Goal
//        cell?.goalDesLabel.text = goal.goalDescription;
//        cell?.goalNameLabel.text = goal.goalName
//        //println("\(goal.goalDescription)")
//        return cell!
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        var dics = GoalHelper.sharedInstance().goalsDic
        var keys = [GoalType]()
        for (key ,arr) in dics
        {
            keys.append(key)
        }
        let type = keys[indexPath.section]
        if let g = dics[type]
        {
            let goal = g[indexPath.row] as Goal
            GoalHelper.sharedInstance().deleteGoalFromDatabase(goal, completeHandler: {(result) in
                if result == true
                {
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var dics = GoalHelper.sharedInstance().goalsDic
        var keys = [GoalType]()
        for (key ,arr) in dics
        {
            keys.append(key)
        }
        let type = keys[indexPath.section]
        if let g = dics[type]
        {
            let goal = g[indexPath.row] as Goal
            selectedGoal = goal
            self .performSegueWithIdentifier("Detail", sender: nil)
        }
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
        else if segue.identifier == "Detail"
        {
            var goalDetailVC = segue.destinationViewController as GoalDetailViewController
            goalDetailVC.goal = selectedGoal
        }
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerLeftUtilityButtonWithIndex index: Int) {
        var indexPath:NSIndexPath = tableView.indexPathForCell(cell)!
        var dics = GoalHelper.sharedInstance().goalsDic
        var keys = [GoalType]()
        for (key ,arr) in dics
        {
            keys.append(key)
        }
        let type = keys[indexPath.section]
        if let g = dics[type]
        {
            let goal = g[indexPath.row] as Goal
            GoalHelper.sharedInstance().updateGoal(goal)
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

