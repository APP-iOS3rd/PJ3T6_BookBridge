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
    
    @Published var lat: Double = 0.0 {
        didSet {
            reset()
            fetchUserLoaction(circle: circle)
        }
    }
    
    @Published var lng: Double = 0.0 {
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
                updateDistance()
            }
        }
    }
    
    @Published var locations: [Location]?
    @Published var location: Location?
    @Published var selectedLocation: Location?
                
    static let shared = UserLocationViewModel()
    let locationManager = LocationManager.shared
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
        view.mapView.isZoomGestureEnabled = false // 줌 확대, 축소 제스처 활성화
        view.mapView.isRotateGestureEnabled = false // 지도 회전 제스처 활성화
        view.mapView.isStopGestureEnabled = false
        view.mapView.addCameraDelegate(delegate: self)
        view.mapView.touchDelegate = self
    }
    
    func fetchUserLoaction(circle: NMFCircleOverlay) {
       
        let zoom: Double = ConvertManager.getZoomValue(value: Int(self.circleRadius))
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng), zoomTo: zoom)
        
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 0.8
        
        let locationOverlay = view.mapView.locationOverlay
        locationOverlay.location = NMGLatLng(lat: lat, lng: lng)
        locationOverlay.hidden = false
        
        locationOverlay.icon = NMFOverlayImage(name: "marker")
        locationOverlay.iconWidth = CGFloat(42)
        locationOverlay.iconHeight = CGFloat(42)
        locationOverlay.anchor = CGPoint(x: 0.5, y: 1)
        locationOverlay.circleRadius = self.circleRadius
        locationOverlay.circleOutlineColor = Color(hex: "#a2c4fa").asUIColor()
        locationOverlay.circleOutlineWidth = 2
        
        view.mapView.moveCamera(cameraUpdate)
        
    }
    
    func setLocation(lat: Double, lng: Double, distance: Int) {
        self.lat = lat
        self.lng = lng
        
        // prevCircleRadius, circleRadius 초기화
        let radius = CGFloat(ConvertManager.changeDistanceToKilometer(value: distance))
        self.prevCircleRadius = radius
        self.circleRadius = radius
    }
    
    func setLocations(locations: [Location]) {
        self.locations = locations
        
        // locations중 isSelected된 location 찾기
        let location = locations.filter{ $0.isSelected == true }.first
        
        // selectLocation 실행
        if let location = location {
            selectLocation(location: location)
        }
    }
    
    func selectLocation(location: Location) {
        // 현재 location 설정
        self.selectedLocation = location
                                
        // 다른 location은 isSelected false
        setSelectedLocation()
                                                           
        // 카메라 로케이션 설정
        setLocation(lat: location.lat ?? 0.0, lng: location.long ?? 0.0, distance: location.distance ?? 1)
        
        // 카메라에 표시
        reset()
        fetchUserLoaction(circle: circle)
    }
    
    func setSelectedLocation() {
        if let locations = self.locations {
            var targetLocations = locations
            for index in targetLocations.indices  {
                if targetLocations[index].id == selectedLocation?.id {
                    targetLocations[index].isSelected = true
                } else {
                    targetLocations[index].isSelected = false
                }
            }
            
            self.locations = targetLocations
        }
    }
    
    func deleteLocation(location: Location) {
        // index값 가져오기
            let index = findIndex(target: location)
        
        // 해당 index에 해당하는 값 지우기
        // 해당 값이 isSelected이면 locations[0]을 isSelected로 만든후 selectedLocation도 locations[0]으로 만들기
        if let index = index {
            locations?.remove(at: index)
           
            selectedLocation = locations?[0]
            
            if let location = locations?[0] {
                selectLocation(location: location)
            }
        }
    }
    
    func updateDistance() {
        guard let location = selectedLocation else { return }
        let index = findIndex(target: location)
                        
        // 현제 Radius를 distance로 변경
        let targetDistance = ConvertManager.changeKilometerToDistance(value: Int(circleRadius))
        
        // distance를 locations의 해당 location에 적용
        if let index = index {
            locations?[index].distance = targetDistance
        }
    }
    
    func findIndex(target: Location) -> Int? {
        if let locations = locations {
            for (index, location) in locations.enumerated() {
                if location.id == target.id {
                    return index
                }
            }
        }
        
        return nil
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
    
    func makeLocationByCurLocation() -> Location {
        return Location(
            id: UUID().uuidString,
            lat: locationManager.lat,
            long: locationManager.long,
            city: locationManager.city,
            distriction: locationManager.distriction,
            dong: locationManager.dong,
            distance: 1
        )
    }

}
