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
                ExchangeHopeExplainView()
                    .frame(height: geometry.size.height * 0.02)
                    .padding(.top,30)
                    .navigationBarBackButtonHidden(true)
                    .zIndex(1)
                ZStack {
                    UIExchangeHopeView(myCoord: $myCoord, markerCoord: $viewModel.markerCoord, location: $viewModel.noticeBoard.noticeLocationName)
                        .edgesIgnoringSafeArea(.all)
                    
                    
                    
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



