//
//  MessageItemView.swift
//  BookBridge
//
//  Created by 노주영 on 2/14/24.
//

import SwiftUI
import NMapsMap
import CoreLocation

struct MessageItemView: View {
    @EnvironmentObject private var pathModel: TabPathViewModel

    @StateObject var viewModel: ChatMessageViewModel
    
    @State var chatLocation: [Double] = [100, 200]
    @State var chatLocationTuple: (Double, Double) = (0, 0)
    @State var shouldShowActionSheet = false
    @State var isCopyTapped = false
    @State private var isShowChatImageModal = false
    @State private var isPressed = false

    @State var messageModel: ChatMessageModel

    @Binding var showToast: Bool
    
    var chatRoomPartner: ChatPartnerModel
    var uid: String
    
    var body: some View {
        VStack {
            if messageModel.sender == uid {
                if messageModel.imageURL != "" {
                    HStack(alignment: .top) {
                        Spacer()
                        
                        VStack {
                            Spacer()
                            
                            Text(messageModel.timeAgo)
                                .font(.system(size: 10))
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        Image(uiImage: viewModel.chatImages[messageModel.imageURL] ?? UIImage(named: "DefaultImage")!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .cornerRadius(10)
                            .onTapGesture {
                                isShowChatImageModal = true
                            }
                    }
                } else if messageModel.location != [100, 200] {
                    HStack(alignment: .top) {
                        Spacer()
                        
                        VStack {
                            Spacer()
                            
                            Text(messageModel.timeAgo)
                                .font(.system(size: 10))
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        VStack {
                            PostMapView(lat: $chatLocation[0], lng: $chatLocation[1], isDetail: false)
                            
                            VStack {
                                if !messageModel.message.isEmpty {
                                    HStack(alignment: .top) {
                                        Text(messageModel.message)
                                            .font(.caption)
                                            .foregroundStyle(.black)
                                            .padding(.vertical, 5)
                                        
                                        Image(systemName: "doc.on.doc")
                                            .font(.caption)
                                            .foregroundColor(isCopyTapped ? Color.gray : Color.black)
                                            .padding(.vertical, 5)
                                            .onTapGesture {
                                                UIPasteboard.general.setValue(messageModel.message, forPasteboardType: "public.plain-text")
                                                isCopyTapped = true
                                                showToast = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                    withAnimation {
                                                        showToast = false
                                                    }
                                                }
                                            }
                                    }
                                }
                                
                                NavigationLink {
                                    ChatExchangeInfoView(myCoord: chatLocationTuple, markerCoord: NMGLatLng(lat: chatLocationTuple.0, lng: chatLocationTuple.1), partnerId: chatRoomPartner.partnerId, uid: uid)
                                } label: {
                                    Text("위치보기")
                                        .padding(.horizontal)
                                        .padding(.vertical, 10)
                                        .font(.subheadline)
                                        .frame(maxWidth: .infinity)
                                        .foregroundStyle(.black)
                                        .background(Color(uiColor: .systemGray5))
                                        .cornerRadius(10)
                                }
                                .padding(messageModel.message.isEmpty ? .top : [])
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.bottom)
                            .padding(.horizontal)
                        }
                        .frame(width: 250, height: 230)
                        .cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(hex: "D9D9D9"), lineWidth: 1)
                        )
                    }
                } else {
                    HStack(alignment: .top) {
                        Spacer()
                        
                        VStack {
                            Spacer()
                            
                            Text(messageModel.timeAgo)
                                .font(.system(size: 10))
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        HStack {
                            Text(messageModel.message)
                                .font(.system(size: 18))
                                .foregroundStyle(.white)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(isPressed ? Color(hex:"417ca4") : Color(hex:"59AAE0"))
                        .cornerRadius(10)
                        // 메세지를 눌렀을경우
                        .self.modifier(PressGesture(shouldShowActionSheet: $shouldShowActionSheet, isPressed: $isPressed))
                        .sheet(isPresented: $shouldShowActionSheet){
                            SelectMessageItemView(shouldShowActionSheet: $shouldShowActionSheet, showToast: $showToast,  message: $messageModel.message)
                                .presentationDetents([.height(170)])
                                .ignoresSafeArea(.all)

                        }
                    }
                }
            } else {
                if messageModel.imageURL != "" {
                    HStack(alignment: .top) {
                        Image(uiImage: chatRoomPartner.partnerImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30)
                            .clipped()
                            .cornerRadius(15)
                            .onTapGesture {
                                pathModel.paths.append(.mypage(other: UserModel(id: chatRoomPartner.partnerId, nickname: chatRoomPartner.nickname, profileURL: chatRoomPartner.partnerImageUrl, style: chatRoomPartner.style, reviews: chatRoomPartner.reviews)))
                            }
                        
                        Image(uiImage: viewModel.chatImages[messageModel.imageURL] ?? UIImage(named: "DefaultImage")!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .cornerRadius(10)
                            .onTapGesture {
                                isShowChatImageModal = true
                            }
                        
                        VStack {
                            Spacer()
                            
                            Text(messageModel.timeAgo)
                                .font(.system(size: 10))
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.leading)
                        }
                        Spacer()
                    }
                } else if messageModel.location != [100, 200] {
                    HStack(alignment: .top) {
                        Image(uiImage: chatRoomPartner.partnerImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30)
                            .clipped()
                            .cornerRadius(15)
                            .onTapGesture {
                                pathModel.paths.append(.mypage(other: UserModel(id: chatRoomPartner.partnerId, nickname: chatRoomPartner.nickname, profileURL: chatRoomPartner.partnerImageUrl, style: chatRoomPartner.style, reviews: chatRoomPartner.reviews)))
                            }
                        
                        VStack {
                            PostMapView(lat: $chatLocation[0], lng: $chatLocation[1], isDetail: false)
                            
                            VStack {
                                Text(messageModel.message)
                                    .font(.caption)
                                    .foregroundStyle(.black)
                                    .padding(.vertical, 5)
                                
                                NavigationLink {
                                    ChatExchangeInfoView(myCoord: chatLocationTuple, markerCoord: NMGLatLng(lat: chatLocationTuple.0, lng: chatLocationTuple.1), partnerId: chatRoomPartner.partnerId, uid: uid)
                                } label: {
                                    Text("위치보기")
                                        .padding(.horizontal)
                                        .padding(.vertical, 10)
                                        .font(.subheadline)
                                        .frame(maxWidth: .infinity)
                                        .foregroundStyle(.black)
                                        .background(Color(uiColor: .systemGray5))
                                        .cornerRadius(10)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.bottom)
                            .padding(.horizontal)
                        }
                        .frame(width: 250, height: 230)
                        .cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(hex: "D9D9D9"), lineWidth: 1)
                        )
                        
                        VStack {
                            Spacer()
                            
                            Text(messageModel.timeAgo)
                                .font(.system(size: 10))
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.trailing)
                        }
                        Spacer()
                    }
                } else {
                    HStack(alignment: .top) {
                        Image(uiImage: chatRoomPartner.partnerImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30)
                            .clipped()
                            .cornerRadius(15)
                            .onTapGesture {
                                pathModel.paths.append(.mypage(other: UserModel(id: chatRoomPartner.partnerId, nickname: chatRoomPartner.nickname, profileURL: chatRoomPartner.partnerImageUrl, style: chatRoomPartner.style, reviews: chatRoomPartner.reviews)))
                            }
                        
                        HStack {
                            Text(messageModel.message)
                                .font(.system(size: 18))
                                .foregroundStyle(.white)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(isPressed ? Color(hex:"969696") : Color(hex:"767676"))
                        .cornerRadius(10)
                        // 메세지를 눌렀을경우
                        .self.modifier(PressGesture(shouldShowActionSheet: $shouldShowActionSheet, isPressed: $isPressed))
                        .sheet(isPresented: $shouldShowActionSheet){
                            SelectMessageItemView(shouldShowActionSheet: $shouldShowActionSheet, showToast: $showToast,  message: $messageModel.message)
                                .presentationDetents([.height(170)])
                                .ignoresSafeArea(.all)

                        }
                        
                        VStack {
                            Spacer()
                            
                            Text(messageModel.timeAgo)
                                .font(.system(size: 10))
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.leading)
                        }
                        Spacer()
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .onAppear {
            if messageModel.imageURL != "" {
                viewModel.getChatImage(urlString: messageModel.imageURL)
            }
        }
        .fullScreenCover(isPresented: $isShowChatImageModal) {
            ChatImageModalView(viewModel: viewModel, messageModel: messageModel)
        }
    }
}

