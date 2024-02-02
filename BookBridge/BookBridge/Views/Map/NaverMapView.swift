//
//  NaverMapView.swift
//  BookBridge
//
//  Created by 이민호 on 2/2/24.
//

import SwiftUI
import UIKit
import NMapsMap

struct NaverMapView: UIViewRepresentable {
//    func makeCoordinator() -> Coordinator {
//        NaverMapCoordinator.shared
//    }
        
    func makeUIView(context: Context) -> NMFNaverMapView {        
        LocationViewModel.shared.getNaverMapView()
    }
        
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {}
    
}

#Preview {
    NaverMapView()
}
