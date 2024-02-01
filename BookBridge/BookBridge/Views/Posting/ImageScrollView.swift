//
//  ImageScrollView.swift
//  BookBridge
//
//  Created by 노주영 on 2/1/24.
//

import SwiftUI

// 추가된 이미지 스크롤 뷰
struct ImageScrollView: View {
    @Binding var selectedImages: [UIImage]
    @Binding var showActionSheet: Bool
    
    @State var index: Int = 0
    @State var photoEditShowModal = false
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ZStack {
                    Rectangle()
                        .fill(Color(hex: "EAEAEA"))
                        .cornerRadius(10)
                        .frame(width: 100, height: 100)
                    VStack {
                        CameraButtonView(showActionSheet: $showActionSheet)
                            .disabled(selectedImages.count >= 5)
                        HStack {
                            Text("\(selectedImages.count)")
                                .foregroundStyle(Color(hex:"59AAE0"))
                                .padding(.trailing, -3)
                            Text("/ 5")
                        }
                        .padding(.top, -15)
                    }
                    .frame(width: 80, height: 80) // 카메라 버튼 범위
                }
                ForEach(selectedImages.indices, id: \.self) { index in
                    ZStack {
                        ZStack {
                            Image(uiImage: selectedImages[index])
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .onTapGesture {
                                    self.index = index
                                    photoEditShowModal = true
                                }
                                    
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
                        .cornerRadius(10)
                    }
                    .overlay {
                        ZStack {
                            DeleteImageButtonView(selectedImages: $selectedImages, index: index)
                        }
                        .frame(width: 140, height: 140, alignment: .topTrailing) // Delete버튼 위치
                    }
                    
                    .fullScreenCover(isPresented: $photoEditShowModal) {
                        ImageEditorModalView(index: $index, selectedImages: $selectedImages, showImageEditorModal: $photoEditShowModal)
                    }
                }
            }
            .padding(.vertical, 20)
        }
    }
}
