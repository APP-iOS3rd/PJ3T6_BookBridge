//
//  NaverMapView.swift
//  BookBridge
//
//  Created by 이민호 on 2/2/24.
//

import SwiftUI
import UIKit
import NMapsMap

enum TownSetting {
    case add
    case setting
}

struct TownSettingMapView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        UserLocationViewModel.shared.getNaverMapView()
    }
        
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        
    }
    
}

#Preview {
    TownSettingMapView()
}
