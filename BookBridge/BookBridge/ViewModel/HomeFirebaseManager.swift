//
//  StorageManager.swift
//  BookBridge
//
//  Created by 이현호 on 1/29/24.
//

import Foundation
import Firebase
import FirebaseStorage

class HomeFirebaseManager {
    static let shared = HomeFirebaseManager()
    
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
