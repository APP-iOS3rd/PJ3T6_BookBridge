//
//  StorageManager.swift
//  BookBridge
//
//  Created by 이현호 on 1/29/24.
//

import Foundation
import Firebase
import FirebaseStorage
import PhotosUI


extension UIImage {
    func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

// StorageImage 모델
struct StorageImage : Hashable {
    var name: String
    var fullPath: String
    var image: UIImage
    
    init(name: String, fullPath: String, image: UIImage) {
        self.name = name
        self.fullPath = fullPath
        self.image = image
    }
}


class StorageManager {
    static let shared = StorageManager()
    
    let storage = Storage.storage()
    
    private init() {}
    //gs://bookbridge-a9403.appspot.com/images/344F4696-3826-407F-B4CB-31CF6300BB3D/2BD8F8E9-0419-4EC1-9566-D6C1FCC6A69A
    func downloadImage(noticeiId: String, imageId: String, completion: (URL) -> Void) async throws {
        do {
            let url = try await storage.reference(forURL: "gs://bookbridge-a9403.appspot.com/images/\(noticeiId)/\(imageId)").downloadURL()
            
            completion(url)
        } catch {
            print("error")
        }
    }
}
