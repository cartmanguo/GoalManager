//
//  GoalHelper.swift
//  GoalManager
//
//  Created by Line_Hu on 14-10-21.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

import UIKit
class GoalHelper: NSObject {
    var userDatabase:FMDatabase?
    var dbExisted:Bool?
    var numberOfData:Int = 0
    var results = [GoalResult]()
    var goals:[Goal] = [Goal]()
    var dailyGoals:[Goal] = [Goal]()
    var monthlyGoals:[Goal] = [Goal]()
    var weeklyGoals:[Goal] = [Goal]()
    var one_timeGoals:[Goal] = [Goal]()
    var progresiveGoals:[Goal] = [Goal]()
    var goalsDic = [GoalType:[Goal]]()
    var numberOfTypes:Int
    {
        get
        {
            var initial = 0
            if dailyGoals.count > 0
            {
                initial++
            }
            if weeklyGoals.count > 0
            {
                initial++
            }
            if monthlyGoals.count > 0
            {
                initial++
            }
            if one_timeGoals.count > 0
            {
                initial++
            }
            if progresiveGoals.count > 0
            {
                initial++
            }
            return initial
        }
    }
    class func sharedInstance()->GoalHelper
    {
        struct qzSingle{
            static var predicate:dispatch_once_t = 0;
            static var instance:GoalHelper? = nil
        }
        //保证单例只创建一次
        dispatch_once(&qzSingle.predicate,{
            qzSingle.instance = GoalHelper()
        })
        return qzSingle.instance!
    }
    
    func createGoldWithName(goalID:Int, goalName:String,goalType:GoalType,description:String,creationDate:String,progress:CGFloat)->Goal
    {
        let goal = Goal(goalID:goalID, goldType: goalType, goalDes: description, goalName: goalName, creationDate: creationDate,progress:progress)
        return goal
    }
    
    //MARK:- IsExisted
    func isTableExisted(tableName:String)->Bool
    {
        var result = userDatabase?.executeQuery("SELECT count(*) as 'count' FROM sqlite_master WHERE type = 'table' and name = '\(tableName)'", withArgumentsInArray: nil)
        while result?.next() == true
        {
            let count = result?.intForColumn("count")
            if count == 0
            {
                return false
            }
            else
            {
                return true
            }
        }
        return false
    }
    
    //MARK:- Create DB
    func createDatabase()
    {
        var docPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first as String
        let dbPath = docPath + "/myGoals.db"
        println("\(dbPath)")
            userDatabase = FMDatabase(path: dbPath)
            if userDatabase?.open() == false
            {
                println("error open file")
            }
            else
            {
                if isTableExisted("results")
                {
                    
                }
                else
                {
                    let sqlCreate = "CREATE TABLE results (id INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL,goal_id INTEGER ,date VARCHAR(32),update_date VARCHAR(32),type INTEGER, progress DECIMAL(4,1),status INTEGER)";
                    let result = userDatabase?.executeUpdate(sqlCreate, withParameterDictionary: nil)
                    if result == true
                    {
                        println("create table ok")
                    }
                }
                if isTableExisted("myGoals")
                {
                    println("existed")
                    dbExisted = true
                    var queryResult = userDatabase?.executeQuery("SELECT id,name,description,date,type,progress FROM myGoals", withParameterDictionary: nil)
                    while queryResult?.next() == true
                    {
                        let id = queryResult?.intForColumn("id")
                        let name = queryResult?.stringForColumn("name")
                        let description = queryResult?.stringForColumn("description")
                        let date = queryResult?.stringForColumn("date")
                        let a = Int(queryResult!.intForColumn("type"))
                        let type:GoalType = GoalType(rawValue: a)!
                        let goalProgress = CGFloat(queryResult!.doubleForColumn("progress"))
                        var goal:Goal = Goal(goalID: Int(id!), goldType: type, goalDes: description!, goalName: name!, creationDate: date!, progress: goalProgress)
                        switch type
                        {
                            case .Daily:
                            dailyGoals.append(goal)
                            case .Weekly:
                            weeklyGoals.append(goal)
                            case .Monthly:
                            monthlyGoals.append(goal)
                            case .OneTime:
                            one_timeGoals.append(goal)
                            case .Progress:
                            progresiveGoals.append(goal)
                        }
                        goals.append(goal)
                    }
                    if dailyGoals.count > 0
                    {
                        goalsDic[.Daily] = dailyGoals
                    }
                    if weeklyGoals.count > 0
                    {
                        goalsDic[.Weekly] = weeklyGoals
                    }
                    if monthlyGoals.count > 0
                    {
                        goalsDic[.Monthly] = monthlyGoals
                    }
                    if one_timeGoals.count > 0
                    {
                        goalsDic[.OneTime] = one_timeGoals
                    }
                    if progresiveGoals.count > 0
                    {
                        goalsDic[.Progress] = progresiveGoals
                    }
                    numberOfData = goals.count
                    //println("\(goalsInTypes.count)")
                }
                else
                {
                    println("create table")
                    let sqlCreate = "CREATE TABLE myGoals (id INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, name VARCHAR(128),description VARCHAR(1024),date VARCHAR(32),type INTEGER, progress DECIMAL(4,1))";
                    let result = userDatabase?.executeUpdate(sqlCreate, withParameterDictionary: nil)
                    if result == true
                    {
                        println("create table ok")
                    }
                }
            }

    }
    
    //MARK:- Save Goal
    func saveGoalToDatabase(goal:Goal,completeHandler:(result:Bool)->Void)
    {
        var fmResult = userDatabase?.executeQuery("SELECT COUNT(*) FROM SQLITE_MASTER WHERE TYPE='table' AND NAME='myGoals'", withParameterDictionary: nil)
        fmResult?.next()
        let count = fmResult?.intForColumnIndex(0)
        println("data count:\(count!)")

        let goalName = goal.goalName
        let goalType = goal.goalType
        let creationDate = goal.creationDate
        let goalDescription = goal.goalDescription
        let progress = goal.progress
        var insertSql = "INSERT INTO myGoals VALUES";
        let value = "('\(numberOfData+1)','\(goalName)','\(goalDescription)','\(creationDate)','\(goalType.rawValue)','\(progress)')"
        insertSql += value
        println("\(insertSql)")
        var result = userDatabase?.executeUpdate(insertSql, withParameterDictionary: nil)
        completeHandler(result: result!)
        if result == true
        {
            numberOfData++
            println("save to data base ok:\(numberOfData)")
//            var now = NSDate()
//            let formatter = NSDateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd"
//            var dateString = formatter.stringFromDate(now)
//
//            var querySql = "SELECT COUNT(goal_id) as 'dataCount' FROM results"
//            var result = userDatabase?.executeQuery(querySql, withParameterDictionary: nil)
//            while result?.next() == true
//            {
//                var dataCount = Int(result!.intForColumn("dataCount"))
//                let insertDataSql = "INSERT INTO results VALUES (\(dataCount+1),'\(numberOfData)','\(creationDate)','\(dateString)','\(goal.goalType.rawValue)','\(progress)')"
//                let result = userDatabase?.executeUpdate(insertDataSql, withParameterDictionary: nil)
//                if result == true
//                {
//                    println("save ok!")
//                }
//            }
        }
    }
    
    //MARK:- UPDate Goal
    func updateGoal(goal:Goal,progress:CGFloat)
    {
        var now = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var dateString = formatter.stringFromDate(now)
        var querySql = "SELECT COUNT(goal_id) as 'dataCount' FROM results WHERE goal_id=\(goal.id)"
        var result = userDatabase?.executeQuery(querySql, withParameterDictionary: nil)
        while result?.next() == true
        {
            var dataString = Helper.dateToString()
            var dataCount = Int(result!.intForColumn("dataCount"))
            if dataCount == 0
            {
                let insertDataSql = "INSERT INTO results VALUES ('\(dataCount+1)','\(goal.id)','\(goal.creationDate)','\(dateString)','\(goal.goalType.rawValue)','\(progress)')"
                let result = userDatabase?.executeUpdate(insertDataSql, withParameterDictionary: nil)
                if result == true
                {
                    println("save ok!")
                }
            }
            else
            {
                let updateSql = "UPDATE results SET progress = \(progress),update_date = \(dateString) WHERE "
            }
        }
    }
    
    func addNewRecordInResults()
    {
        
    }
    
    
    func isGoalAvailableToAcheieveAgain(goal:Goal)->Bool
    {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let now = NSDate()
        let creationDate = formatter.dateFromString(goal.creationDate)
        let interval = now.timeIntervalSinceDate(creationDate!)
        var querySql = "SELECT COUNT(goal_id) as 'dataCount' FROM results WHERE goal_id=\(goal.id)"
        var result = userDatabase?.executeQuery(querySql, withParameterDictionary: nil)
        var dataCount:Int?
        while result?.next() == true
        {
            dataCount = Int(result!.intForColumn("dataCount"))
        }
        println("cr:\(interval)")
        if interval > 86400.0 || dataCount == 0
        {
            println("available")
            return true
        }
        else if interval < 86400 && goal.progress > 0.0
        {
            return false
        }
        return false
    }

    func canBeCompletedForGoal(goal:Goal)->Bool
    {
        var querySql = "SELECT COUNT(goal_id) as 'dataCount' FROM results WHERE goal_id=\(goal.id)"
        var result = userDatabase?.executeQuery(querySql, withParameterDictionary: nil)
        var dataCount:Int?
        while result?.next() == true
        {
            dataCount = Int(result!.intForColumn("dataCount"))
        }
        if dataCount == 0
        {
            return true
        }

        var queryForLast = "select * from results where goal_id = \(goal.id) order by id desc limit 1"
        var results = userDatabase?.executeQuery(queryForLast, withParameterDictionary: nil)
        while results?.next() == true
        {
            let status = GoalStatus(rawValue: Int(results!.intForColumn("status")))!
            if status == .Unfinished
            {
                return true
            }
        }
        return false
    }
    
    func isNewDayForGoal(goal:Goal)->Bool
    {
        var querySql = "SELECT COUNT(goal_id) as 'dataCount' FROM results WHERE goal_id=\(goal.id)"
        var result = userDatabase?.executeQuery(querySql, withParameterDictionary: nil)
        var dataCount:Int?
        while result?.next() == true
        {
            dataCount = Int(result!.intForColumn("dataCount"))
        }
        if dataCount == 0
        {
            return true
        }

        var queryForLast = "select * from results where goal_id = \(goal.id) order by id desc limit 1"
        var results = userDatabase?.executeQuery(queryForLast, withParameterDictionary: nil)
        while results?.next() == true
        {
            let id = results?.intForColumn("id")
            let updateDateString = results?.stringForColumn("update_date")
            var now = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            var update_date = formatter.dateFromString(updateDateString!)
            let status = GoalStatus(rawValue: Int(results!.intForColumn("status")))!
            var gregorianCalendar = NSCalendar(identifier: NSGregorianCalendar)
            // Notice the components:NSDayCalendarUnit specifier
            var components = gregorianCalendar?.components(.DayCalendarUnit, fromDate: update_date!, toDate: now, options: .WrapComponents)
            let days = components?.day
            println("d:\(days)")
            if days >= 1
            {
                //one day has passed since the last update
                return true
            }
        }
        return false
    }
    
    func updateResultsForGoal(goal:Goal,progress:CGFloat,newStatus:GoalStatus)
    {
        var now = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var dateString = formatter.stringFromDate(now)
        
        var querySql = "SELECT COUNT(goal_id) as 'dataCount' FROM results"
        var result = userDatabase?.executeQuery(querySql, withParameterDictionary: nil)
        while result?.next() == true
        {
            let s = newStatus.rawValue
            var dataString = Helper.dateToString()
            var dataCount = Int(result!.intForColumn("dataCount"))
            if dataCount == 0 || isNewDayForGoal(goal)
            {
                let insertDataSql = "INSERT INTO results VALUES ('\(dataCount+1)','\(goal.id)','\(goal.creationDate)','\(dateString)','\(goal.goalType.rawValue)','\(progress)','\(s)')"
                let result = userDatabase?.executeUpdate(insertDataSql, withParameterDictionary: nil)
                if result == true
                {
                    println("save ok!")
                }
            }
            else
            {
                var sqlForLatestID = "SELECT MAX(id) as 'LatestID' FROM results WHERE goal_id = '\(goal.id)'"
                var result = userDatabase?.executeQuery(sqlForLatestID, withParameterDictionary: nil);
                while result?.next() == true
                {
                    let latestID = result?.intForColumn("LatestID")
                    let updateSql = "UPDATE results SET progress = '\(progress)',update_date = '\(dateString)',status='\(s)' WHERE id = \(latestID!)"
                    println("\(updateSql)")
                    println("\(dateString)")
                    var exeResult = userDatabase?.executeUpdate(updateSql, withParameterDictionary: nil)
                    if exeResult == true
                    {
                        println("update ok")
                    }
                }
            }
        }
    }
    
    //MARK:- Check Results
    func queryForResults(goal:Goal)->[GoalResult]
    {
        var querySql = "SELECT * FROM results WHERE goal_id = '\(goal.id)'"
        var queryResult = userDatabase?.executeQuery(querySql, withParameterDictionary: nil)
        var results = [GoalResult]()
        while queryResult?.next() == true
        {
            let id = queryResult?.intForColumn("id")
            let goal_id = queryResult?.intForColumn("goal_id");
            let date = queryResult?.stringForColumn("date")
            let update_date = queryResult?.stringForColumn("update_date")
            let type = GoalType(rawValue: Int(queryResult!.intForColumn("type")))!
            let progress = CGFloat(queryResult!.doubleForColumn("progress"))
            let a = Int(queryResult!.intForColumn("status"))
            let goalStatus:GoalStatus = GoalStatus(rawValue: a)!
            var result = GoalResult(id: Int(id!), goalID: Int(goal_id!), goalType: type, creationDate: date!, updateDate:update_date!,progress: progress,status:goalStatus)
            results.append(result)
        }
        return results
    }
    
    //MARK:- Delete Goal
    func deleteGoalFromDatabase(goal:Goal,completeHandler:(exeResult:Bool)->Void)
    {
        let id = goal.id
        var deleteSql = "DELETE FROM myGoals Where id=\(id)"
        var result = userDatabase?.executeUpdate(deleteSql, withParameterDictionary: nil)
        if let rt = result
        {
            retrieveData()
            completeHandler(exeResult: rt)
        }
        //also delete the goal in resutls table
        deleteSql = "DELETE FROM results WHERE goal_id = \(goal.id)"
        result = userDatabase?.executeUpdate(deleteSql, withParameterDictionary: nil)
        if result == true
        {
            println("delete from results")
        }
    }
    
    func finishGoal(goal:Goal)
    {
        var finishSql = "UPDATE myGoals SET progress = 1.0 WHERE id = \(goal.id)";
        var result = userDatabase?.executeUpdate(finishSql, withParameterDictionary: nil)
        if result == true
        {
            println("finish")
            updateResultsForGoal(goal, progress: 1.0,newStatus: .Complete)
            retrieveData()
        }
    }
    
    func forfeitGoal(goal:Goal)
    {
        var finishSql = "UPDATE myGoals SET progress = 0.0 WHERE id = \(goal.id)";
        var result = userDatabase?.executeUpdate(finishSql, withParameterDictionary: nil)
        if result == true
        {
            println("forfeit")
            updateResultsForGoal(goal, progress: 0.0,newStatus: .Unfinished)
            retrieveData()
        }
    }
    
    //MARK:- Get Goals
    func retrieveData()->[GoalType:[Goal]]
    {
        var queryResult = userDatabase?.executeQuery("SELECT id,name,description,date,type,progress FROM myGoals", withParameterDictionary: nil)
        var goals:[Goal] = [Goal]()
        var dailyGoals:[Goal] = [Goal]()
        var monthlyGoals:[Goal] = [Goal]()
        var weeklyGoals:[Goal] = [Goal]()
        var one_timeGoals:[Goal] = [Goal]()
        var progresiveGoals:[Goal] = [Goal]()
        var goalsDic = [GoalType:[Goal]]()
        while queryResult?.next() == true
        {
            let id = queryResult?.intForColumn("id")
            let name = queryResult?.stringForColumn("name")
            let description = queryResult?.stringForColumn("description")
            let date = queryResult?.stringForColumn("date")
            let a = Int(queryResult!.intForColumn("type"))
            let type:GoalType = GoalType(rawValue: a)!
            let goalProgress = CGFloat(queryResult!.doubleForColumn("progress"))
            var goal:Goal = Goal(goalID: Int(id!), goldType: type, goalDes: description!, goalName: name!, creationDate: date!, progress: goalProgress)
            //results.append(goal)
            switch type
            {
            case .Daily:
                dailyGoals.append(goal)
            case .Weekly:
                weeklyGoals.append(goal)
            case .Monthly:
                monthlyGoals.append(goal)
            case .OneTime:
                one_timeGoals.append(goal)
            case .Progress:
                progresiveGoals.append(goal)
            }
            goals.append(goal)
        }
        if dailyGoals.count > 0
        {
            goalsDic[.Daily] = dailyGoals
        }
        if weeklyGoals.count > 0
        {
            goalsDic[.Weekly] = weeklyGoals
        }
        if monthlyGoals.count > 0
        {
            goalsDic[.Monthly] = monthlyGoals
        }
        if one_timeGoals.count > 0
        {
            goalsDic[.OneTime] = one_timeGoals
        }
        if progresiveGoals.count > 0
        {
            goalsDic[.Progress] = progresiveGoals
        }
        //println("\(goalsDic)")
        self.goalsDic = goalsDic
        numberOfData = goals.count
        return goalsDic
    }
}
