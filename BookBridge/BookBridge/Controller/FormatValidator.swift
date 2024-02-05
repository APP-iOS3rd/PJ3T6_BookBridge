//
//  FomatValidator.swift
//  BookBridge
//
//  Created by 이민호 on 1/31/24.
//

import Foundation

struct FormatValidator {
    func isValidEmail(email: String) -> Bool {
       let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
       let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
       return emailTest.evaluate(with: email)
    }
    
    // isValidID와 isValidNickname은 같지만 혹시몰라 두개로 나누어 놨습니다.
    func isValidID(id: String) -> Bool {
        let idRegEx = "^[a-zA-Z0-9가-힣]{1,11}$"
        let idTest = NSPredicate(format: "SELF MATCHES %@", idRegEx)
        return idTest.evaluate(with: id)
    }
    
    func isValidNickname(nickname: String) -> Bool {
        let idRegEx = "^[a-zA-Z0-9가-힣]{1,11}$"
        let idTest = NSPredicate(format: "SELF MATCHES %@", idRegEx)
        return idTest.evaluate(with: nickname)
    }
            
    func isValidPwd(pwd: String) -> Bool {
        // 8~16 영어+숫자+특수문자
        let pwdRegEx = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,16}"
        let pwdTest = NSPredicate(format:"SELF MATCHES %@", pwdRegEx)
        return pwdTest.evaluate(with: pwd)
    }
        
    func isValidPhoneNum(ph: String) -> Bool {
        let phRegEx = "^01[0-1, 7][0-9]{7,8}$"
        let phTest = NSPredicate(format:"SELF MATCHES %@", phRegEx)
        return phTest.evaluate(with: ph)
    }
}
