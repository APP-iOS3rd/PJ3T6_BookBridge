//
//  SettingViewModel.swift
//  BookBridge
//
//  Created by 김지훈 on 2024/02/27.
//

import Foundation
import Firebase

class SettingViewModel: ObservableObject{

    @Published var isChattingAlarm: Bool = true
    
    private var db = Firestore.firestore()

    func updateChattingAlarm(isEnabled: Bool){
        let uid = UserManager.shared.uid
        FirebaseManager.shared.firestore.collection("User").document(uid).updateData([
                    "isChattingAlarm": isEnabled
                ])
    }
    
    func fetchChattingAlarm(uid: String){
        
        // 사용자의 uid를 이용하여 해당 사용자의 문서를 가져옵니다.
        let userDocRef = db.collection("User").document(uid)
        
        userDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let userData = document.data()
                self.isChattingAlarm = userData?["isChattingAlarm"] as? Bool ?? false
            } else {
                print("")
            }
        }

        
    }

    
    
}
