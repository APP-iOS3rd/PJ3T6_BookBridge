//
//  SignUpVM.swift
//  BookBridge
//
//  Created by 이민호 on 1/29/24.
//

import Foundation
import SwiftUI
import Firebase
import SwiftSMTP
import FirebaseFirestore

class SignUpViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var userAuthCode: String = ""
    @Published var timeRemaining = 0
    @Published var timeLabel: String = ""
    @Published var isCertiClear: CertiResult?
    
    @Published var id: String = ""
    @Published var nickname: String = ""
    @Published var password: String = ""
    @Published var passwordConfirm: String = ""
    @Published var users: [UserModel] = []
    
    private var authCode: String?
    let db = Firestore.firestore()
    var isCertiActive = false
    var timer: Timer?
                        
    func sendMail() {
        let mail_to = Mail.User(name: "mail_to", email: email)
        authCode = createEmailCode()
        let mail = Mail(
            from: mail_from,
            to: [mail_to],
            subject: "북다리 이메일 인증번호",
            text: emailContent(code: authCode ?? "")
        )
        self.userAuthCode = ""
        self.isCertiClear = nil
        self.isCertiActive = true
        smtp.send(mail)
        showingTime()
    }
                        
    func showingTime() {
        timerReset()
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            
            self.timeRemaining -= 1
            
            let min = self.timeRemaining / 60
            let sec = self.timeRemaining % 60
            
            if self.timeRemaining > 0 {
                self.timeLabel = "\(min)분 \(sec)초 남음"
            } else {
                self.authCode = nil
                self.timeLabel = "인증시간만료"
                self.isCertiClear = .timeOut
                timer.invalidate()
            }
        }
    }
    
    func timerReset() {
        self.timeRemaining = 30
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func isValidEmail() -> Bool {
       let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
       let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
       return emailTest.evaluate(with: self.email)
    }    
    
    func isCertiCode() {
        if userAuthCode == self.authCode {
            self.isCertiClear = .right
        } else {
            self.isCertiClear = .wrong
        }
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
    
    func isValidId() -> Bool {
        db.collection("User").getDocuments { snapShot, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.users = snapShot?.documents.compactMap {
                    try? $0.data(as: UserModel.self)
                } ?? []
            }
        }

        return false
    }
    
    
}
