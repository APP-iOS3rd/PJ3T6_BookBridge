//
//  Validator.swift
//  BookBridge
//
//  Created by 이민호 on 1/31/24.
//

import Foundation

enum ValidType {
    case email
    case id
    case nickname
}

struct Validator {
    let format = FormatValidator()
    let redundant = RedundantValidator()
    
    func validate(type: ValidType, value: String) -> Bool {
        switch type {
        case .email:
            return isValidEmail(email: value)
            
        case .id:
            return isValidId(id: value)
            
        case .nickname:
            return isValidNickname(nickname: value)
        }
    }
    
    func isValidId(id: String) -> Bool {
        return
            // redundant.isValidId(id: id) &&
            format.isValidID(id: id)
    }
        
    func isValidEmail(email: String) -> Bool {
        return
            // redundant.isValidEmail(email: email) &&
            format.isValidEmail(email: email)
    }
                    
    func isValidNickname(nickname: String) -> Bool {
        return
            // redundant.isValidNickname(nickname: nickname)&&
            format.isValidNickname(nickname: nickname)
    }
    
//    func isValidPwd(pwd: String, confirmPwd: String) -> PwdError {
//        if pwd != confirmPwd {
//            return .wrong
//        }
//        
//        if !format.isValidPwd(pwd: pwd) {
//            return .invalid
//        }
//            
//        return .none
//    }
//        
    
    func isAllInput(id: String, nickname: String, pwd: String, confirmPwd: String) -> Bool {
        return
            !id.isEmpty &&
            !nickname.isEmpty &&
            !pwd.isEmpty &&
            !confirmPwd.isEmpty
          
    }
}
