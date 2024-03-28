//
//  MyProfilePasswordViewModel.swift
//  BookBridge
//
//  Created by 노주영 on 3/11/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class MyProfilePasswordViewModel: ObservableObject {
    @Published var userPassword: String = ""
    @Published var newPassword: String = ""
    @Published var reNewPassword: String = ""
    
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    let userManager = UserManager.shared
    let validator = FormatValidator()
}

//MARK: FirebaseFirestore 관련
extension MyProfilePasswordViewModel {
    func doEditing(password: String, completion: @escaping((Bool?, Bool)) -> ()) {
        if password == userPassword {
            if self.validator.isValidPwd(pwd: self.newPassword) {
                Auth.auth().currentUser?.updatePassword(to: self.newPassword) { error in
                    print("123")
                    guard error == nil else {
                        completion((false, true))
                        return
                    }
                    print("456")
                    self.db.collection("User").document(self.userManager.uid).updateData([
                        "password": self.newPassword
                    ])
                    completion((false, false))                               //완벽
                }
            } else {
                completion((true, false))                                    //비밀번호 양식이 맞지 않는 경우
            }
        } else {
            completion((nil, false))
        }
    }
}
