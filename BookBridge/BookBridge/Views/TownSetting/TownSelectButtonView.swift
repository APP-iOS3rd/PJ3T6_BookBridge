//
//  TownSelectButtonView.swift
//  BookBridge
//
//  Created by 이민호 on 2/8/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct TownSelectButtonView: View {
    @StateObject var userLocationViewModel = UserLocationViewModel.shared
    @Binding var selectedLocation: Location?
    @Binding var locations: [Location]
    @State private var showAlert = false
    var location: Location
    
    var body: some View {
        Button {
            userLocationViewModel.selectLocation(location: location)
        } label: {
            HStack {
                Text(location.dong ?? "")
                    .padding(.leading, 10)
                Spacer()
                
                // 동네 삭제버튼
                Button {
                    if userLocationViewModel.locations?.count == 1 {
                        showAlert.toggle()
                        return
                    }
                    
                    userLocationViewModel.deleteLocation(location: location)
                    
                } label: {
                    Image(systemName: "multiply")
                }
                .padding(.trailing, 10)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("동네를 삭제할 수 없습니다."),
                        message: Text("동네는 적어도 한 개 이상 설정되어야 합니다."),
                        dismissButton: .default(Text("확인")) {
                            showAlert.toggle()
                        }
                    )
                }
            }
            .modifier(TownButtonStyle(isSelected: userLocationViewModel.selectedLocation?.id == location.id))
        }
    }
}

extension TownSelectButtonView {
    struct TownButtonStyle: ViewModifier {
        var isSelected: Bool
        
        func body(content: Content) -> some View {
            content
                .padding(.vertical, 5)
                .padding(.horizontal, 8)
                .font(.system(size: 16, weight: .medium))
                .frame(maxWidth: .infinity)
                .frame(height: 45)
                .foregroundStyle(isSelected ? Color(hex: "FFFFFF") : Color(hex: "59AAE0"))
                .background(isSelected ? Color(hex: "59AAE0") : Color(hex: "F4F4F4"))
                .cornerRadius(20)
        }
    }
}

