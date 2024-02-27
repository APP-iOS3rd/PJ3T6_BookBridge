//
//  ExchangeHopeView.swift
//  BookBridge
//
//  Created by 김지훈 on 2024/02/06.
//

import SwiftUI
import NMapsMap
import CoreLocation

struct ExchangeHopeView: View {
    
    @State var myCoord: (Double, Double) = (0, 0)
    @ObservedObject var viewModel: PostingViewModel
    
    //이전화면으로 돌아가기
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                UIExchangeHopeView(myCoord: $myCoord, markerCoord: $viewModel.markerCoord, location: $viewModel.noticeBoard.noticeLocationName)
                    .edgesIgnoringSafeArea(.all)
                
                ExchangeHopeExplainView()
                    .frame(height: geometry.size.height * 0.02)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.2)//상단으로
                    .edgesIgnoringSafeArea(.all)
                    .navigationBarBackButtonHidden(true) // 뒤로 가기 버튼 숨기기
                
                Button(action: {
                    // 교환 희망 장소 위치
                    if let lat = viewModel.markerCoord?.lat, let lng = viewModel.markerCoord?.lng {
                        viewModel.updateNoticeLocation(lat: lat, lng: lng)
                    }
                    // 교환 희망 장소 도로명
                    viewModel.updateNoticeLocationName(name: viewModel.noticeBoard.noticeLocationName)
                    
                    dismiss()
                }) {
                    Text("선택완료")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(hex:"59AAE0"))
                        .cornerRadius(10)
                    
                }
                .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.08) // 버튼의 크기를 설정
                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.91) // 하단에 위치
                .padding(.bottom, geometry.safeAreaInsets.bottom) // 하단 세이프 에어리어만큼 패딩 추가
                
            }
        }
        .onAppear{
            // LocationManager로부터 초기 위치 데이터를 받아오는 로직
            self.myCoord = (LocationManager.shared.lat,LocationManager.shared.long)
//            viewModel.markerCoord = NMGLatLng(lat: self.myCoord.0, lng: self.myCoord.1)
        }
        
    }
    
    
}

struct UIExchangeHopeView: UIViewRepresentable {
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
        }else {
            cameraUpdate = NMFCameraUpdate(scrollTo:NMGLatLng(lat: myCoord.0, lng: myCoord.1), zoomTo: 15)
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
        var parent: UIExchangeHopeView
        var marker: NMFMarker? = nil
        
        init(_ parent: UIExchangeHopeView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
            parent.markerCoord = latlng
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


