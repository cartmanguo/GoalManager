//
//  GoalDetailViewController.swift
//  GoalManager
//
//  Created by Line_Hu on 14-10-30.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

import UIKit

class GoalDetailViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,StatusButtonPressedDelegate
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var goalStatusLabel: UILabel!
    @IBOutlet weak var stasticsLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    var goal:Goal?
    var dates:[NSDate] = [NSDate]()
    var formatter = NSDateFormatter()
    var results = [GoalResult]()
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "yyyy-MM-dd"
        dates = Helper.getPastDates(goal!)
        //println("\(goal?.goalType.toString())")
        //GoalHelper.sharedInstance().queryForResults(self.goal!)
        results = GoalHelper.sharedInstance().queryForResults(self.goal!)
        var finishedInTotal = GoalHelper.sharedInstance().checkCompleteStatusForGoal(goal!)
        println("n:\(results.count)")
        let latestResult = results.last
        if latestResult?.progress < 1.0
        {
            statusButton.setBackgroundImage(UIImage(named: "uncheck"), forState: .Normal)
            goalStatusLabel.text = "今日未完成"
        }
        else
        {
            statusButton.setBackgroundImage(UIImage(named: "check"), forState: .Normal)
            goalStatusLabel.text = "今日已完成"
        }
        self.title = goal?.goalName
        stasticsLabel.text = "完成状况:\(finishedInTotal.finished)/\(finishedInTotal.total)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0
        {
            return goal?.goalType.toString()
        }
        else
        {
            return "创建日期 \(goal!.creationDate)"
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if goal!.goalType == .Daily
        {
            return results.count
        }
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell:GoalInfoCell?
        cell = tableView.dequeueReusableCellWithIdentifier("TimeCell") as? GoalInfoCell
        cell?.delegate = self
        if goal!.goalType == .Daily
        {
            let result = results[indexPath.row] as GoalResult
            cell?.textLabel.text = result.updateDate
            if result.progress < 1.0
            {
                cell?.statusButton.tintColor = UIColor.redColor()
                cell?.statusButton.setTitle("未完成", forState: .Normal)
            }
            else
            {
                cell?.statusButton.tintColor = UIColor(red: CGFloat(82.0/255.0), green: CGFloat(196.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(1.0))
                cell?.statusButton.setTitle("已完成", forState: .Normal)
            }
        }
        return cell!
    }
    
    func buttonPressed(sender:UIButton) {
        var indexPath = tableView.indexPathForRowAtPoint(tableView.convertPoint(sender.center, fromView: sender.superview))
        var cell = tableView.cellForRowAtIndexPath(indexPath!) as GoalInfoCell
        var result = results[indexPath!.row]
        var btnPoint = cell.convertPoint(cell.statusButton.center, toView: view)
        println("\(NSStringFromCGPoint(btnPoint))")
        btnPoint = CGPoint(x: btnPoint.x, y: btnPoint.y+60)
        var popover = PopoverView(point: btnPoint, titles: ["完成","放弃","未知"], images: nil)
        popover.selectRowAtIndex = {(index:Int) in
            
        }
        popover.show()
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
