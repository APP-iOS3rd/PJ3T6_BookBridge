//
//  IdLoginViewModel.swift
//  BookBridge
//
//  Created by 김건호 on 1/29/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class IdLoginViewModel: ObservableObject {
    @Published var state: SignInState = .signedOut
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var usernameErrorMessage: String = ""
    @Published var passwordErrorMessage: String = ""
    
    
    enum SignInState{
        case signedIn
        case signedOut
    }
    
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
            Auth.auth().signIn(withEmail: username, password: password) { result,error in
                if let error = error {
                    print("error: \(error.localizedDescription)")
                    
                    return
                }
                if result != nil {
                    self.state = .signedIn
                    print("사용자 이메일: \(String(describing: result?.user.email))")
                    print("사용자 이름: \(String(describing: result?.user.displayName))")
                    
                }
                
            }
        }
    }
    
}


