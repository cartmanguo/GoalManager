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
    var goals:[Goal] = []
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
                        goals.append(goal)
                    }
                    numberOfData = goals.count
                    println("\(goals.count)")
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
            println("save to data base ok")
            numberOfData++
        }
    }
    
    func retrieveData()->[Goal]
    {
        var queryResult = userDatabase?.executeQuery("SELECT id,name,description,date,type,progress FROM myGoals", withParameterDictionary: nil)
        var results:[Goal] = []
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
            results.append(goal)
        }
        numberOfData = goals.count
        return results
    }
}
