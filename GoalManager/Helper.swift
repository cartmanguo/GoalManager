//
//  Helper.swift
//  GoalManager
//
//  Created by Line_Hu on 14-10-24.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

import UIKit

class Helper: NSObject {
    class func dateToString()->String
    {
        let now = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.stringFromDate(now)
    }
}
