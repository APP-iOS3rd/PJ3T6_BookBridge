//
//  Validator.swift
//  BookBridge
//
//  Created by 이민호 on 1/31/24.
//

import Foundation
import SwiftUI

struct Validator {
    @StateObject var signUpVM : SignUpViewModel
    let format = FormatValidator()
    let redundant = RedundantValidator()
            
    func isValidEmail() {
        redundant.isValidEmail(email: signUpVM.email) { success in
            if success {
                if format.isValidEmail(email: signUpVM.email) {
                    print("이메일 인증 성공")
                    signUpVM.emailError = .success
                    signUpVM.isCertiActive = true
                    signUpVM.sendMail()
                } else {
                    print("이메일 인증 실패")
                    signUpVM.emailError = .invalid
                }
            } else {
                signUpVM.emailError = .redundant
            }
        }
    }
    
    func isValidNickname() {
        redundant.isValidNickname(nickname: signUpVM.nickname) { success in
            if success {
                if format.isValidNickname(nickname: signUpVM.nickname) {
                    print("닉네임 인증 성공")
                    signUpVM.nicknameError = .success
                } else {
                    print("닉네임 인증 실패")
                    signUpVM.nicknameError = .invalid
                }
            } else {
                signUpVM.nicknameError = .redundant
            }
        }
    }
        
}
