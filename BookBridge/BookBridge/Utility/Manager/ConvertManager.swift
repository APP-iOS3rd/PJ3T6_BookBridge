//
//  ConvertManager.swift
//  BookBridge
//
//  Created by 이민호 on 2/8/24.
//

import Foundation

class ConvertManager {
        
    static func changeDistanceToKilometer(value: Int) -> Int {
        switch value {
        case 2:
            return 110
        case 3:
            return 120
        default:
            return 100
        }
    }
    
    static func changeKilometerToDistance(value: Int) -> Int {
        switch value {
        case 110:
            return 2
        case 120:
            return 3
        default:
            return 1
        }
    }
    
    static func getZoomValue(value: Int) -> Double {
        switch value {
        case 110:
            return 12
        case 120:
            return 11.7
        default:
            return 13
        }
    }
    
    static func getTimeDifference(from date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date, to: now)
        
        if let year = components.year, year > 0 {
            return "\(year)년전"
        } else if let month = components.month, month > 0 {
            return "\(month)달전"
        } else if let day = components.day, day > 0 {
            return "\(day)일전"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour)시간전"
        } else {
            return "방금 전"
        }
    }
}
