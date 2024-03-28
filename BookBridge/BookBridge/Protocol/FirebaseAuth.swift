//
//  FirestoreUpdatable.swift
//  BookBridge
//
//  Created by 이민호 on 3/6/24.
//

import Combine
import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

protocol FirebaseAuth {
    var email: String { get set }
}

extension FirebaseAuth {
            
    func sendPasswordReset(isLoading: Binding<Bool>, isComplete: Binding<Bool>) {
        isLoading.wrappedValue = true
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            guard let error = error else {
                isLoading.wrappedValue = false
                isComplete.wrappedValue = true
                print("메세지 보내기 성공")
                return
            }
            let nsError : NSError = error as NSError
            switch nsError.code {
            case 17011:
                isLoading.wrappedValue = false
                print("존재하지 않는 이메일 입니다")
            default:
                isLoading.wrappedValue = false
                break
            }
        }
    }
}
