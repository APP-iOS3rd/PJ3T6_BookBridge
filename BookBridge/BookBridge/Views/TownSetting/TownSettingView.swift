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
    @StateObject var locationViewModel = LocationViewModel.shared
    @StateObject var userLocationViewModel = UserLocationViewModel.shared
    @State private var sliderValue = 1.0
        
    @State var selectedLocation: Location?
    let locationManager = LocationManager.shared
    let db = Firestore.firestore()
    
    @State var locations = [Location]()
                
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
            
            Spacer()
            
            // 저장버튼(임시)
            Button {
                if let locations = userLocationViewModel.locations {
                    FirestoreManager.saveLocations(locations: locations)
                }
            } label: {
                Text("저장하기")
            }
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("동네설정")
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
                Button {
                    
                } label: {
                    Text("확인")
                        .font(.system(size: 16))
                        .foregroundStyle(.black)
                }
            }
        }
        .onAppear() {
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

#Preview {
    TownSettingView()
}