//
//  ImageScrollView.swift
//  BookBridge
//
//  Created by 노주영 on 2/1/24.
//

import SwiftUI
import UniformTypeIdentifiers

// 추가된 이미지 스크롤 뷰
struct ImageScrollView: View {
    @Binding var selectedImages: [UIImage]
    @Binding var showActionSheet: Bool
    
    @State var draggedItem : UIImage?
    @State private var showingAlert = false
    @State var index: Int = 0
    @State var photoEditShowModal = false
    @State var items: [String] = []
    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ZStack {
                    Rectangle()
                        .fill(Color(hex: "EAEAEA"))
                        .cornerRadius(10)
                        .frame(width: 100, height: 100)
                    VStack {
                        if selectedImages.count >= 5 {
                            Button(action: {
                                self.showingAlert = true
                            }) {
                                Image(systemName: "camera.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.gray)
                                    .padding(10)
                            }
                            .alert(isPresented: $showingAlert) {
                                Alert(title: Text("알림"), message: Text("이미지는 최대 5장까지 첨부할 수 있습니다."),
                                      dismissButton: .default(Text("확인")))
                            }
                        } else {
                            CameraButtonView(showActionSheet: $showActionSheet)
                        }
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
                ForEach(selectedImages.indices, id: \.self) { imageIndex in
                    let img = selectedImages[imageIndex]
                    ZStack {
                        ZStack {
                            ZStack {
                                Image(uiImage: img)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .onTapGesture {
                                        self.index = imageIndex
                                        photoEditShowModal = true
                                    }
                                    .onDrag({
                                        self.draggedItem = img
                                        return NSItemProvider(item: nil, typeIdentifier: String(imageIndex))
                                    })
                                    .onDrop(of: [UTType.image], delegate: ImageDropDelegate(draggedItem: $draggedItem, items: $selectedImages, item: img))
                                
                                if imageIndex == 0 {
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
                                DeleteImageButtonView(items: $items, selectedImages: $selectedImages, index: imageIndex)
                            }
                            .frame(width: 140, height: 140, alignment: .topTrailing) // Delete버튼 위치
                        }
                    }
                    .fullScreenCover(isPresented: $photoEditShowModal) {
                        ImageEditorModalView(index: $index, selectedImages: $selectedImages, showImageEditorModal: $photoEditShowModal)
                    }
                }
                .onChange(of: selectedImages) { newValue in
                    items.removeAll()
                    for i in selectedImages.indices {
                        items.append(String(i))
                    }
                }
            }
            .padding(.vertical, 20)
        }
    }
}
