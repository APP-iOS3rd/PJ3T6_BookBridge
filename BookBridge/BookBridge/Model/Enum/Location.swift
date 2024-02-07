//
//  Location.swift
//  BookBridge
//
//  Created by 이민호 on 2/2/24.
//

import Foundation

struct Location: Codable, Identifiable {
    var id: String?
    var lat: Double?
    var long: Double?
    var city: String?
    var distriction: String?
    var dong: String?
    var distance: Int?
}
