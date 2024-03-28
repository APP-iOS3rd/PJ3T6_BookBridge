//
//  PhoneError.swift
//  BookBridge
//
//  Created by 이민호 on 2/2/24.
//

import Foundation

enum PhoneError: String {
    case invalid = "휴대폰 번호가 올바르지 않습니다."
    case empty = "휴대폰 번호가 입력되지 않았습니다."
    case none = "가입되지 않은 휴대폰번호입니다."
    case success = "인증번호가 전송되었습니다."
    case incomplete = "휴대폰 인증이 완료되지 않았습니다."
    case blocked = "비정상적인 접근으로 인해 핸드폰 인증이 정지되었습니다.\n잠시후에 시도해주시기 바랍니다."
    
    func getColor() -> String {
        switch self {
        case .invalid:
            return "F80B0B"
        case .empty:
            return "F80B0B"
        case .none:
            return "F80B0B"
        case .success:
            return "0A84FF"
        case .incomplete:
            return "F80B0B"
        case .blocked:
            return "F80B0B"
        }
    }
}
