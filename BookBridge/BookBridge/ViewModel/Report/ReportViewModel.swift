//
//  ReportViewModel.swift
//  BookBridge
//
//  Created by 김지훈 on 2024/02/13.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class ReportViewModel: ObservableObject{
    
    @Published var report = Report(targetType: .post, targetID: "", reporterUserId: "", reason: .other, additionalComments: "", reportDate: Date())
    

    
    let db = Firestore.firestore()

}

extension ReportViewModel {
    func saveReportToFirestore(report: Report){
        do {
            // reports 컬렉션에 새 문서를 추가, Report 객체를 이용하여 문서 데이터 설정
            try db.collection("Report").document(report.id).setData(from: report) { error in
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
