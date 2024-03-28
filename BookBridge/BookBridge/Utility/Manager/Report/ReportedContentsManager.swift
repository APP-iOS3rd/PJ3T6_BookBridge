//
//  ReportedContentsManager.swift
//  BookBridge
//
//  Created by 김지훈 on 2024/03/18.
//

import Foundation
import Firebase

// 신고글 id관리 Manager
class ReportedContentsManager: ObservableObject {
    
    static let shared = ReportedContentsManager()
    
    @Published var reportedTargetIds: Set<String> = []

    private var db = Firestore.firestore()
    
    private init() {
        fetchReportedContent()
    }
    
    //신고글 불러오기
    func fetchReportedContent() {
        db.collection("Report").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("'Report'컬렉션이 없습니다.")
                return
            }
            self.reportedTargetIds = Set(documents.compactMap { $0["targetID"] as? String })
        }
    }
}
