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
    case Unfinished = 1
    case Complete
    case Unknown
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
    var canAchieveAgain:Bool?
    init(goalID:Int,goldType:GoalType,goalDes:String,goalName:String,creationDate:String,progress:CGFloat)
    {
        self.goalType = goldType
        self.goalName = goalName
        self.goalDescription = goalDes
        self.creationDate = creationDate
        self.progress = progress
        self.id = goalID
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
    var status:GoalStatus
    init(id:Int,goalID:Int,goalType:GoalType,
        creationDate:String,updateDate:String,progress:CGFloat,status:GoalStatus)
    {
        self.id = id
        self.goal_id = goalID
        self.goalType = goalType
        self.creationDate = creationDate
        self.progress = progress
        self.updateDate = updateDate
        self.status = status
    }
}
