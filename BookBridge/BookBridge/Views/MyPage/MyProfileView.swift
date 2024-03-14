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
    
    @State var nickname: String = ""
    @State var userSaveImage: (String, UIImage) = ("", UIImage(named: "Character")!)
    
    @State private var isDuplication: Bool = false
    @State private var isEditing: Bool = false
    @State private var isShowImagePicker: Bool = false
    @State private var saveText: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .bottom) {
                    Image(uiImage: viewModel.selectImage ?? UIImage(named: "Character")!)
                        .resizable()
                        .frame(width: 200, height: 200)
                        .cornerRadius(80)
                        .overlay(RoundedRectangle(cornerRadius: 80)
                            .stroke(Color(hex: "D9D9D9"), lineWidth: viewModel.selectImage == UIImage(named: "Character")! ? 2 : 0)
                        )
                    
                    if isEditing {
                        Image(systemName: "camera.circle.fill")
                            .resizable()
                            .frame(width: 44, height: 44)
                            .foregroundStyle(Color(hex: "ababab"))
                            .background(
                                Circle()
                                    .frame(width: 44, height: 44)
                                    .foregroundStyle(.white)
                            )
                            .offset(x: 85)
                            .onTapGesture {
                                isShowImagePicker.toggle()
                            }
                    }
                }
                .padding(.vertical, 10)
                .padding(.bottom, 10)
                
                MyProfileNicknameView(isDuplication: $isDuplication, isEditing: $isEditing, saveText: $saveText, viewModel: viewModel)
                
                Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(.white)
            .onTapGesture {
                hideKeyboard()
            }
        }
        .onAppear {
            print("userSaveImageProfile: \(userSaveImage)")
            viewModel.userNickname = nickname
            viewModel.selectImage = userSaveImage.1
        }
        .navigationBarBackButtonHidden()
        .navigationTitle(isEditing ? "" : "프로필")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                if isEditing {
                    Button {
                        viewModel.userNickname = nickname
                        viewModel.selectImage = userSaveImage.1
                        isEditing.toggle()
                    } label: {
                        Text("취소")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.black)
                    }
                } else {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 16))
                            .foregroundStyle(.black)
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                MyProfileToolbarItemView(isDuplication: $isDuplication, isEditing: $isEditing, nickname: $nickname, userSaveImage: $userSaveImage, viewModel: viewModel)
            }
        }
        .fullScreenCover(isPresented: $isShowImagePicker){
            ProfileImagePicker(image: $viewModel.selectImage)
        }
    }
}
