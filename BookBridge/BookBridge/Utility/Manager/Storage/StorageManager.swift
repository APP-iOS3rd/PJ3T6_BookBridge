//
//  StorageManager.swift
//  BookBridge
//
//  Created by 이민호 on 2/22/24.
//

import Foundation
import Firebase

class StorageManager {
    static let storage = Storage.storage()
    
    static func fetchImageURL(address: String, completion: @escaping ([URL]?) -> ()) {
        let storageRef = storage.reference().child(address)
        
        storageRef.listAll{ (result, error) in
            if let error = error {
                print("이미지 URL을 불러오지 못하였습니다.\n", error.localizedDescription)
            } else {
                if let result = result {
                    var urls: [URL] = []
                    for item in result.items {
                        item.downloadURL{ (url, error) in
                            if let url = url {
                                urls.append(url)
                                if urls.count == result.items.count {
                                    completion(urls)
                                }
                            } else if let error = error {
                                print("url을 불러오지 못하였습니다.\n", error.localizedDescription)
                            }
                        }
                    }
                    
                }
            }
        }
    }
}

