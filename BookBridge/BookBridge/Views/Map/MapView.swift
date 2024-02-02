//
//  MapView.swift
//  BookBridge
//
//  Created by 이민호 on 2/2/24.
//

import SwiftUI
import NMapsMap

struct MapView: View {
    
    @StateObject var naverMapCoordinator: LocationViewModel = LocationViewModel.shared
    
    var body: some View {
        VStack {
            NaverMapView()
                .ignoresSafeArea(.all, edges: .top)
        }
//        .onAppear() {
//            naverMapCoordinator.checkIfLocationServiceIsEnabled()
//        }
        
    }
}

#Preview {
    MapView()
}
