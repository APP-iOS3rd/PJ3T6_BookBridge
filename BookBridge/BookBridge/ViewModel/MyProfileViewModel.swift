//
//  MyProfileViewModel.swift
//  BookBridge
//
//  Created by 노주영 on 2/22/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class MyProfileViewModel: ObservableObject {
    @Published var selectImage: UIImage?
    @Published var userNickname: String = ""
    @Published var userPassword: String = ""
    
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    let userManager = UserManager.shared
    let validator = FormatValidator()
}

//MARK: FirebaseFirestore 관련
extension MyProfileViewModel {
    func doEditing(nickname: String, userSaveImage: (String, UIImage), password: String, completion: @escaping((Bool, Bool, String)) -> ()) {
        if selectImage != userSaveImage.1 && userNickname != nickname && userPassword != password{  //셋다 변경
            db.collection("User").whereField("nickname", isEqualTo: userNickname).getDocuments { querySnapshot, error in
                guard error == nil else { return }
                guard let documents = querySnapshot else { return }
                
                if documents.isEmpty {      //닉네임 중복이 없는 경우
                    if self.validator.isValidPwd(pwd: self.userPassword) {
                        self.saveProfileImage { urlString in
                            self.db.collection("User").document(self.userManager.uid).updateData([
                                "nickname": self.userNickname,
                                "profileURL": urlString,
                                "password": self.userPassword
                            ])
                            completion((false, false, urlString))               //완벽
                        }
                    } else {                //비밀번호 양식이 맞지 않는 경우
                        completion((false, true, ""))
                    }
                } else {                    //닉네임 중복이 있는 경우
                    completion((true, false, ""))
                }
            }
        } else if selectImage != userSaveImage.1 && userNickname != nickname {         //이미지, 닉네임만 변경
            db.collection("User").whereField("nickname", isEqualTo: userNickname).getDocuments { querySnapshot, error in
                guard error == nil else { return }
                guard let documents = querySnapshot else { return }
                
                if documents.isEmpty {      //닉네임 중복이 없는 경우
                    self.saveProfileImage { urlString in
                        self.db.collection("User").document(self.userManager.uid).updateData([
                            "nickname": self.userNickname,
                            "profileURL": urlString
                        ])
                        completion((false, false, urlString))               //완벽
                    }
                } else {                    //닉네임 중복이 있는 경우
                    completion((true, false, ""))
                }
            }
        } else if selectImage != userSaveImage.1 && userPassword != password{             //이미지, 비밀번호 변경
            if validator.isValidPwd(pwd: userPassword) {
                self.saveProfileImage { urlString in
                    self.db.collection("User").document(self.userManager.uid).updateData([
                        "profileURL": urlString,
                        "password": self.userPassword
                    ])
                    completion((false, false, urlString))               //완벽
                }
            } else {                                            //비밀번호 양식이 맞지 않는 경우
                completion((false, true, ""))
            }
        } else if userNickname != nickname && userPassword != password {             //닉네임, 비밀번호 변경
            db.collection("User").whereField("nickname", isEqualTo: userNickname).getDocuments { querySnapshot, error in
                guard error == nil else { return }
                guard let documents = querySnapshot else { return }
                
                if documents.isEmpty {                                  //닉네임 중복이 없는 경우
                    if self.validator.isValidPwd(pwd: self.userPassword) {
                        self.db.collection("User").document(self.userManager.uid).updateData([
                            "nickname": self.userNickname,
                            "password": self.userPassword
                        ])
                        completion((false, false, ""))                  //완벽
                    } else {                                            //비밀번호 양식이 맞지 않는 경우
                        completion((false, true, ""))
                    }
                } else {                                                //닉네임 중복이 있는 경우
                    completion((true, false, ""))
                }
            }
        } else if selectImage != userSaveImage.1 {
            self.saveProfileImage { urlString in
                self.db.collection("User").document(self.userManager.uid).updateData([
                    "profileURL": urlString,
                ])
                completion((false, false, urlString))               //완벽
            }
        } else if userNickname != nickname {
            db.collection("User").whereField("nickname", isEqualTo: userNickname).getDocuments { querySnapshot, error in
                guard error == nil else { return }
                guard let documents = querySnapshot else { return }
                
                if documents.isEmpty {      //닉네임 중복이 없는 경우
                    self.db.collection("User").document(self.userManager.uid).updateData([
                        "nickname": self.userNickname
                    ])
                    completion((false, false, ""))
                } else {                    //닉네임 중복이 있는 경우
                    completion((true, false, ""))
                }
            }
        } else {
            if self.validator.isValidPwd(pwd: self.userPassword) {
                self.db.collection("User").document(self.userManager.uid).updateData([
                    "password": self.userPassword
                ])
                completion((false, false, ""))                  //완벽
            } else {                                            //비밀번호 양식이 맞지 않는 경우
                completion((false, true, ""))
            }
        }
    }
}

//MARK: FirebaseStorage 관련
extension MyProfileViewModel {
    //프로필이미지 저장
    func saveProfileImage(completion: @escaping(String) -> ()) {
        guard let imageData = selectImage?.jpegData(compressionQuality: 0.2) else { return }
        
        let ref = storage.child("User/\(userManager.uid)")
        
        ref.putData(imageData, metadata: nil) { metadata, err in
            guard err == nil else { return }
            
            ref.downloadURL { url, error in
                guard error == nil else { return }
                guard let url = url else { return }
                
                completion(url.absoluteString)
            }
        }
    }
}
