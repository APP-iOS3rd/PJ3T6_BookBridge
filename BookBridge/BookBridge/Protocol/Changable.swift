//
//  Changable.swift
//  BookBridge
//
//  Created by 이민호 on 3/7/24.
//

import Foundation

protocol Changable {
    
}

extension Changable {
    func anonymizeEmail(_ email: String) -> String {
        // 이메일 주소를 "@" 기준으로 분리합니다.
        let parts = email.split(separator: "@")
        guard parts.count == 2 else { return email } // "@"를 포함하지 않는 경우, 원본 이메일 반환
        
        let localPart = String(parts[0]) // "@" 이전 부분
        let domainPart = String(parts[1]) // "@" 이후 부분
        
        // "@" 이전 부분의 절반 길이를 계산합니다. 절반을 올림 처리하여 뒷부분이 더 많이 숨겨지도록 합니다.
        let halfLength = (localPart.count + 1) / 2
        
        // 뒷부분의 절반을 "*"로 대체합니다. 절반을 올림 처리하기 때문에, 짝수일 때는 정확히 반을 나누고, 홀수일 때는 뒷부분이 하나 더 많습니다.
        let maskedPart = String(repeating: "*", count: halfLength)
        
        // "@" 이전 부분의 앞부분과 "*"로 대체된 뒷부분을 결합합니다.
        let resultLocalPart = localPart.prefix(localPart.count - halfLength) + maskedPart
        
        // 최종적으로 변경된 "@" 이전 부분과 원래의 "@" 이후 부분을 결합하여 반환합니다.
        return "\(resultLocalPart)@\(domainPart)"
    }
}
