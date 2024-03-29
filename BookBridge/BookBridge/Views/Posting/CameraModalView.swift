//
//  CameraModalView.swift
//  BookBridge
//
//  Created by 이현호 on 2/2/24.
//

import SwiftUI

struct CameraModalView: View {
    @Binding var selectedImages: [UIImage]
    @Binding var showActionSheet: Bool
    @Binding var sourceType: Int
    @Binding var showImagePicker: Bool
    
    var body: some View {
        VStack {
            Rectangle()
                .frame(width: 150, height: 5)
                .foregroundStyle(Color(uiColor: .systemGray5))
                .cornerRadius(5)
                .padding(.top, 10)
            Spacer()
            
            HStack(spacing: 50) {
                VStack(spacing: 10) {
                    Button {
                        self.sourceType = 1
                        self.showImagePicker = true
                    } label: {
                        ZStack {
                            Circle()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color(hex: "D9D9D9"))
                            
                            Image(systemName: "photo.on.rectangle")
                                .resizable()
                                .frame(width: 30, height: 20)
                                .foregroundStyle(Color(.darkGray))
                        }
                    }
                    
                    Text("사진")
                        .font(.system(size: 15, weight: .semibold))
                }
                
                VStack(spacing: 10) {
                    Button {
                        self.sourceType = 0
                        self.showImagePicker = true
                    } label: {
                        ZStack {
                            Circle()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color.brown)
                                .opacity(0.6)
                            
                            Image(systemName: "camera.fill")
                                .resizable()
                                .frame(width: 30, height: 20)
                                .foregroundStyle(Color(.darkGray))
                        }
                    }
                    Text("카메라")
                        .font(.system(size: 15, weight: .semibold))
                }
            }
            Spacer()
        }
        .fullScreenCover(isPresented: $showImagePicker, onDismiss: {
            showActionSheet.toggle()
        }, content: {
            ImagePicker(isVisible: $showImagePicker, images: $selectedImages, sourceType: $sourceType)
                .ignoresSafeArea(.all)
        })
    }
}
