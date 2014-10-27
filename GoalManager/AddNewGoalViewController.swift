//
//  AddNewGoalViewController.swift
//  GoalManager
//
//  Created by Line_Hu on 14-10-24.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

import UIKit
protocol SaveSuccessDelegate
{
    func saveGoalSuccess()
}
class AddNewGoalViewController: UIViewController,DidSelectGoalTypeDelegate {

    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var goalDescriptionTextField: UITextField!
    @IBOutlet weak var goalNameTextField: UITextField!
    var delegate:SaveSuccessDelegate?
    var goalName:String?
    var goalDescription:String?
    var goalType:GoalType?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        typeButton.titleLabel?.textAlignment = NSTextAlignment.Left
        typeButton.titleLabel?.numberOfLines = 1
        typeButton.sizeToFit()
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel")
        self.navigationItem.leftBarButtonItem = cancelButton
        let doneButton = UIBarButtonItem(title: "Save", style: .Done, target: self, action: "saveGoal")
        self.navigationItem.rightBarButtonItem = doneButton
        // Do any additional setup after loading the view.
    }
    
    func cancel()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveGoal()
    {
        if let goal = goalType?
        {
            if(countElements(goalNameTextField.text) == 0)
            {
                let alert = UIAlertController(title: "错误", message: "未输入目标名", preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else
            {
                let goal = Goal(goalID: GoalHelper.sharedInstance().numberOfData ,goldType: goalType!, goalDes: goalDescriptionTextField.text, goalName: goalNameTextField.text, creationDate: Helper.dateToString(), progress: 0.0)
                GoalHelper.sharedInstance().saveGoalToDatabase(goal, completeHandler: {(result) in
                    if result == true
                    {
                        self.dismissViewControllerAnimated(true, completion: {
                            self.delegate!.saveGoalSuccess()
                        })
                    }
                })
            }
        }
        else
        {
            let alert = UIAlertController(title: "错误", message: "未选择目标类型", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "TypeSelect"
        {
            var destinationVC:TypeSelectViewController = segue.destinationViewController as TypeSelectViewController
            destinationVC.delegate = self
        }
    }
    
    func didSelecteGoalType(goalType: GoalType) {
        self.goalType = goalType
        typeButton.setTitle("目标类型:"+goalType.toString(), forState: .Normal)
    }

}
