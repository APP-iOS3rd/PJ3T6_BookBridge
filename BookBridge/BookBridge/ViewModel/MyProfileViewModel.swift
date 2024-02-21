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
    @Published var userNickname: String = ""
    @Published var selectImage: UIImage?
    
    let db = Firestore.firestore()
    let userManager = UserManager.shared
}

//MARK: FirebaseFirestore 관련
extension MyProfileViewModel {
    func saveprofileURL() {
        
    }
}

//MARK: FirebaseStorage 관련
extension MyProfileViewModel {
    func saveImage() {
        
    }
}
