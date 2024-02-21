//
//  MyProfileView.swift
//  ModalPractice
//
//  Created by 노주영 on 2/2/24.
//

import SwiftUI

struct MyProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel = MyProfileViewModel()
    
    @State private var isShowImagePicker: Bool = false
    
    var nickname: String
    var userSaveImage: (String, UIImage)
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                Image(uiImage: viewModel.selectImage ?? UIImage(named: "Character")!)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .cornerRadius(80)
                    .overlay(RoundedRectangle(cornerRadius: 80)
                        .stroke(Color(hex: "D9D9D9"), lineWidth: viewModel.selectImage == UIImage(named: "Character")! ? 2 : 0)
                            )
                
                Image(systemName: "camera.circle.fill")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .foregroundStyle(Color(hex: "ababab"))
                    .background(
                        Circle()
                            .frame(width: 44, height: 44)
                            .foregroundStyle(.white)
                    )
                    .offset(x: 88, y: 3)
                    .onTapGesture {
                        isShowImagePicker.toggle()
                    }
            }
            .padding(.vertical, 10)
            .padding(.bottom, 10)
            
            VStack(alignment: .leading) {
                Text("닉네임")
                    .font(.system(size: 25, weight: .semibold))
                    .padding(.bottom, 15)
                
                HStack(alignment: .bottom) {
                    TextField("닉네임이 없어요...", text: $viewModel.userNickname)
                        .font(.system(size: 20, weight: .medium))
                        .frame(maxWidth: .infinity)
                    
                    if viewModel.userNickname != nickname {
                        Button {
                            viewModel.userNickname = nickname
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(.black)
                        }
                    }
                }
                .frame(height: 30)
                
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 2)
                    .foregroundStyle(Color(hex: "D1D3D9"))
                
                HStack {
                    Spacer()
                    
                    Text("\(viewModel.userNickname.count)/10")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Color(hex: "767676"))
                }
            }
            .padding(.bottom, 30)
            
            if viewModel.selectImage != userSaveImage.1 || viewModel.userNickname != nickname {
                Button {
                    //저장로직
                } label: {
                    Text("변경사항 저장")
                        .padding(.vertical, 5)
                        .padding(.horizontal,8)
                        .font(.system(size: 20, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundStyle(.white)
                        .background(Color(hex: "59AAE0"))
                        .cornerRadius(10)
                }
            }
            
            Spacer()
        }
        .onAppear {
            viewModel.userNickname = nickname
            viewModel.selectImage = userSaveImage.1
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("프로필")
        .padding(.horizontal)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 16))
                        .foregroundStyle(.black)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                if viewModel.selectImage != userSaveImage.1 {
                    Button {
                        viewModel.selectImage = userSaveImage.1
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 16))
                            .foregroundStyle(.black)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $isShowImagePicker) {
            
        } content: {
            ProfileImagePicker(image: $viewModel.selectImage)
        }

    }
}

