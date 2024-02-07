//
//  MyProfileView.swift
//  ModalPractice
//
//  Created by 노주영 on 2/2/24.
//

import SwiftUI

struct MyProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                Image("bearGlass")
                    .resizable()
                    .frame(width: 140, height: 140)
                    .cornerRadius(53)
                
                Image(systemName: "pencil.circle.fill")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .offset(x: 8, y: 8)
            }
            .padding(.vertical, 10)
            .padding(.bottom, 10)
            
            VStack(alignment: .leading) {
                Text("닉네임")
                    .font(.system(size: 20, weight: .semibold))
                    .padding(.bottom, 10)
                
                Text("WaterG")
                    .font(.system(size: 15, weight: .medium))
                
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 2)
                    .foregroundStyle(Color(hex: "D1D3D9"))
            }
            
            Spacer()
            
            
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("프로필")
        .padding(.horizontal)
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
        }
    }
}

#Preview {
    MyProfileView()
}
