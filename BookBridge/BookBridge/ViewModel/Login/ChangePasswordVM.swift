//
//  ChangePasswordVM.swift
//  BookBridge
//
//  Created by 김건호 on 1/31/24.
//

import Foundation
import FirebaseAuth

class ChangePasswordVM: ObservableObject {
    @Published var email: String = ""
    @Published var Resetpassword: String = ""
    @Published var Resetpassword1: String = ""
    @Published var passwordErrorMessage: String = ""
    
    
    func Reset() {
        
        var isValid = true
        
        if Resetpassword != Resetpassword1 {
            passwordErrorMessage = "입력한 비밀번호가 일치 하지 않습니다."
            isValid = false
        }
        
        if isValid {
            Auth.auth().sendPasswordReset(withEmail: email,completion: nil)
        }
    }
}
