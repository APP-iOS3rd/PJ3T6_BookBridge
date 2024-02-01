//
//  FindPostingView.swift
//  BookBridge
//
//  Created by 이현호 on 1/30/24.
//

import SwiftUI

struct FindPostingView: View {
    @StateObject var viewModel = PostingViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    // 제목 입력 필드
                    Text("제목")
                        .bold()
                    TextField("제목을 입력해주세요", text: $viewModel.noticeBoard.noticeBoardTitle)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(.bottom, 30)
                    
                    // 상세 설명 입력 필드
                    VStack(alignment: .leading) {
                        Text("상세설명")
                            .bold()
                        ZStack {
                            TextEditor(text: $viewModel.noticeBoard.noticeBoardDetail)
                                .padding(.leading, 11)
                                .padding(.trailing, 11)
                                .padding(.top, 7)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            if viewModel.noticeBoard.noticeBoardDetail.isEmpty {
                                VStack {
                                    HStack {
                                        Text("상세 내용을 작성해주세요")
                                            .foregroundStyle(.tertiary)
                                        Spacer()
                                    }
                                    .padding()
                                    
                                    Spacer()
                                }
                            }
                        }
                        .frame(height: 200)
                    }
                    .padding(.bottom, 30)
                    
                    // 희망도서 선택 버튼
                    Text("희망도서(선택)")
                        .bold()
                    
                    
                    NavigationLink(destination: SearchBooksView()) {
                        HStack {
                            Text(
                                viewModel.noticeBoard.hopeBook?.isEmpty ?? true ? "희망도서 선택" : "\(viewModel.noticeBoard.hopeBook?[0].volumeInfo.title ?? "")외 \((viewModel.noticeBoard.hopeBook?.count ?? 0) - 1)권"
                            )
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.black)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(hex: "EAEAEA"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    }
                    .padding(.bottom, 30)
                    
                    // 교환 희망 장소 선택 버튼
                    Text("교환 희망 장소")
                        .bold()
                    
                    //EmptyView에 지훈님이 만든 네이버 맵 화면
                    NavigationLink(destination: EmptyView()) {
                        HStack {
                            Text("교환장소 선택")
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.black)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(hex: "EAEAEA"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    }
                    .padding(.bottom, 30)
                   
                    
                    // 확인 버튼
                    Button {
                        viewModel.uploadPost(isChange: false, images: [])
                    } label: {
                        Text("확인")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color(hex:"59AAE0"))
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 30)
                }
            }
            .padding()
            .navigationTitle("구해요")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    FindPostingView()
}
