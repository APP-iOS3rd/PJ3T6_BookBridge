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

final class LocationViewModel: NSObject, ObservableObject, NMFMapViewCameraDelegate, NMFMapViewTouchDelegate, CLLocationManagerDelegate {
    @Published var coord: (Double, Double) = (0.0, 0.0)
    @Published var userLocation: (Double, Double) = (0.0, 0.0) // lat, lng
    @Published var distriction: String?
    
    static let shared = LocationViewModel()
    let view = NMFNaverMapView(frame: .zero)
    var locationManager: CLLocationManager?
                        
    override init() {
        super.init()
        
        view.mapView.positionMode = .direction
        view.mapView.isNightModeEnabled = true
        
        view.mapView.zoomLevel = 15
        view.mapView.minZoomLevel = 10 // 최소 줌 레벨
        view.mapView.maxZoomLevel = 17 // 최대 줌 레벨
        
        view.showLocationButton = true
        view.showZoomControls = true // 줌 확대, 축소 버튼 활성화
        view.showCompass = false
        view.showScaleBar = false
        
        view.mapView.addCameraDelegate(delegate: self)
        view.mapView.touchDelegate = self
    }
    
    func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("위치 정보 접근이 제한되었습니다.")
        case .denied:
            print("위치 정보 접근을 거절했습니다. 설정에 가서 변경하세요.")
        case .authorizedAlways, .authorizedWhenInUse:
            print("Success")
            
            coord = (Double(locationManager.location?.coordinate.latitude ?? 0.0), Double(locationManager.location?.coordinate.longitude ?? 0.0))
            userLocation = (Double(locationManager.location?.coordinate.latitude ?? 0.0), Double(locationManager.location?.coordinate.longitude ?? 0.0))
            
            // fetchUserLocation()
            print("userLocation: \(userLocation)")
            
            getDistrict(long: userLocation.1, lat: userLocation.0) { district in
                if let district = district {
                    self.distriction = district
                    print(self.distriction ?? "error")
                }
            }
            
        @unknown default:
            break
        }
    }
    
    func checkIfLocationServiceIsEnabled() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async {
                    self.locationManager = CLLocationManager()
                    self.locationManager!.delegate = self
                    self.checkLocationAuthorization()
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
    func fetchUserLocation() {
        if let locationManager = locationManager {
            let lat = locationManager.location?.coordinate.latitude
            let lng = locationManager.location?.coordinate.longitude
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat ?? 0.0, lng: lng ?? 0.0), zoomTo: 15)
            cameraUpdate.animation = .easeIn
            cameraUpdate.animationDuration = 1
            
            let locationOverlay = view.mapView.locationOverlay
            locationOverlay.location = NMGLatLng(lat: lat ?? 0.0, lng: lng ?? 0.0)
            locationOverlay.hidden = false
            
            locationOverlay.icon = NMFOverlayImage(name: "location_overlay_icon")
            locationOverlay.iconWidth = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
            locationOverlay.iconHeight = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
            locationOverlay.anchor = CGPoint(x: 0.5, y: 1)
            
            view.mapView.moveCamera(cameraUpdate)
        }
    }
    
    func getNaverMapView() -> NMFNaverMapView {
        view
    }
    
    func getDistrict(long: Double, lat: Double, completion: @escaping (String?) -> Void) {
        let urlStr = NaverMapApiManager.ADDRESS_URL
        let param: Parameters = [
            "coords":"\(long),\(lat)",
            "output":"json"
        ]
        let header1 = HTTPHeader(name: "X-NCP-APIGW-API-KEY-ID", value: NaverMapApiManager.NAVER_API_ID)
        let header2 = HTTPHeader(name: "X-NCP-APIGW-API-KEY", value: NaverMapApiManager.NAVER_API_KEY)
        let headers = HTTPHeaders([header1,header2])

        let alamo = AF.request(urlStr, method: .get, parameters: param, headers: headers)
        alamo.validate().responseJSON { response in
            switch response.result {
            case .success(let value) :
                let json = JSON(value)
                let data = json["results"]
                let district = data[0]["region"]["area2"]["name"].string ?? ""
                completion(district)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
}
