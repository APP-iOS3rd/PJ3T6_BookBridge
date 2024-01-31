import SwiftUI

struct FindPost: Codable {
//    @DocumentID var id:
    var noticeBoardId = UUID().uuidString
    var userId: String
    var noticeBoardTitle: String
    var noticeBoardDetail: String
    var isChange: Bool
    var state: [Int]
    var date: Date
    
    var dictionary: [String: Any] {
        return [
            "noticeBoardId": noticeBoardId,
            "userId": userId,
            "noticeBoardTitle": noticeBoardTitle,
            "noticeBoardDetail": noticeBoardDetail,
            "isChange": isChange,
            "state": state,
            "date": date
        ]
    }
}
