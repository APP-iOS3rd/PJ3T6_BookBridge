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

enum CertiResult {
    case right
    case wrong
    case timeOut
}

class SignUpVM: ObservableObject {
    @Published var email: String = ""
    @Published var userAuthCode: String = ""
    @Published var timeRemaining = 0
    @Published var timeLabel: String = ""
    @Published var isCertiClear: CertiResult?
    
    @Published var id: String = ""
    @Published var nickname: String = ""
    @Published var password: String = ""
    @Published var passwordConfirm: String = ""
    @Published var pwdStatus: PwdError?
    
    private var authCode: String?
    let db = Firestore.firestore()
    let validator = Validator()
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
    
    func isValid(type: ValidType) -> Bool {
        switch type {
        case .email:
            return validator.validate(type: .email, value: self.email)
            
        case .id:
            return validator.validate(type: .id, value: self.id)
            
        case .nickname:
            return validator.validate(type: .nickname, value: self.nickname)
        }
    }
    
    func isValidPwd() {
        self.pwdStatus = validator.isValidPwd(pwd: self.password, confirmPwd: self.passwordConfirm)
    }
    
    func validAll() -> Bool {
        return validator.isAllInput(id: self.id, nickname: self.nickname, pwd: self.password, confirmPwd: self.passwordConfirm)
    }
    
    func isCertiCode() {
        if userAuthCode == self.authCode {
            self.isCertiClear = .right
        } else {
            self.isCertiClear = .wrong
        }
    }
    
    func userSave() {
        let user = UserModel(id: email, loginId: id, passsword: password, nickname: nickname)
                
        do {
            _ = try db.collection("User").addDocument(from: user) { err in
                if let err = err {
                    print(err.localizedDescription)
                } else {
                    print("User has been saved!")
                }
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
