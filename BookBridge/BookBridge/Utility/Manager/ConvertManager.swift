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
}
