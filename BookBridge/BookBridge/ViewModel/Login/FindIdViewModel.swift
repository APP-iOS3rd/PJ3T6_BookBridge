//
//  FindIdViewModel.swift
//  BookBridge
//
//  Created by 이민호 on 3/7/24.
//

import Foundation
import FirebaseAuth
import FirebaseMessaging
import Combine
import SwiftUI

class FindIdViewModel: ObservableObject, FirestoreFindable, Changable {
    @Published var phoneNumber = ""
    @Published var certificationNumber = ""
    @Published var verificationID: String?
    @Published var userDocId: String?
    
    @Published var phoneNumberStatusText: PhoneError?
    @Published var certificationNumberStatusText: CertificationError?
        
    private var savedPhoneNumber = ""
    private var cancellables = Set<AnyCancellable>()
    
    func sendVerificationNumber(isLoading: Binding<Bool>, isComplete: Binding<Bool>) {
        let ph = "+82\(phoneNumber)"
        
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(ph, uiDelegate: nil) { [weak self] verificationID, error in
                guard let self = self else { return }
                
                if let error = error {
                    isLoading.wrappedValue = false
                    print("pushVerficationNumber Error: \(error.localizedDescription)")
                    return
                } else {
                    isLoading.wrappedValue = false
                    isComplete.wrappedValue = true
                    self.resetPhoneNumber()
                    print("SMS 전송 완료")
                }
                
                if let verificationID = verificationID {
                    self.verificationID = verificationID
                }
            }
    }
    
    func verifyPhoneNumber(isLoading: Binding<Bool>, isComplete: Binding<Bool>) {
        isLoading.wrappedValue = true
        
        checkPhoneNumberExists(phoneNumber: phoneNumber)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    // isLoading.wrappedValue = false
                    print("PhoneNumber 검증 완료")
                case .failure(let error):
                    isLoading.wrappedValue = false
                    print("PhoneNumber 검증 실패: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] exists in
                guard let self = self else { return }
                if exists {
                    print("휴대폰 번호가 존재합니다.")
                    self.phoneNumberStatusText = .success
                    self.sendVerificationNumber(
                        isLoading: isLoading,
                        isComplete: isComplete
                    )
                } else {
                    print("휴대폰 번호가 존재하지 않습니다.")
                    self.phoneNumberStatusText = PhoneError.none
                }
            })
            .store(in: &cancellables)
    }
    
    func verifyCertificationNumber(isLoading: Binding<Bool>, isComplete: Binding<Bool>) {
        isLoading.wrappedValue = true
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: self.verificationID ?? "",
            verificationCode: certificationNumber
        )
        
        Auth.auth().signIn(with: credential) { (success, error) in
            if let error = error {
                isLoading.wrappedValue = false
                self.certificationNumberStatusText = .invalid
                print("SMS 인증 실패: \(error.localizedDescription)")
                
            } else {
                print("SMS 인증 성공")
                self.findUserIdWithPhone(phoneNumber: self.savedPhoneNumber)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            isLoading.wrappedValue = false
                            break
                        case .failure(let error):
                            isLoading.wrappedValue = false
                            print("사용자 ID 찾기 실패: \(error.localizedDescription)")
                        }
                    }, receiveValue: { [weak self] userID in
                        guard let self = self else { return }
                        
                        if let userID = userID {                            
                            self.userDocId = userID
                            isComplete.wrappedValue = true
                            resetCertificationNumber()
                        } else {
                            // 사용자 ID를 찾지 못했을 경우 처리
                            print("사용자 ID를 찾을 수 없음")
                        }
                    })
                    .store(in: &self.cancellables)
            }
        }
    }
    
    func getEmail(with representEmail: Binding<String>) {
        self.fetchEmailFromUser(documentId: userDocId ?? "")
            .sink(receiveCompletion: { emailCompletion in
                switch emailCompletion {
                case .finished:
                    break
                case .failure(let emailError):
                    print("이메일 가져오기 실패: \(emailError.localizedDescription)")
                }
            }, receiveValue: { [weak self] email in
                guard let self = self else { return }
                let changedEmail = self.anonymizeEmail(email)
                representEmail.wrappedValue = changedEmail
            })
            .store(in: &self.cancellables)
    }
    
    func resetPhoneNumber() {
        savedPhoneNumber = phoneNumber
        phoneNumber = ""
        phoneNumberStatusText = nil
        verificationID = nil
        cancellables.removeAll()
    }
    
    func resetCertificationNumber() {
        certificationNumber = ""
        certificationNumberStatusText = nil
        cancellables.removeAll()
    }
}
