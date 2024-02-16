//
//  HomeView.swift
//  BookBridge
//
//  Created by 노주영 on 2/6/24.
//

import SwiftUI
import FirebaseStorage

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @StateObject var userManager = UserManager.shared
    @StateObject var locationManager = LocationManager.shared    
    @State private var selectedPicker: TapCategory = .find
    @State private var showingLoginView = false
    @State private var showingTownSettingView = false
        
    @Namespace private var animation
        
    var body: some View {
        VStack {
            HStack {
                Button {
                    if userManager.isLogin {
                        // 로그인시
                        showingTownSettingView.toggle()
                    } else {
                        // 비로그인시
                        showingLoginView.toggle()
                    }
                } label: {
                    HStack{
                        Text(userManager.isLogin ? userManager.currentDong : locationManager.dong)
                        Image(systemName: "chevron.down")
                    }
                    .padding(.leading, 20)
                    .foregroundStyle(.black)
                    
                }
                Spacer()
                
                // 임시로 만든 로그아웃 버튼입니다.
                Button {
                    userManager.logout()
                } label: {
                    Text("로그아웃")
                }
                .padding(.trailing, 20)
            }
            
            tapAnimation()
            
            HomeTapView(viewModel: viewModel, tapCategory: selectedPicker)
        }
        .onAppear {
            viewModel.gettingFindNoticeBoards()
            viewModel.gettingChangeNoticeBoards()
        }
        .sheet(isPresented: $showingLoginView) {
            LoginView(showingLoginView: $showingLoginView)
        }
        .navigationDestination(isPresented: $showingTownSettingView) {
              TownSettingView()
          }
    }
    
    @ViewBuilder
    private func tapAnimation() -> some View {
        HStack {
            ForEach(TapCategory.allCases, id: \.self) { item in
                VStack {
                    Text(item.rawValue)
                        .font(.title3)
                        .frame(maxWidth: .infinity/3, minHeight: 50)
                        .foregroundColor(selectedPicker == item ? .black : .gray)
                    
                    if selectedPicker == item {
                        Capsule()
                            .foregroundColor(.black)
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "info", in: animation)
                            .padding(.bottom, 0)
                    }
                    
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        self.selectedPicker = item
                    }
                }
            }
        }
        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom).foregroundColor(Color(red: 200/255, green: 200/255, blue: 200/255)), alignment: .bottom)
    }
}
