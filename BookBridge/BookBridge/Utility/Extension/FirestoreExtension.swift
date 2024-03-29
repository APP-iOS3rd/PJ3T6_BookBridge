//
//  FirestoreExtension.swift
//  BookBridge
//
//  Created by 이민호 on 3/12/24.
//

import FirebaseFirestore
import Combine

extension Firestore {
    func updateUserPhoneNumber(userID: String, newPhoneNumber: String) -> AnyPublisher<Void, Error> {
        let documentReference = self.collection("User").document(userID)
        return Future<Void, Error> { promise in
            documentReference.updateData(["phoneNumber": newPhoneNumber]) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
