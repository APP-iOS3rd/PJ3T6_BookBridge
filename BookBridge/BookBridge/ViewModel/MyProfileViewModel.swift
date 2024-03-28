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
    
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    let userManager = UserManager.shared
    let validator = FormatValidator()
}

//MARK: FirebaseFirestore 관련
extension MyProfileViewModel {
    func doEditing(nickname: String, userSaveImage: (String, UIImage), completion: @escaping((Bool, String)) -> ()) {
        if selectImage != userSaveImage.1 && userNickname != nickname {  //셋다 변경
            db.collection("User").whereField("nickname", isEqualTo: userNickname).getDocuments { querySnapshot, error in
                guard error == nil else { return }
                guard let documents = querySnapshot else { return }
                
                if documents.isEmpty {      //닉네임 중복이 없는 경우
                    self.saveProfileImage { urlString in
                        self.db.collection("User").document(self.userManager.uid).updateData([
                            "nickname": self.userNickname,
                            "profileURL": urlString,
                        ])
                        completion((false, urlString))               //완벽
                    }
                } else {                    //닉네임 중복이 있는 경우
                    completion((true, ""))
                }
            }
        } else if selectImage != userSaveImage.1 {
            self.saveProfileImage { urlString in
                self.db.collection("User").document(self.userManager.uid).updateData([
                    "profileURL": urlString,
                ])
                completion((false, urlString))               //완벽
            }
        } else {
            db.collection("User").whereField("nickname", isEqualTo: userNickname).getDocuments { querySnapshot, error in
                guard error == nil else { return }
                guard let documents = querySnapshot else { return }
                
                if documents.isEmpty {      //닉네임 중복이 없는 경우
                    self.db.collection("User").document(self.userManager.uid).updateData([
                        "nickname": self.userNickname
                    ])
                    completion((false, ""))
                } else {                    //닉네임 중복이 있는 경우
                    completion((true, ""))
                }
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
