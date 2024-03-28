//
//  LocationManager.swift
//  BookBridge
//
//  Created by 이민호 on 2/5/24.
//



import Foundation

class LocationManager: ObservableObject {
    static let shared = LocationManager()
    private init() {}
    
    @Published var dong: String = ""
    var lat = 0.0
    var long = 0.0
    var city: String = ""
    var distriction: String = ""
    var distance = 1
    var isSelected = true
    var isLocationPermitted = false
    
    func setLocation(lat: Double, long: Double, city: String, distriction: String, dong: String, isLocationPermitted: Bool) {
        self.lat = lat
        self.long = long
        self.city = city        
        self.distriction = distriction
        self.dong = dong
        self.isLocationPermitted = isLocationPermitted
    }
}
