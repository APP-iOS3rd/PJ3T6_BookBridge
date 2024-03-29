//
//  ImageEditorModalView.swift
//  BookBridge
//
//  Created by 노주영 on 2/1/24.
//

import SwiftUI

// 사진 편집 모달 뷰
struct ImageEditorModalView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var index: Int
    @Binding var selectedImages: [UIImage]
    @Binding var showImageEditorModal: Bool
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "xmark")
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                
                Spacer()
                
                Text("1/1")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    // 완료 버튼 클릭 시 편집된 이미지 저장 후 모달 종료
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("완료")
                        .font(.headline)
                }
            }
        }
        .padding()
        
        // 모달창에 보여질 이미지
        Image(uiImage: selectedImages[index])
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .clipped()
    }
}

