//
//  SMSAuthViewModel.swift
//  BookBridge
//
//  Created by 이민호 on 3/5/24.
//

import Foundation
import FirebaseAuth
import FirebaseMessaging
import Combine
import SwiftUI

class SMSAuthViewModel: ObservableObject, FirestoreFindable, FirestoreUpdatable {
    @Published var email = ""
    @Published var phoneNumber = ""
    @Published var certificationNum = ""
    @Published var password = ""
    @Published var rePassword = ""
    @Published var verificationID: String?
    // @Published var userDocId = "MzU2sI6UEPNExhFmgjpTRayLWPE2"
    @Published var userDocId: String?
    
    @Published var emailStatusText: EmailError?
    @Published var phoneNumberStatusText: PhoneError?
    @Published var certificationNumStatusText: CertificationError?
    @Published var passwordStatusText: PwdError?
    @Published var rePasswordStatusText: PwdConfirmError?
    
    
    private var cancellables = Set<AnyCancellable>()
    private var fomatValidator = FormatValidator()
        
    
    func sendVerificationNumber() {
        let ph = "+82\(phoneNumber)"
        
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(ph, uiDelegate: nil) { verificationID, error in
                if let error = error {
                    print("pushVerficationNumber Error: \(error.localizedDescription)")
                    return
                } else {
                    print("SMS 전송 완료")
                }
                
                if let verificationID = verificationID {
                    self.verificationID = verificationID
                }
            }
    }
    
    func verifyCertificationNumber(isLoading: Binding<Bool>, isComplete: Binding<Bool>) {
        resetStatusText()
        isLoading.wrappedValue = true
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: self.verificationID ?? "",
            verificationCode: certificationNum
        )
        
        Auth.auth().signIn(with: credential) { (success, error) in
            if let error = error {
                isLoading.wrappedValue = false
                self.certificationNumStatusText = .invalid
                print("SMS 인증 실패: \(error.localizedDescription)")
                
            } else {
                print("SMS 인증 성공")
                
                self.findUserID(email: self.email, phoneNumber: self.phoneNumber)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            isLoading.wrappedValue = false
                            break
                        case .failure(let error):
                            isLoading.wrappedValue = false
                            print("사용자 ID 찾기 실패: \(error.localizedDescription)")
                        }
                    }, receiveValue: { userID in
                        if let userID = userID {
                            self.userDocId = userID
                            isComplete.wrappedValue = true
                            print("사용자 ID: \(userID)")
                            print("isComplete: \(isComplete.wrappedValue)")
                        } else {
                            // 사용자 ID를 찾지 못했을 경우 처리
                            print("사용자 ID를 찾을 수 없음")
                        }
                    })
                    .store(in: &self.cancellables)
            }
        }
    }
    
    func verifyEmail(isLoading: Binding<Bool>) {
        isLoading.wrappedValue = true
        
        checkEmailExists(email: email)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    isLoading.wrappedValue = false
                    print("Email 검증 완료")
                case .failure(let error):
                    isLoading.wrappedValue = false
                    print("Email 검증 실패: \(error.localizedDescription)")
                }
            }, receiveValue: { exists in
                if exists {
                    print("이메일이 존재합니다.")
                    self.emailStatusText = .success
                    
                } else {
                    print("이메일이 존재하지 않습니다.")
                    self.emailStatusText = EmailError.none
                }
            })
            .store(in: &cancellables)
    }
    
    func verifyPhoneNumber(isLoading: Binding<Bool>) {
        isLoading.wrappedValue = true
        
        checkPhoneNumberExists(phoneNumber: phoneNumber)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    isLoading.wrappedValue = false
                    print("PhoneNumber 검증 완료")
                case .failure(let error):
                    isLoading.wrappedValue = false
                    print("PhoneNumber 검증 실패: \(error.localizedDescription)")
                }
            }, receiveValue: { exists in
                if exists {
                    print("휴대폰 번호가 존재합니다.")
                    self.phoneNumberStatusText = .success
                    self.sendVerificationNumber()
                    
                } else {
                    print("휴대폰 번호가 존재하지 않습니다.")
                    self.phoneNumberStatusText = PhoneError.none
                }
            })
            .store(in: &cancellables)
    }
    
    func verifyPassword(isLoading: Binding<Bool>, showingAlert: Binding<Bool>) {
        self.resetPasswordStatusText()
        isLoading.wrappedValue = true
        
        if password.isEmpty {
            passwordStatusText = .empty
            isLoading.wrappedValue = false
            return
        }
        
        if rePassword.isEmpty {
            rePasswordStatusText = .empty
            isLoading.wrappedValue = false
            return
        }
        
        if fomatValidator.isValidPwd(pwd: password) {
            if password == rePassword {
                print("비밀번호 변경 성공")
                updatePassword(isLoading: isLoading, showingAlert: showingAlert)
            } else {
                rePasswordStatusText = .wrong
                isLoading.wrappedValue = false
            }
        } else {
            passwordStatusText = .invalid
            isLoading.wrappedValue = false
        }
    }
    
    func updatePassword(isLoading: Binding<Bool>, showingAlert: Binding<Bool>) {
        // updatePassword를 호출하여 비밀번호 업데이트를 수행합니다.
               
        updatePassword(userDocId: userDocId ?? "", newPassword: password)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    isLoading.wrappedValue = false
                    print("비밀번호 업데이트가 성공적으로 완료되었습니다.")
                case .failure(let error):
                    isLoading.wrappedValue = false
                    print("비밀번호 업데이트 도중 오류가 발생했습니다: \(error.localizedDescription)")
                }
            }, receiveValue: { _ in
                showingAlert.wrappedValue = true
                print("비밀번호가 업데이트되었습니다. showingAlert: \(showingAlert.wrappedValue)")
            })
            .store(in: &cancellables)
    }
    
    func verifyAll() -> Bool {
        if emailStatusText != .success {
            emailStatusText = .incomplete
            return false
        }
        
        if phoneNumberStatusText != .success {
            phoneNumberStatusText = .incomplete
            return false
        }
        
        return true
    }
    
    func reset() {
        email = ""
        phoneNumber = ""
        certificationNum = ""
        password = ""
        rePassword = ""
        verificationID = ""
        userDocId = ""
        
        emailStatusText = nil
        phoneNumberStatusText = nil
        certificationNumStatusText = nil
        passwordStatusText = nil
        rePasswordStatusText = nil
        cancellables = Set<AnyCancellable>()
    }
    
    func resetStatusText() {
        emailStatusText = nil
        phoneNumberStatusText = nil
        certificationNumStatusText = nil
    }
    
    func resetPasswordStatusText() {
        passwordStatusText = nil
        rePasswordStatusText = nil
    }
        
}
