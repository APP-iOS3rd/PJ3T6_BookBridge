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
    
    static func getDong(address: String) -> String? {
        let components = address.components(separatedBy: " ")
           
       // 배열의 4번째 요소가 동을 나타내므로, 해당 요소를 반환합니다.
       guard components.indices.contains(3) else {
           return nil // 배열의 길이가 충분하지 않으면 nil을 반환합니다.
       }
       
       return components[3]
    }
}
