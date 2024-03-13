//
//  ExchangeHopeView.swift
//  BookBridge
//
//  Created by 김지훈 on 2024/02/06.
//

import SwiftUI
import NMapsMap
import CoreLocation

struct ChatExchangeHopeView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel: ChatMessageViewModel
    
    @State var myCoord: (Double, Double) = (0, 0)
    @State var markerCoord: NMGLatLng?
    @State var location: String = ""
   
    var chatRoomListId: String
    var partnerId: String
    var uid: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    ZStack {
                        HStack {
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundStyle(.black)
                            }
                    
                            Spacer()
                        }
                        
                        Text("위치공유")
                    }
                    .padding(.horizontal)
                    
                    UIExchangeHopeView(myCoord: $myCoord, markerCoord: $markerCoord, location: $location)
                        .frame(maxHeight: geometry.size.height)
                        .edgesIgnoringSafeArea(.all)
                }
                
                Button(action: {
                    // 교환 희망 장소 위치
                    if let lat = markerCoord?.lat, let lng = markerCoord?.lng {
                        if viewModel.saveChatRoomId != "" {
                            if viewModel.chatMessages.isEmpty {
                                viewModel.handleNoChatRoom(uid: uid, partnerId: partnerId, chatRoomListId: chatRoomListId) {
                                    viewModel.handleSendLocation(uid: uid, partnerId: partnerId, lat: lat, lng: lng, location: location) {
                                        myCoord = (0, 0)
                                        markerCoord = nil
                                        location = ""
                                    }
                                }
                            } else {
                                viewModel.handleSendLocation(uid: uid, partnerId: partnerId, lat: lat, lng: lng, location: location) {
                                    myCoord = (0, 0)
                                    markerCoord = nil
                                    location = ""
                                }
                            }
                        } else {
                            viewModel.handleSendNoId(uid: uid, partnerId: partnerId, completion: {
                                viewModel.handleSendLocation(uid: uid, partnerId: partnerId, lat: lat, lng: lng, location: location) {
                                    myCoord = (0, 0)
                                    markerCoord = nil
                                    location = ""
                                    viewModel.fetchMessages(uid: uid)
                                }
                            })
                        }
                    }
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
        .navigationBarBackButtonHidden(true)
        .onAppear{
            // LocationManager로부터 초기 위치 데이터를 받아오는 로직
            self.myCoord = (LocationManager.shared.lat,LocationManager.shared.long)

        }
    }
    
    
}
