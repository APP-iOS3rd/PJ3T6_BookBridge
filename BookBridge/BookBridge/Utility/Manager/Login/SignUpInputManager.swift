//
//  SignUpInputManager.swift
//  BookBridge
//
//  Created by 이민호 on 2/1/24.
//

import Foundation



class SignUpInputManager {
    var type: SignUpInputType
    var title: String
    var placeholder: String
    
    init(input: SignUpInputType ) {
        self.type = input
        
        switch type {
        case .phone:
            self.title = "휴대폰 번호"
            self.placeholder = "휴대폰번호를 입력해 주세요"
        case .pwd:
            self.title = "비밀번호"
            self.placeholder = "비밀번호를 입력해 주세요"
        case .pwdConfirm:
            self.title = "비밀번호 확인"
            self.placeholder = "비밀번호를 한번 더 입력해 주세요"
        }
    }
}
