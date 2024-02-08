//
//  ChangePostView.swift
//  BookBridge
//
//  Created by jonghyun baik on 2/7/24.
//

import SwiftUI

struct PostView: View {
    
    @State var noticeBoard: NoticeBoard
    @State var url: [URL] = []
    @Environment(\.dismiss) private var dismiss
    
    var storageManager = HomeFirebaseManager.shared
        
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack {
                        if noticeBoard.isChange {
                            TabView {
                                ForEach(url, id: \.self) { element in
                                    AsyncImage(url: element) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.5625)
                                            .foregroundStyle(.black)
                                    } placeholder: {
                                        Rectangle()
                                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.5625)
                                            .foregroundStyle(Color(red: 217/255, green: 217/255, blue: 217/255))
                                    }
                                }
                            }
                            .tabViewStyle(.page)
                            .frame(height: UIScreen.main.bounds.width * 0.5625)
                            .background(
                                Rectangle()
                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.5625)
                                    .foregroundStyle(Color(red: 217/255, green: 217/255, blue: 217/255))
                            )
                            .padding(.bottom)
                        }
                        
                        HStack {
                            Image(systemName: "scribble")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .background(
                                    Circle()
                                        .frame(width: 60, height: 60)
                                        .foregroundStyle(Color(red: 217/255, green: 217/255, blue: 217/255))
                                )
                            VStack(alignment: .leading) {
                                Text("중고도서킬러")
                                    .padding(1)
                                    .font(.system(size: 12))
                                    .background(
                                        RoundedRectangle(cornerRadius: 5)
                                            .foregroundStyle(Color(red: 217/255, green: 217/255, blue: 217/255)))
                                Text("박하악")
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                                    .padding(.vertical, 1)
                                    .padding(.horizontal, 3)
                                Text("광교 2동")
                                    .font(.system(size: 10))
                                    .foregroundStyle(Color(red: 153/255, green: 153/255, blue: 153/255))
                            }
                            Spacer()
                            Text("매너점수")
                                .font(.system(size: 12))
                            Text("90점")
                                .padding(.vertical, 1)
                                .padding(.horizontal, 3)
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                                .background(
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundStyle(Color(red: 255/255, green: 222/255, blue: 201/255)))
                        }
                        .padding(.horizontal)
                        
                        Divider()
                            .padding(.horizontal)
                        
                        //post 내용
                        VStack(alignment: .leading) {
                            Text(noticeBoard.noticeBoardTitle)
                                .font(.system(size: 25))
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .padding(.top)
                            Text("1시간전")
                                .font(.system(size: 10))
                                .padding(.horizontal)
                            Text(noticeBoard.noticeBoardDetail)
                                .font(.system(size: 15))
                                .padding()
                        }
                        .frame(
                            minWidth: UIScreen.main.bounds.width,
                            minHeight: 200,
                            alignment: Alignment.topLeading
                        )
                        
                        Divider()
                            .padding(.horizontal)
                        
                        //교환 희망 장소
                        VStack(alignment: .leading) {
                            Text("교환 희망 장소")
                                .font(.system(size: 25))
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .padding(.top)
                            //맵뷰
                            
                            Text("어이동 어디")
                                .font(.system(size: 15))
                                .padding()
                        }
                        .frame(
                            minWidth: UIScreen.main.bounds.width,
                            minHeight: 200,
                            alignment: Alignment.topLeading
                        )
                        
                        Divider()
                            .padding(.horizontal)
                        
                        //상대방 책장
                        VStack(alignment: .leading) {
                            Text("님의 책장")
                                .font(.system(size: 25))
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .padding(.top)
                            //책장 리스트뷰
                            
                        }
                        .frame(
                            minWidth: UIScreen.main.bounds.width,
                            minHeight: 200,
                            alignment: Alignment.topLeading
                        )
                        .padding(.bottom, 58)
                    }
                    
                }
                VStack {
                    Spacer()
                    Button {
                        
                    } label: {
                        Text("채팅하기")
                            .foregroundStyle(Color.white)
                            .frame(width: UIScreen.main.bounds.width, height: 57, alignment: Alignment.center)
                            .background(Color(hex: "59AAE0"))
                            .padding(1)
                        //패딩이 없으면 아래를 다 채워버림
                    }
                }
                .frame(alignment: Alignment.bottom)
                }
            }
        .onAppear {
            if !noticeBoard.noticeImageLink.isEmpty && noticeBoard.isChange {
                Task {
                    for image in noticeBoard.noticeImageLink {
                        try await storageManager.downloadImage(noticeiId: noticeBoard.id, imageId: image) { url in
                            self.url.append(url)
                        }
                        
                    }
                }
            }
        }
        .navigationTitle(noticeBoard.isChange ? "바꿔요" : "구해요")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16))
                        .foregroundStyle(.black)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}
