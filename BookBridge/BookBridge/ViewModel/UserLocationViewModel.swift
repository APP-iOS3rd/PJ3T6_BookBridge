//
//  UserLocationViewModel.swift
//  BookBridge
//
//  Created by 이민호 on 2/7/24.
//

import Foundation
import SwiftUI
import NMapsMap

final class UserLocationViewModel: NSObject, ObservableObject, NMFMapViewCameraDelegate, NMFMapViewTouchDelegate, CLLocationManagerDelegate {
    
    @Published var lat: Double? {
        didSet {
            reset()
            fetchUserLoaction(circle: circle)
        }
    }
    
    @Published var lng: Double? {
        didSet {
            reset()
            fetchUserLoaction(circle: circle)
        }
    }
    
    @Published var circleRadius: CGFloat = 100 {
        didSet {
            if isUpdated(cur: circleRadius, prev: prevCircleRadius) {
                prevCircleRadius = circleRadius
                fetchUserLoaction(circle: circle)
            }
        }
    }
        
    static let shared = UserLocationViewModel()
    let view = NMFNaverMapView(frame: .zero)
    var locationManger: CLLocationManager?
    var circle = NMFCircleOverlay()
    var prevCircleRadius: CGFloat = 100
            
    override init() {
        super.init()
        
        view.mapView.positionMode = .direction
        view.mapView.isNightModeEnabled = true
        
        view.mapView.zoomLevel = 8
        view.mapView.minZoomLevel = 8 // 최소 줌 레벨
        view.mapView.maxZoomLevel = 17 // 최대 줌 레벨
        
        view.showLocationButton = false
        view.showZoomControls = false // 줌 확대, 축소 버튼 활성화
        view.showCompass = false
        view.showScaleBar = false
        
        view.mapView.isScrollGestureEnabled = false
        view.mapView.addCameraDelegate(delegate: self)
        view.mapView.touchDelegate = self
    }
    
    func fetchUserLoaction(circle: NMFCircleOverlay) {
        if let lat = lat, let lng = lng {
            var zoom: Double = getZoomValue(value: Int(self.circleRadius))
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng), zoomTo: zoom)
            
            cameraUpdate.animation = .easeIn
            cameraUpdate.animationDuration = 1
            
            let locationOverlay = view.mapView.locationOverlay
            locationOverlay.location = NMGLatLng(lat: lat, lng: lng)
            locationOverlay.hidden = false
            
            locationOverlay.icon = NMFOverlayImage(name: "marker")
            locationOverlay.iconWidth = CGFloat(42)
            locationOverlay.iconHeight = CGFloat(42)
            locationOverlay.anchor = CGPoint(x: 0.5, y: 1)
            locationOverlay.circleRadius = 100
            locationOverlay.circleOutlineColor = Color(hex: "#a2c4fa").asUIColor()
            locationOverlay.circleOutlineWidth = 2
            
            view.mapView.moveCamera(cameraUpdate)
        }
    }
    
    func setLocation(lat: Double, lng: Double, distance: Int) {
        self.lat = lat
        self.lng = lng
        self.circleRadius = CGFloat(changeDistanceToKilometer(value: distance))
    }
    
    func reset() {
        circle = NMFCircleOverlay()
    }
    
    func isUpdated(cur: CGFloat, prev: CGFloat) -> Bool {
        return cur != prev
    }
    
    func getNaverMapView() -> NMFNaverMapView {
        view
    }
    
    func changeDistanceToKilometer(value: Int) -> Int {
        switch value {
        case 2:
            return 110
        case 3:
            return 120
        default:
            return 100
        }
    }
    
    func changeKilometerToDistance(value: Int) -> Int {
        switch value {
        case 110:
            return 2
        case 120:
            return 3
        default:
            return 1
        }
    }
    
    func getZoomValue(value: Int) -> Double {
        switch value {
        case 110:
            return 12
        case 120:
            return 11.7
        default:
            return 13
        }
    }
}
