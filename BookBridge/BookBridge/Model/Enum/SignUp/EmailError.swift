//
//  EmailError.swift
//  BookBridge
//
//  Created by 이민호 on 2/2/24.
//

import Foundation

enum EmailError: String {
    case invalid = "잘못된 이메일 형식입니다."
    case redundant = "이미 가입한 이메일 입니다."    
    case success = "이메일 인증이 완료되었습니다."
    case none = "가입된 이메일이 없습니다."
    case incomplete = "이메일 인증이 완료되지 않았습니다."
    case abnomal = "비정상적인 접근입니다. 잠시후에 다시 시도해주시기 바랍니다."
    
    func getColor() -> String {
        switch self {
        case .invalid:
            return "F80B0B"
        case .redundant:
            return "F80B0B"
        case .success:
            return "0A84FF"
        case .none:
            return "F80B0B"
        case .incomplete:
            return "F80B0B"
        case .abnomal:
            return "F80B0B"
        }
    }
}
