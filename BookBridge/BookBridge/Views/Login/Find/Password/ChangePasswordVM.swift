//
//  ChangePasswordVM.swift
//  BookBridge
//
//  Created by 김건호 on 1/31/24.
//

import Foundation
import FirebaseAuth

class ChangePasswordVM : ObservableObject {
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
            //MARK: 비밀 번호 재 설정 하는 함수 추가 예정
            Auth.auth().sendPasswordReset(withEmail: email,completion: nil)
        }
    }
}
