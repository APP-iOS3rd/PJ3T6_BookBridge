//
//  CertificationError.swift
//  BookBridge
//
//  Created by 이민호 on 3/5/24.
//

import Foundation

enum CertificationError: String {
    case invalid = "인증번호가 올바르지 않습니다."
    case success = "인증이 완료되었습니다."
    case incomplete = "인증절차가 완료되지 않았습니다."
    
    func getColor() -> String {
        switch self {
        case .invalid:
            return "F80B0B"
        case .success:
            return "0A84FF"
        case .incomplete:
            return "F80B0B"
        }
    
    }
}
