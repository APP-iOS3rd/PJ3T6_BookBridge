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
    @StateObject var viewModel: ChatMessageViewModel

    @State var chatLocation: [Double] = [100, 200]
    @State var chatLocationTuple: (Double, Double) = (0, 0)
    
    var messageModel: ChatMessageModel
    var partnerId: String
    var partnerImage: UIImage
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
                                Text(messageModel.message)
                                    .font(.caption)
                                    .foregroundStyle(.black)
                                    .padding(.vertical, 5)
                                
                                NavigationLink {
                                    ChatExchangeInfoView(myCoord: chatLocationTuple, markerCoord: NMGLatLng(lat: chatLocationTuple.0, lng: chatLocationTuple.1), partnerId: partnerId, uid: uid)
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
                        .background(Color(hex:"59AAE0"))
                        .cornerRadius(10)
                    }
                }
            } else {
                if messageModel.imageURL != "" {
                    HStack(alignment: .top) {
                        Image(uiImage: partnerImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30)
                            .clipped()
                            .cornerRadius(15)
                        
                        Image(uiImage: viewModel.chatImages[messageModel.imageURL] ?? UIImage(named: "DefaultImage")!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .cornerRadius(10)
                        
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
                        Image(uiImage: partnerImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30)
                            .clipped()
                            .cornerRadius(15)
                        
                        VStack {
                            PostMapView(lat: $chatLocation[0], lng: $chatLocation[1], isDetail: false)
                            
                            VStack {
                                Text(messageModel.message)
                                    .font(.caption)
                                    .foregroundStyle(.black)
                                    .padding(.vertical, 5)
                                
                                NavigationLink {
                                    ChatExchangeInfoView(myCoord: chatLocationTuple, markerCoord: NMGLatLng(lat: chatLocationTuple.0, lng: chatLocationTuple.1), partnerId: partnerId, uid: uid)
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
                        Image(uiImage: partnerImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30)
                            .clipped()
                            .cornerRadius(15)
                        
                        HStack {
                            Text(messageModel.message)
                                .font(.system(size: 18))
                                .foregroundStyle(.white)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color(hex:"767676"))
                        .cornerRadius(10)
                        
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
    }
}

