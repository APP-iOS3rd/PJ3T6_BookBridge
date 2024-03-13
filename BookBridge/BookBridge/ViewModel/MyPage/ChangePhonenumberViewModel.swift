//
//  ChangePasswordViewModel.swift
//  BookBridge
//
//  Created by 이민호 on 3/11/24.
//

import Foundation
import FirebaseAuth
import FirebaseMessaging
import Combine
import SwiftUI
import FirebaseFirestoreInternal

enum CompleteState {
    case success
    case failure
    case loading
}

class ChangePhonenumberViewModel: ViewModelable {
    enum Action {
        case checkPassword
        case changePhoneNumber
        case confirmVerificationNumber
    }

    enum State {
        case password(String)
        case phoneNumber(String)
        case certiNumber(String)
    }
           
    enum ErrorState {
        case password(String)
        case phoneNumber(String)
        case certiNumber(String)
    }
        
    @Published var state: State
    @Published var error: ErrorState
    @Published var complete: CompleteState
    @Published var verificationID = ""
    @Published var newPhoneNumber = ""
    private var cancellables = Set<AnyCancellable>()
    
        
    init() {
        state = .password("")
        error = .password("")
        complete = .failure
    }
    
    func action(_ action: Action) {
        switch action {
        case .checkPassword:
            ConfirmPassword()
            
        case .changePhoneNumber:
            sendVerificationNumber()
            
        case .confirmVerificationNumber:
            verifyCertificationNumber()            
        }
    }
    
    func ConfirmPassword() {
        guard case let .password(string) = state else { return }
        print("password: \(string)")
        if checkPassword(string) {
            self.complete = .success
        } else {
            self.complete = .failure
            error = .password("비밀번호가 일치하지 않습니다.")
        }
    }
    
    func checkPassword(_ password: String) -> Bool {
        if UserManager.shared.user?.password == password {
            return true
        } else {
            return false
        }
    }
    
    func sendVerificationNumber() {
        self.complete = .loading
        guard case let .phoneNumber(string) = state else {
            print("phoneNumber의 값을 가져올 수 없습니다.")
            return
        }
        
        let ph = "+82\(string)"
        
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(ph, uiDelegate: nil) { [weak self] verificationID, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("pushVerficationNumber Error: \(error.localizedDescription)")
                    self.error = .phoneNumber("휴대폰번호 형식이 잘못되었습니다.")
                    self.complete = .failure
                    
                } else {
                    print("SMS 전송 완료")
                    complete = .success
                }
                
                if let verificationID = verificationID {
                    self.verificationID = verificationID
                }
            }
    }
    
    func verifyCertificationNumber() {
        self.complete = .loading
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: self.verificationID,
            verificationCode: state.text
        )
        
        Auth.auth().signIn(with: credential) { [weak self] (success, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.error = .certiNumber("인증번호가 올바르지 않습니다.")
                self.complete = .failure
                print("SMS 인증 실패: \(error.localizedDescription)")
                
            } else {
                self.complete = .success
                self.changePhoneNumber()
                print("SMS 인증 성공")
                
            }
        }
    }
    
    func changePhoneNumber() {
        self.complete = .loading
        Firestore.firestore().updateUserPhoneNumber(userID: UserManager.shared.uid, newPhoneNumber: newPhoneNumber)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("전화번호가 성공적으로 업데이트되었습니다.")
                        self.complete = .success
                    case .failure(let error):
                        print("전화번호 업데이트 중 오류가 발생했습니다: \(error.localizedDescription)")
                        self.complete = .failure
                    }
                }, receiveValue: { [weak self] _ in
                    guard let self = self else { return }
                    UserManager.shared.user?.phoneNumber = self.newPhoneNumber
                })
                .store(in: &cancellables)
    }
            
    func setPasswordState() {
        state = .password("")
        error = .password("")
        complete = .failure
    }
        
    func setPhoneNumberState() {
        state = .phoneNumber("")
        error = .phoneNumber("")
        complete = .failure
        self.verificationID = ""
        self.newPhoneNumber = ""
    }
    
    func setCertiNumberState(_ id: String, _ phoneNumber: String) {
        state = .certiNumber("")
        error = .certiNumber("")
        complete = .failure
        self.verificationID = id
        self.newPhoneNumber = phoneNumber
    }
}

extension ChangePhonenumberViewModel.State {
    var text: String {
        get {
            switch self {
            case let .password(string): return string
            case let .phoneNumber(string): return string
            case let .certiNumber(string): return string
            }
        }
        set {
            switch self {
            case .password: self = .password(newValue)
            case .phoneNumber: self =  .phoneNumber(newValue)
            case .certiNumber: self = .certiNumber(newValue)
            }
        }
    }
}








