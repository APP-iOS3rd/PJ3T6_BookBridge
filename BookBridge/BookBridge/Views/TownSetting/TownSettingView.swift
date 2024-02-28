//
//  TownSettingView.swift
//  ModalPractice
//
//  Created by 노주영 on 2/5/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct TownSettingView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var isShowPlusBtn: Bool
    
    @StateObject var locationViewModel = LocationViewModel.shared
    @StateObject var userLocationViewModel = UserLocationViewModel.shared
    
    @State var locations = [Location]()
    @State var selectedLocation: Location?
    
    
    @State private var sliderValue = 1.0
    
    let db = Firestore.firestore()
    let locationManager = LocationManager.shared
                
    var body: some View {
        VStack {
            // 지도
            TownSettingMapView()
                .modifier(TownSettingMapStyle())
            
            // 동네버튼
            HStack(spacing: 20) {
                ForEach(userLocationViewModel.locations ?? [], id: \.id) { location in
                    TownSelectButtonView(
                        selectedLocation: self.$selectedLocation,
                        locations: self.$locations,
                        location: location
                    )                                        
                }
                
                if userLocationViewModel.locations?.count ?? 0 < 2 {
                    TownAddButtonView(
                        selectedLocation: self.$selectedLocation,
                        locations: self.$locations
                    )
                }
            }
            .padding(.bottom, 20)
            .padding(.horizontal)
            
            // 거리 슬라이더
            TownSettingSlideView()
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                        
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("동네설정")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    if let locations = userLocationViewModel.locations {
                        UserManager.shared.chageLocation(locations: locations)
                        FirestoreManager.saveLocations(locations: locations)
                    }
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 16))
                        .foregroundStyle(.black)
                }
            }
        }        
        .onAppear() {
            isShowPlusBtn = false
            FirestoreManager.getLocations { locations in
                userLocationViewModel.setLocations(locations: locations)
            }
        }
    }
}

extension TownSettingView {
    struct TownSettingMapStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity)
                .frame(height: 450)
                .padding(.vertical, 10)
                .padding(.bottom, 10)
        }
    }
}
