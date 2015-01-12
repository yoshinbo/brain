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

    class func day() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let unitFlags: NSCalendarUnit = .CalendarUnitEra | .CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay
        let dateComponents = calendar.components(unitFlags, fromDate: NSDate())
        return dateComponents.day
    }

    class func getHourMinuteString(unixTime:Double) -> String {
        let date: NSDate = NSDate(timeIntervalSince1970: unixTime)
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let calendarComponent = calendar.components(
            NSCalendarUnit.CalendarUnitHour |
            NSCalendarUnit.CalendarUnitMinute,
            fromDate: date
        )
        return NSString(
            format: NSLocalizedString("degitalClock", comment: ""),
            calendarComponent.hour, calendarComponent.minute
        )
    }

    class func getUntilTime(unixtTime:Double) -> String {
        var untilTimeString: String
        var untilSec = unixtTime - now()
        if untilSec <= 0 {
            untilTimeString = NSLocalizedString("allRecovery", comment: "")
        } else if untilSec < 60 {
            untilTimeString = NSString(
                format: NSLocalizedString("degitalClockForRecovery", comment: ""),
                0, Int(untilSec)
            )
        } else if untilSec < 60 * 60 {
            var min = untilSec / 60
            var sec = untilSec % 60
            untilTimeString = NSString(
                format: NSLocalizedString("degitalClockForRecovery", comment: ""),
                Int(min), Int(sec)
            )
        } else {
            var hour = untilSec / 60 * 60
            var min = untilSec % 60 * 60
            untilTimeString = NSString(
                format: NSLocalizedString("degitalClockForRecovery", comment: ""),
                Int(hour), Int(min)
            )
        }
        return untilTimeString
    }
}
