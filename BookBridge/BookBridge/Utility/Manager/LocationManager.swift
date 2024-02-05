//
//  LocationManager.swift
//  BookBridge
//
//  Created by 이민호 on 2/5/24.
//



import Foundation

class LocationManager {
    static let shared = LocationManager()
    private init() {}
    
    var lat = 0.0
    var long = 0.0
    var distriction: String = ""
    
    func setLocation(lat: Double, long: Double, distriction: String) {
        self.lat = lat
        self.long = long
        self.distriction = distriction
    }
}
