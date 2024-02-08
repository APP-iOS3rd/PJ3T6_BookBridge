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
    
    @State private var isAnimating = false
    @State private var rotation = 0.0
    @State private var selectedPicker: TapCategory = .find
    
    @Namespace private var animation
    
    var body: some View {
        NavigationView{
            VStack {
                HStack {
                    Button {
                        self.isAnimating.toggle()
                        
                    } label: {
                        HStack{
                            Text("광교 2동")
                            Image(systemName: "chevron.down")
                                .rotationEffect(.degrees(isAnimating ? 180 : 360))
                                .animation(.linear(duration: 0.3), value: isAnimating)
                        }
                        .padding(.leading, 20)
                        .foregroundStyle(.black)
                        
                    }
                    Spacer()
                }
                
                tapAnimation()
                
                HomeTapView(viewModel: viewModel, tapCategory: selectedPicker)
            }
        }
        .onAppear {
            viewModel.gettingFindNoticeBoards()
            viewModel.gettingChangeNoticeBoards()
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
