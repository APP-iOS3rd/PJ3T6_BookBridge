//
//  PwdConfirmError.swift
//  BookBridge
//
//  Created by 이민호 on 2/2/24.
//

import Foundation

enum PwdConfirmError: String {
    case wrong = "비밀번호가 서로 일치하지 않습니다."
    case invalid = "비밀번호를 영어, 숫자, 특수문자를 사용하여 8~16글자 로 작성해주세요"
    case empty = "비밀번호 확인이 입력되지 않았습니다."
    case none = ""
}
