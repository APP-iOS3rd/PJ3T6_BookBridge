import FirebaseFirestore
import FirebaseStorage
import SwiftUI


class ChangePostViewModel : ObservableObject {
    
    private var db = Firestore.firestore()
    private var storage = Storage.storage()
    
    func uploadPost(title: String, detail: String, images: [UIImage]) {
        
        // when uploading, init image reference name
        let postId = UUID().uuidString
        
        // create image name list
        var imgNameList: [String] = []
        
        // iterate over images
        for img in images {
            let imgName = UUID().uuidString
            imgNameList.append(imgName)
            uploadImage(image: img, name: (postId + "/" + imgName))
        }
        
        // create post object
        let post = Post(noticeBoardId: postId, userId: "userId", noticeBoardTitle: title, noticeBoardDetail: detail, noticeImageLink: imgNameList, isChange: true, state: [], date: Date())
        
        // Storing to DB
        let _ = db.collection("Post").document(postId).setData(post.dictionary)
        
    }
    
    
    func uploadImage(image: UIImage?, name: String) {
        
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else {
            return
        }
        
        let storageRef = storage.reference().child("images/\(name)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        // uploda data
        storageRef.putData(imageData, metadata: metadata) { (metadata, err) in
            if let err = err {
                print("err when uploading jpg\n\(err)")
            }
            
            if let metadata = metadata {
                print("metadata: \(metadata)")
            }
        }
        
        
    }
    
}
