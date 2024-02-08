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
    @Binding var locations: [Location]
    
    var body: some View {
        Button {
            let location = FirestoreManager.makeLocationByCurLocation()
                                    
            selectedLocation = location
                
            userLocationViewModel.setLocation(lat: location.lat ?? 0.0, lng: location.long ?? 0.0, distance: location.distance ?? 1)
            
            locations.append(location)
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
