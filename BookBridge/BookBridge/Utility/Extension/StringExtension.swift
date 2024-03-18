//
//  CharacterExtension.swift
//  BookBridge
//
//  Created by 이민호 on 2/22/24.
//

import Foundation

public extension String {
    func createRandomStr(length: Int) -> String {
        let str = (0 ..< length).map{ _ in self.randomElement()! }
        return String(str)
    }
    
    static func randomHangul(digits: Int = 1) -> String {
        return (0..<digits).reduce("") { (value, _) in
            return value + "\(Character.randomHangul())"
        }
    }
}

// 랜덤 한글 기능
public extension Character {
    static func randomHangul() -> Character {
        let startHexIndex: String = "AC00"
        let endHexIndex: String = "D7AF"
        guard let startDecIndex = Int(startHexIndex, radix: 16) else { return "엥" }
        guard let endDecIndex = Int(endHexIndex, radix: 16) else { return "엥" }
        
        let randomIndex = Int.random(in: startDecIndex...endDecIndex)
        guard let unicode = UnicodeScalar(randomIndex) else { return "엥" }
        
        return Character(unicode)
    }
}



