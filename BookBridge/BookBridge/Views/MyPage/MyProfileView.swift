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
            
            VStack(alignment: .leading) {
                Text("닉네임")
                    .font(.system(size: 25, weight: .semibold))
                    .padding(.bottom, 15)
                
                if isEditing {
                    HStack(alignment: .bottom) {
                        TextField("닉네임이 없어요...", text: $viewModel.userNickname)
                            .font(.system(size: 20, weight: .medium))
                            .frame(maxWidth: .infinity)
                        
                        Button {
                            viewModel.userNickname = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(.black)
                        }
                    }
                    .frame(height: 30)
                    .onChange(of: viewModel.userNickname) { _ in
                        if viewModel.userNickname.count > 15 {
                            viewModel.userNickname = saveText
                        } else {
                            saveText = viewModel.userNickname
                        }
                    }
                } else {
                    HStack {
                        Text(viewModel.userNickname)
                            .font(.system(size: 20, weight: .medium))
                        
                        Spacer()
                    }
                    .frame(height: 30)
                }
                
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 2)
                    .foregroundStyle(Color(hex: "D1D3D9"))
                
                HStack {
                    if isDuplication {
                        Text("중복된 닉네임입니다.")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.red)
                    }
                    
                    Spacer()
                    
                    Text("\(viewModel.userNickname.count)/15")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Color(hex: "767676"))
                }
                .padding(.top, 5)
            }
            .padding(.bottom, 30)
            
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
                if isEditing {
                    if  (viewModel.selectImage != userSaveImage.1 || viewModel.userNickname != nickname) && viewModel.userNickname != "" {
                        Button {
                            viewModel.checkingSameNickname(nickname: nickname, userSaveImage: userSaveImage) { (isDuplication, urlString) in
                                if isDuplication {
                                    self.isDuplication = true
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                        self.isDuplication = false
                                    }
                                } else {
                                    if viewModel.selectImage != userSaveImage.1 && viewModel.userNickname != nickname {
                                        userSaveImage = (urlString, viewModel.selectImage ?? UIImage(named: "Character")!)
                                        nickname = viewModel.userNickname
                                        
                                        viewModel.userManager.user?.profileURL = urlString
                                        viewModel.userManager.user?.nickname = viewModel.userNickname
                                    } else if viewModel.selectImage != userSaveImage.1 {
                                        userSaveImage = (urlString, viewModel.selectImage ?? UIImage(named: "Character")!)
                                        
                                        viewModel.userManager.user?.profileURL = urlString
                                    } else {
                                        nickname = viewModel.userNickname
                                        
                                        viewModel.userManager.user?.nickname = viewModel.userNickname
                                    }
                                    isEditing.toggle()
                                }
                            }
                        } label: {
                            Text("완료")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.black)
                        }
                    }
                } else {
                    Button {
                        isEditing.toggle()
                    } label: {
                        Text("편집")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.black)
                    }
                }
                if !(isEditing && viewModel.selectImage == userSaveImage.1 && (viewModel.userNickname == nickname || viewModel.userNickname != "")){
                }
            }
        }
        .fullScreenCover(isPresented: $isShowImagePicker) {
            
        } content: {
            ProfileImagePicker(image: $viewModel.selectImage)
        }

    }
}

