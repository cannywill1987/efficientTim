//
//  CountDownUtil.swift
//  Runner
//
//  Created by 林智彬 on 2023/8/29.
//

import Foundation


class CountDownUtil {
    
    static func getDateYMD(y:Int,m:Int,d:Int) -> Date {
        var date = DateComponents()
        date.year = y
        date.month = m
        date.day = d
        
        let dateObj = Calendar.current.date(from: date)
        
        print("Given date: \(dateObj!)")
        return  dateObj!
    }
}
