
import FirebaseFirestore
import FirebaseStorage
import SwiftUI


class FindPostViewModel : ObservableObject {
    
    private var db = Firestore.firestore()
    
    func uploadPost(title: String, detail: String ) {
        
        // when uploading, init image reference name
        let postId = UUID().uuidString
        
        
        // create post object
        let post = FindPost(noticeBoardId: postId, userId: "userId", noticeBoardTitle: title, noticeBoardDetail: detail, isChange: true, state: [], date: Date())
        
        
        let user = db.collection("user").document("userId")
        // user/userId/myNoticeBoard/noticeBoardId                    //내 게시물
        let _ = user.collection("myNoticeBoard").document(postId).setData(post.dictionary)
        // user/userId/opponentNoticeBoard/noticeBoardId                //요청 내역
        let _ = user.collection("opponentNoticeBoard").document(postId).setData(post.dictionary)
        // user/userId/bookmarkoticeBoard/noticeBoardId                //관심목록
        let _ = user.collection("bookmarkoticeBoard").document(postId).setData(post.dictionary)
        
        // noticeBoard/noticeBoardId/
        let _ = db.collection("noticeBoard").document(postId).setData(post.dictionary)
        
        
    }
}
