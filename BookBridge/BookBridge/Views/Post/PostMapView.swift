//
//  PostMapView.swift
//  BookBridge
//
//  Created by 이민호 on 2/22/24.
//

import SwiftUI
import NMapsMap

struct PostMapView: UIViewRepresentable {
    
    @Binding var lat: Double // 모델 좌표 lat
    @Binding var lng: Double // 모델 좌표 lng
    var isDetail: Bool
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        let mapView = NMFNaverMapView()
        
        if !isDetail {
            mapView.mapView.isScrollGestureEnabled = false
            mapView.mapView.isZoomGestureEnabled = false
            mapView.showZoomControls = false
        }
        
        // 마커 좌표를 설정
        let markerCoord = NMGLatLng(lat: lat, lng: lng)
        
        // 내 위치 활성화 버튼을 표시
        //        mapView.showLocationButton = true
        
        // 초기 카메라 위치를 마커의 위치로 설정하고 줌 레벨을 조정
        let cameraUpdate = NMFCameraUpdate(scrollTo: markerCoord, zoomTo: 15)
        mapView.mapView.moveCamera(cameraUpdate)
        
        // 마커를 생성하고 지도에 표시
        let marker = NMFMarker(position: markerCoord)
        marker.mapView = mapView.mapView
        
        return mapView
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        //        _ = NMGLatLng(lat: lat, lng: lng)
        //        _ = NMFCameraUpdate(scrollTo: newMyCoord)
    }
}
