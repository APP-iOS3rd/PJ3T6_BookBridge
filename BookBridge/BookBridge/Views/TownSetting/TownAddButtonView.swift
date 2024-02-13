//
//  TownAddButtonView.swift
//  BookBridge
//
//  Created by 이민호 on 2/8/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct TownAddButtonView: View {
    @StateObject var userLocationViewModel = UserLocationViewModel.shared
    @Binding var selectedLocation: Location?    
    
    var body: some View {
        Button {
            let location = FirestoreManager.makeLocationByCurLocation()
            userLocationViewModel.locations?.append(location)
            userLocationViewModel.selectLocation(location: location)
        } label: {
            TownBtnText(text: "+", color: "59AAE0", backgroundColor: "F4F4F4")
        }
    }
}

extension TownAddButtonView {
    struct TownBtnText: View {
        var text: String
        var color: String
        var backgroundColor: String
        var body: some View {
            Text(text)
                .padding(.vertical, 5)
                .padding(.horizontal,8)
                .font(.system(size: 16, weight: .medium))
                .frame(maxWidth: .infinity)
                .frame(height: 45)
                .foregroundStyle(Color(hex: color))
                .background(Color(hex: backgroundColor))
                .cornerRadius(20)
        }
    }
}
