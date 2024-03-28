//
//  SignUpInputer.swift
//  BookBridge
//
//  Created by 이민호 on 1/30/24.
//

import Foundation

enum SignUpInput {
    case email
    case nickName
}

class SignUpInputer {
    var title: String
    var placeholder: String
    var status: [String]
    var btnTitle: String
    var type: SignUpInput
    
    init(input: SignUpInput) {
        type = input
        
        switch input {
            
        case .email:
            self.title = "이메일"
            self.placeholder = "이메일을 입력해주세요"
            self.status = ["이메일 형식이 올바르지 않습니다.", "인증메일이 전송되었습니다."]
            self.btnTitle = "인증하기"
       
        case .nickName:
            self.title = "닉네임"
            self.placeholder = "닉네임을 입력해주세요"
            self.status = ["중복된 닉네임 입니다.", "사용 가능한 닉네임 입니다."]
            self.btnTitle = "중복확인"
        }
                                
    }
}


