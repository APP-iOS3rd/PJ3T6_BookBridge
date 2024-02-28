//
//  SettingViewModel.swift
//  BookBridge
//
//  Created by 김지훈 on 2024/02/27.
//

import Foundation

class SettingViewModel: ObservableObject{

    func updateChattingAlarm(isEnabled: Bool){
        let uid = UserManager.shared.uid
        FirebaseManager.shared.firestore.collection("User").document(uid).updateData([
                    "isChattingAlarm": isEnabled
                ])
    }
    
}
