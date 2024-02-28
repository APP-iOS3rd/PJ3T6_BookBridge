//
//  UIExchangeHopeView.swift
//  BookBridge
//
//  Created by 노주영 on 2/27/24.
//

import SwiftUI
import NMapsMap
import CoreLocation

struct ChatUIExchangeHopeView: UIViewRepresentable {
    @Binding var myCoord: (Double, Double)
    @Binding var markerCoord: NMGLatLng?
    @Binding var location: String
    
    // View 생성
    func makeUIView(context: Context) -> NMFNaverMapView {
        let mapView = NMFNaverMapView()
        
        mapView.mapView.touchDelegate = context.coordinator
        
        // 내 위치 활성화 버튼
        mapView.showLocationButton = true
        // 초기 카메라 위치 줌
        let cameraUpdate: NMFCameraUpdate
        
        // 마커가 없을때, 내 위치. 있으면, 마커위치
        if let cameraCoord = markerCoord {
            cameraUpdate = NMFCameraUpdate(scrollTo: cameraCoord, zoomTo: 15)
        } else {
            cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: myCoord.0, lng: myCoord.1), zoomTo: 15)
        }
        
        mapView.mapView.moveCamera(cameraUpdate)
        return mapView
    }
    
    // View 변경시 호출
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        // 새로운 내 위치 또는 마커 위치로 카메라 업데이트
        let cameraUpdate: NMFCameraUpdate
        
        if let markerCoord = markerCoord {
            context.coordinator.updateMarkerPosition(markerCoord, on: uiView.mapView)
            cameraUpdate = NMFCameraUpdate(scrollTo: markerCoord, zoomTo: 15)
        } else {
            let newMyCoord = NMGLatLng(lat: myCoord.0, lng: myCoord.1)
            cameraUpdate = NMFCameraUpdate(scrollTo: newMyCoord, zoomTo: 15)
        }
        
        uiView.mapView.moveCamera(cameraUpdate)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)  // 'self'를 Coordinator에 전달
    }
    
    class Coordinator: NSObject, NMFMapViewTouchDelegate {
        var parent: ChatUIExchangeHopeView
        var marker: NMFMarker? = nil
        
        init(_ parent: ChatUIExchangeHopeView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
            //parent.markerCoord = latlng
        }
        
        func updateMarkerPosition(_ position: NMGLatLng, on mapView: NMFMapView) {
            // 기존 마커 제거
            marker?.mapView = nil
            // 새로운 마커 생성 및 추가
            let newMarker = NMFMarker(position: position)
            newMarker.mapView = mapView
            marker = newMarker
            // 마커 도로명 주소 불러오기
            NaverLocationService.shared.fetchLocationInfo(for: position) { [weak self] info in
                DispatchQueue.main.async {
                    guard let info = info else { return }
                    self?.parent.location = info.name
                    self?.parent.markerCoord = NMGLatLng(lat: info.latitude, lng: info.longitude)
                }
            }
        }
    }
}


