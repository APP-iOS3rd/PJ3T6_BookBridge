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
    var city: String = ""
    var distriction: String = ""
    var dong: String = ""
    var distance = 1
    var isSelected = true
    
    func setLocation(lat: Double, long: Double, city: String, distriction: String, dong: String) {
        self.lat = lat
        self.long = long
        self.city = city        
        self.distriction = distriction
        self.dong = dong
    }
}
