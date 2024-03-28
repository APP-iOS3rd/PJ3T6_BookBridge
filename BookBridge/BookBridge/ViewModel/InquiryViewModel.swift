//
//  InquiryViewModel.swift
//  BookBridge
//
//  Created by 이현호 on 2/27/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class InquiryViewModel: ObservableObject{
    
    @Published var inquiry = Inquiry(inquiryUserId: "", category: .other, inquiryComments: "", inquiryDate: Date())

    
    let db = Firestore.firestore()

}

extension InquiryViewModel {
    func saveInquiryToFirestore(inquiry: Inquiry){
        do {
            // reports 컬렉션에 새 문서를 추가, Report 객체를 이용하여 문서 데이터 설정
            try db.collection("Inquiry").document(UserManager.shared.uid).collection("UserInquiries").addDocument(from: inquiry) { error in
                DispatchQueue.main.async{
                    if let error = error {
                        print("Error adding document: \(error.localizedDescription)")
                    } else {
                        print("Report successfully added!")
                    }
                }
            }
        } catch let error {
            DispatchQueue.main.async{
                print("Error writing report to Firestore: \(error.localizedDescription)")
            }
        }
        
    }
}
