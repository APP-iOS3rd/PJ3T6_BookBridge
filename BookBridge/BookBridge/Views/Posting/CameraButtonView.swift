//
//  CameraButtonView.swift
//  BookBridge
//
//  Created by 노주영 on 2/1/24.
//

import SwiftUI

struct CameraButtonView: View {
    @Binding var showActionSheet: Bool
    
    var body: some View {
        Button(action: {
            self.showActionSheet = true
        }) {
            Image(systemName: "camera.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundColor(.gray)
                .padding(10)
        }
    }
}
