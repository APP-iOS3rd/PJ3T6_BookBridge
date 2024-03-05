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
    @Published var showLocationAlert = false
    
    static let shared = LocationViewModel()
    let view = NMFNaverMapView(frame: .zero)
    var locationManager: CLLocationManager?
    
    override init() {
        super.init()
                        
        showLocationAlert = false
        
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
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            guard let locationManager = self.locationManager else { return }
            locationManager.requestWhenInUseAuthorization()
            checkLocationAuthorization()
    }
    
    func checkLocationAuthorization() {
        guard let locationManager = self.locationManager else { return }
                        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            print("위치 정보 접근이 선택되지 않았습니다.")
        case .restricted:
            print("위치 정보 접근이 제한되었습니다.")
        case .denied:
            print("위치 정보 접근이 거부되었습니다.")
            
            LocationManager.shared.setLocation(
                lat: 37.5568,
                long: 126.9783,
                city: "서울특별시",
                distriction: "중구",
                dong: "북창동",
                isLocationPermitted: false
            )
            
            print("(\(LocationManager.shared.long),\(LocationManager.shared.lat)), \(LocationManager.shared.city) \(LocationManager.shared.distriction) \(LocationManager.shared.dong), 위치허용여부: \(LocationManager.shared.isLocationPermitted)")
            
        case .authorizedAlways, .authorizedWhenInUse:
            print("위치 정보 접근이 허용되었습니다.")
                                    
            coord = (Double(locationManager.location?.coordinate.latitude ?? 0.0), Double(locationManager.location?.coordinate.longitude ?? 0.0))
            userLocation = (Double(locationManager.location?.coordinate.latitude ?? 0.0), Double(locationManager.location?.coordinate.longitude ?? 0.0))
                        
            print("userLocation: \(userLocation)")
            
            getDistrict(long: userLocation.1, lat: userLocation.0) { result in
                if let result = result {
                    LocationManager.shared.setLocation(
                        lat: self.userLocation.0,
                        long: self.userLocation.1,
                        city: result[0],
                        distriction: result[1],
                        dong: result[2],
                        isLocationPermitted: true
                    )
                                        
                    print("(\(LocationManager.shared.long),\(LocationManager.shared.lat)), \(LocationManager.shared.city) \(LocationManager.shared.distriction) \(LocationManager.shared.dong)")
                } else {
                    print("위치정보를 받아오지 못했습니다.")
                }
            }
            
        @unknown default:
            break
        }
    }
    
    // 권한 요청하기
    func requestUseAuthorization(completion: @escaping () -> Void) {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        self.locationManager = locationManager
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
    
    func setShowLocationAlert() {
        self.showLocationAlert = false
    }
}
