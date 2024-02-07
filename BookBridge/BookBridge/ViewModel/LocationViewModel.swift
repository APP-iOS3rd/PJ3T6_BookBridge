//
//  NaverMapCoordinator.swift
//  BookBridge
//
//  Created by 이민호 on 2/2/24.
//

import Foundation
import NMapsMap
import Alamofire
import SwiftyJSON
import SwiftUI

final class LocationViewModel: NSObject, ObservableObject, NMFMapViewCameraDelegate, NMFMapViewTouchDelegate, CLLocationManagerDelegate {
    @Published var coord: (Double, Double) = (0.0, 0.0)
    @Published var userLocation: (Double, Double) = (0.0, 0.0) // lat, lng
    var prevCirclrRadius: CGFloat = 100
    @Published var circleRadius: CGFloat = 100 {
        didSet {
            if isUpdated(cur: circleRadius, prev: prevCirclrRadius) {
                prevCirclrRadius = circleRadius
                fetchUserLocation(circle: circle)
            }
        }
    }
    let circle = NMFCircleOverlay()
    static let shared = LocationViewModel()
    let view = NMFNaverMapView(frame: .zero)
    var locationManager: CLLocationManager?
    var isSliding = false
                        
    func isUpdated(cur: CGFloat, prev: CGFloat) -> Bool {
        return cur != prev
    }
    
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
    
    func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }        
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            checkLocationAuthorization()
        case .restricted:
            print("위치 정보 접근이 제한되었습니다.")
        case .denied:
            print("위치 정보 접근을 거절했습니다. 설정에 가서 변경하세요.")
        case .authorizedAlways, .authorizedWhenInUse:
            print("Success")
            
            coord = (Double(locationManager.location?.coordinate.latitude ?? 0.0), Double(locationManager.location?.coordinate.longitude ?? 0.0))
            userLocation = (Double(locationManager.location?.coordinate.latitude ?? 0.0), Double(locationManager.location?.coordinate.longitude ?? 0.0))
            
            fetchUserLocation(circle: circle)
            print("userLocation: \(userLocation)")
            
            getDistrict(long: userLocation.1, lat: userLocation.0) { result in
                if let result = result {
                    LocationManager.shared.setLocation(
                        lat: self.userLocation.0,
                        long: self.userLocation.1,
                        city: result[0],
                        distriction: result[1],
                        dong: result[2]
                    )
                                        
                    print("(\(LocationManager.shared.long),\(LocationManager.shared.lat)), \(LocationManager.shared.city) \(LocationManager.shared.distriction) \(LocationManager.shared.dong)")
                } else {
                    print("위치정보를 받아오지 못함")
                }
            }
            
        @unknown default:
            break
        }
    }
    
    func requestUseAuthorization(completion: @escaping () -> Void) {
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        if let locationManager = self.locationManager {
            locationManager.requestWhenInUseAuthorization()
        }
        completion()
    }
            
    func checkIfLocationServiceIsEnabled() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async {
                    self.requestUseAuthorization {
                        self.checkLocationAuthorization()
                    }
                }
            } else {
                print("Show an alert letting them know this is off and to go turn i on")
            }
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        // 카메라 이동이 시작되기 전 호출되는 함수
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        // 카메라의 위치가 변경되면 호출되는 함수
    }
    
    // 사용자 현재 위치 지도에 표시
    func fetchUserLocation(circle: NMFCircleOverlay) {
        if let locationManager = locationManager {
            let lat = locationManager.location?.coordinate.latitude
            let lng = locationManager.location?.coordinate.longitude
            var zoom: Double = 0
            print("circleRadius: \(circleRadius)")
            
            if circleRadius == 100 {
               zoom = 13
            }
            
            if circleRadius == 110 {
                zoom = 12
            }
            
            if circleRadius == 120 {
                zoom = 11.7
            }
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat ?? 0.0, lng: lng ?? 0.0), zoomTo: zoom)
                        
            cameraUpdate.animation = .easeIn
            cameraUpdate.animationDuration = 1
            
            let locationOverlay = view.mapView.locationOverlay
            locationOverlay.location = NMGLatLng(lat: lat ?? 0.0, lng: lng ?? 0.0)
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
    }
            
    func getNaverMapView() -> NMFNaverMapView {
        view
    }
    
    func getDistrict(long: Double, lat: Double, completion: @escaping ([String]?) -> Void) {
        let urlStr = NaverMapApiManager.ADDRESS_URL
        let param: Parameters = [
            "coords":"\(long),\(lat)",
            "output":"json"
        ]
        
        guard let naverKeyId = Bundle.main.naverKeyId else {
            print("naverKeyId 키를 로드하지 못했습니다.")
            return
        }
                
        guard let naverKey = Bundle.main.naverKey else {
            print("naverKey 키를 로드하지 못했습니다.")
            return
        }
                        
        let header1 = HTTPHeader(name: "X-NCP-APIGW-API-KEY-ID", value: naverKeyId)
        let header2 = HTTPHeader(name: "X-NCP-APIGW-API-KEY", value: naverKey)
        let headers = HTTPHeaders([header1,header2])
        
        let alamo = AF.request(urlStr, method: .get, parameters: param, headers: headers)
        alamo.validate().responseJSON { response in
            switch response.result {
            case .success(let value) :
                let json = JSON(value)
                let data = json["results"]
                let city = data[0]["region"]["area1"]["name"].string ?? ""
                let district = data[0]["region"]["area2"]["name"].string ?? ""
                let dong = data[0]["region"]["area3"]["name"].string ?? ""
                let result = [city, district, dong]
                completion(result)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    func update() {
        print("update")
    }
}
