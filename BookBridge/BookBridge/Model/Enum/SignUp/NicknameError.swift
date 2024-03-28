//
//  NicknameError.swift
//  BookBridge
//
//  Created by 이민호 on 2/2/24.
//

import Foundation

enum NicknameError: String {
    case invalid = "잘못된 닉네임 형식입니다."
    case redundant = "이미 가입한 닉네임 입니다."
    case success = "사용가능한 닉네임 입니다."
    
    func getColor() -> String {
        switch self {
        case .invalid:
            return "F80B0B"
        case .redundant:
            return "F80B0B"
        case .success:
            return "0A84FF"
        }
    }
    
}
