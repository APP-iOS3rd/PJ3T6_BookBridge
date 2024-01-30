//
//  SignUpVM.swift
//  BookBridge
//
//  Created by 이민호 on 1/29/24.
//

import Foundation
import Firebase
import SwiftSMTP

class SignUpVM: ObservableObject {
    @Published var id: String = ""
    @Published var nickname: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirm: String = ""
    @Published var userAuthCode: String = ""
    private var authCode: String = ""
    
    func sendMail() {
        let mail_to = Mail.User(name: "mail_to", email: email)
        authCode = createEmailCode()
        let mail = Mail(
            from: mail_from,
            to: [mail_to],
            subject: "북다리 이메일 인증번호",
            text: emailContent(code: authCode)
        )
        smtp.send(mail)
    }
                    
    func register(completion: @escaping () -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                completion()
            }
        }
    }
    
}
