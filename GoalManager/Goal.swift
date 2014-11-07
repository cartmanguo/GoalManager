//
//  Goal.swift
//  GoalManager
//
//  Created by Line_Hu on 14-10-21.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

import UIKit
enum GoalType:Int
{
    case OneTime = 1
    case Daily
    case Weekly
    case Monthly
    case Progress
}

enum GoalStatus:Int
{
    case unFinished = 1
    case complete
    case unKnown
}

extension GoalType
{
    func toString()->String
    {
        switch self
        {
        case .Daily:
            return "Daily"
        case .OneTime:
            return "One-Time"
        case .Weekly:
            return "Weekly"
        case .Monthly:
            return "Monthly"
        case .Progress:
            return "Progressive"
        }
    }
    func toInt()->Int
    {
        return self.rawValue
    }
}

struct Goal
{
    var id:Int
    var goalType:GoalType
    var goalName:String
    var goalDescription:String
    var creationDate:String
    var progress:CGFloat
    init(goalID:Int,goldType:GoalType,goalDes:String,goalName:String,creationDate:String,progress:CGFloat)
    {
        self.goalType = goldType
        self.goalName = goalName
        self.goalDescription = goalDes
        self.creationDate = creationDate
        self.progress = progress
        self.id = goalID
    }
    func isGoalAvailableToAcheieveAgain()->Bool
    {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let now = NSDate()
        let creationDate = formatter.dateFromString(self.creationDate)
        let interval = now.timeIntervalSinceDate(creationDate!)
        println("cr:\(interval)")
        if interval > 86400.0
        {
            println("available")
            return true
        }
        return false
    }
    
    func isGoalAvailableToUpdate()->Bool
    {
        if self.progress == 0.0
        {
            return true
        }
        return false
    }
}

struct GoalResult
{
    var id:Int
    var goal_id:Int
    var goalType:GoalType
    var creationDate:String
    var updateDate:String

    //var status:GoalStatus
    var progress:CGFloat
    init(id:Int,goalID:Int,goalType:GoalType,
        creationDate:String,updateDate:String,progress:CGFloat)
    {
        self.id = id
        self.goal_id = goalID
        self.goalType = goalType
        self.creationDate = creationDate
        self.progress = progress
        self.updateDate = updateDate
    }
}
