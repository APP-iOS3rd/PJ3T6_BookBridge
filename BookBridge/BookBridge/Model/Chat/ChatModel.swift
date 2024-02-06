//
//  ChatModel.swift
//  BookBridge
//
//  Created by jmyeong on 2/5/24.
//

import Foundation

struct Chat: Hashable, Identifiable {
    var id: String                        //uuid
    var userId: String
    var message: String?
    var photoURL: String?
    var location: [Double?]                //0번은 위도, 1번은 경도                https://github.com/imperiumlabs/GeoFirestore-iOS
    var date: Date
}
