//
//  IdLoginViewModel.swift
//  BookBridge
//
//  Created by 김건호 on 1/29/24.
//

import Foundation

class IdLoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var usernameErrorMessage: String = ""
    @Published var passwordErrorMessage: String = ""
    
    
    func login() {
        usernameErrorMessage = ""
        passwordErrorMessage = ""
        
        var isValid = true
        
        
        
        if username.isEmpty {
            usernameErrorMessage = "아이디를 입력하세요."
            isValid = false
        }
        
        if password.isEmpty {
            passwordErrorMessage = "비밀번호를 입력하세요."
            isValid = false
        }
        
        if isValid {
            print("로그인 시도: \(username), \(password)")
        }
    }
    
}
