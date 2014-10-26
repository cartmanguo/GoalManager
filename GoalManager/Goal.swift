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
}
