//
//  DateUtil.swift
//  brain
//
//  Created by Yoshikazu Oda on 2014/11/16.
//  Copyright (c) 2014年 yoshinbo. All rights reserved.
//

import Foundation

class DateUtil {

    class func now() -> Double {
        let date: NSDate = NSDate()
        return date.timeIntervalSince1970
    }

    class func getHourMinuteString(unixTime:Double) -> String {
        let date: NSDate = NSDate(timeIntervalSince1970: unixTime)
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let calendarComponent = calendar.components(
            NSCalendarUnit.CalendarUnitHour |
            NSCalendarUnit.CalendarUnitMinute,
            fromDate: date
        )
        return "\(calendarComponent.hour):\(calendarComponent.minute)"
    }
}
