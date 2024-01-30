//
//  ChangePostingView1.swift
//  BookBridge
//
//  Created by 이현호 on 1/29/24.
//

import SwiftUI

struct ChangePostingView: View {
    @State private var titleText = ""
    @State private var contentText = ""
    @State private var isDestinationActive = false
    @State private var sourceType = 0
    @State private var showActionSheet = false
    @State private var showImagePicker = false
    @State private var selectedImages: [UIImage] = []
    
    
    @State var text: String = ""
    
    @StateObject var post = ChangePostViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    // 이미지 스크롤 뷰
                    ImageScrollView(selectedImages: $selectedImages, showActionSheet: $showActionSheet)
                    
                    // 제목 입력 필드
                    Text("제목")
                        .bold()
                    TextField("제목을 입력해주세요", text: $titleText)
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
                            TextEditor(text: $text)
                                .padding(.leading, 11)
                                .padding(.trailing, 11)
                                .padding(.top, 7)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            if text.isEmpty {
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
                    
                    // 교환 희망 장소 선택 버튼
                    Text("교환 희망 장소")
                        .bold()
                    Button(action: {
                        isDestinationActive = true
                    }) {
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
                    NavigationLink(destination: Text("교환장소(지도) 표시부분"), isActive: $isDestinationActive) {
                        EmptyView()
                    }
                    
                    .padding(.bottom, 30)
                    
                    // 확인 버튼
                    Button(action: {
                        // 확인 버튼이 클릭되었을 때 수행할 동작
                        post.uploadPost(title: titleText, detail: text, images: selectedImages)
                    }) {
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
            .navigationTitle("바꿔요")
            .navigationBarTitleDisplayMode(.inline)
            .confirmationDialog(
                "Title",
                isPresented: $showActionSheet,
                titleVisibility: .visible,
                actions: {
                    Button("카메라") {
                        self.sourceType = 0
                        self.showImagePicker.toggle()
                    }
                    Button("라이브러리") {
                        self.sourceType = 1
                        self.showImagePicker.toggle()
                    }
                },
                message: {
                    Text("Choose where to load the photo.")
                }
            )
        }
        .fullScreenCover(isPresented: $showImagePicker) {
            ImagePicker(isVisible: $showImagePicker, images: $selectedImages, sourceType: sourceType)
        }
    }
}

// 추가된 이미지 스크롤 뷰
struct ImageScrollView: View {
    @Binding var selectedImages: [UIImage]
    @Binding var showActionSheet: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ZStack {
                    Rectangle()
                        .fill(Color(hex: "EAEAEA"))
                        .cornerRadius(10)
                        .frame(width: 100, height: 100)
                    VStack {
                        CameraButton(showActionSheet: $showActionSheet)
                            .disabled(selectedImages.count >= 5)
                        HStack {
                            Text("\(selectedImages.count)")
                                .foregroundStyle(Color(hex:"59AAE0"))
                                .padding(.trailing, -3)
                            Text("/ 5")
                        }
                        .padding(.top, -15)
                    }
                }
                ForEach(selectedImages.indices, id: \.self) { index in
                    ZStack {
                        Image(uiImage: selectedImages[index])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                        
                        DeleteImageButton(selectedImages: $selectedImages, index: index)
                        
                        if index == 0 {
                            VStack {
                                Spacer()
                                ZStack {
                                    Rectangle()
                                        .fill(Color.black)
                                    .frame(height: 25)
                                    Text("대표사진")
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 30)
        }
    }
}

// 카메라 버튼
struct CameraButton: View {
    @Binding var showActionSheet: Bool
    
    var body: some View {
        Button(action: {
            self.showActionSheet = true
        }) {
            Image(systemName: "camera.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundColor(.gray)
                .padding(10)
        }
    }
}

// 이미지 삭제 버튼
struct DeleteImageButton: View {
    @Binding var selectedImages: [UIImage]
    var index: Int
    
    var body: some View {
        Image(systemName: "xmark.circle.fill")
            .foregroundColor(.black)
            .padding(10)
            .offset(x: 50, y: -50)
            .onTapGesture {
                selectedImages.remove(at: index)
            }
    }
}



#Preview {
    ChangePostingView()
}
