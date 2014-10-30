//
//  Helper.swift
//  GoalManager
//
//  Created by Line_Hu on 14-10-24.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

import UIKit

class Helper: NSObject {
    let interval = -86400
    class func dateToString()->String
    {
        let now = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.stringFromDate(now)
    }
    class func intervalDaysFromCreationDateToday(goal:Goal)->Int
    {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let createtionDate = formatter.dateFromString(goal.creationDate)
        var calendar = NSCalendar.currentCalendar()
        var today = NSDate()
        var component = calendar.components(NSCalendarUnit.DayCalendarUnit, fromDate: createtionDate!, toDate: today, options: NSCalendarOptions.allZeros)
        var result = component.day + 2
        if result > 30
        {
            result = 30
        }
        return result
    }
    class func getPastDates(goal:Goal)->[NSDate]
    {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let createtionDate = formatter.dateFromString(goal.creationDate)
        var calendar = NSCalendar.currentCalendar()
        var today = NSDate()
        var component = calendar.components(NSCalendarUnit.DayCalendarUnit, fromDate: createtionDate!, toDate: today, options: NSCalendarOptions.allZeros)
        var result = component.day + 2
        if result > 30
        {
            result = 30
        }
        var dates = [NSDate]()
        let secondsPerDay = -86400
        for var i = 0;i<result;i++
        {
            var pastDate = today.dateByAddingTimeInterval((-86400.0)*Double(i))
            dates.append(pastDate)
        }
        return dates
    }
}
