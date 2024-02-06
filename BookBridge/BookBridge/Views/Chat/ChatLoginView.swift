//
//  LoginView.swift
//  BookBridge
//
//  Created by 이현호 on 2/6/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct ChatLoginView: View {
    
    let didCompleteLoginProcess: () -> ()
    
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    
    @State var showImagePicker = false
    @State var image: UIImage?
    @State var loginStatusMessage = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Picker(selection: $isLoginMode, label: Text("Picker here")) {
                        Text("로그인")
                            .tag(true)
                        Text("회원가입")
                            .tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if !isLoginMode {
                        Button {
                            showImagePicker
                                .toggle()
                        } label: {
                            VStack {
                                if let image = self.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 128, height: 128)
                                        .scaledToFill()
                                        .cornerRadius(64)
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 64))
                                        .padding()
                                        .foregroundStyle(Color(.label))
                                }
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 64)
                                    .stroke(Color.black, lineWidth: 3)
                            )
                        }
                    }
                    Group {
                        TextField("이메일", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.none)
                        SecureField("패스워드", text: $password)
                    }
                    .padding(12)
                    .background(.white)
                    
                    
                    Button {
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "로그인" : "회원가입")
                                .foregroundStyle(.white)
                                .padding(.vertical, 10)
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        }
                        .background(Color.blue)
                    }
                    
                    Text(self.loginStatusMessage)
                        .foregroundStyle(.red)
                }
                .padding()
            }
            .navigationTitle(isLoginMode ? "로그인" : "회원가입")
            .background(Color(.init(white: 0, alpha: 0.05))
                .ignoresSafeArea())
        }
        .fullScreenCover(isPresented: $showImagePicker, onDismiss: nil) {
            ProfileImagePicker(image: $image)
        }
    }
    
    private func handleAction() {
        if isLoginMode {
//            print("Should log into Firebase with existing credentials")
            loginUser()
        } else {
            createNewAccount()
//            print("Register a new account inside of Firebase Auth and then store image in Storage somehow...")
        }
    }
    
    // 로그인 성공 여부
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to login user:", err)
                self.loginStatusMessage = "Failed to login user: \(err)"
                return
            }
            
            print("Successfully logged in as user: \(result?.user.uid ?? "")")
            
            self.loginStatusMessage = "Successfully logged in as user: \(result?.user.uid ?? "")"
            
            self.didCompleteLoginProcess()
        }
    }
    
    // 계정생성
    private func createNewAccount() {
        // 프로필 이미지 선택 경고
        if self.image == nil {
            self.loginStatusMessage = "You must select an avatar image"
            return
        }
        
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to create user:", err)
                self.loginStatusMessage = "Failed to create user: \(err)"
                return
            }
            
            print("Successfully created user: \(result?.user.uid ?? "")")
            
            self.loginStatusMessage = "Successfully crated user: \(result?.user.uid ?? "")"
            
            self.persistImageToStorage()
        }
    }
    
    // 이미지저장
    private func persistImageToStorage() {
//        let filename = UUID().uuidString
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                self.loginStatusMessage = "Failed to push image to Storage: \(err)"
                return
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    self.loginStatusMessage = "Failed to retrieve downloadURL: \(err)"
                    return
                }
                
                self.loginStatusMessage = "Successfully stored image with url: \(url?.absoluteString ?? "")"
                print(url?.absoluteString)
                
                guard let url = url else { return }
                storeUserInformation(imageProfileUrl: url)
            }
        }
    }
    
    // 유저정보
    private func storeUserInformation(imageProfileUrl: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = ["email": self.email, "uid": uid, "profileImageUrl": imageProfileUrl.absoluteString]
        FirebaseManager.shared.firestore.collection("ChatUsers").document(uid).setData(userData) { err in
            if let err = err {
                print(err)
                self.loginStatusMessage = "\(err)"
                return
            }
            
            print("Success")
            
            self.didCompleteLoginProcess()
        }
    }
}

#Preview {
    ChatLoginView(didCompleteLoginProcess: {
        
    })
}
