//
//  CreationManager.swift
//  BookBridge
//
//  Created by 이민호 on 2/22/24.
//

import Foundation

class CreationManager {
    static func getRandomNickname() -> String {
        let str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let size = getRandomNumber()
        return str.createRandomStr(length: size)
    }
    
    static func getRandomNumber() -> Int {
        let lowerBound = 5
        let upperBound = 11
        return Int.random(in: lowerBound...upperBound)
    }
}
