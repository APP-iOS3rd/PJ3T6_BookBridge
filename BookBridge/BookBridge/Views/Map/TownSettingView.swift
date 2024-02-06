//
//  TownSettingView.swift
//  ModalPractice
//
//  Created by 노주영 on 2/5/24.
//

import SwiftUI

struct TownSettingView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var locationViewModel = LocationViewModel.shared
    @State private var sliderValue = 1.0
    
    var body: some View {
        VStack {
            // 지도
            TownSettingMapView()
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity)
                .frame(height: 450)
                .padding(.vertical, 10)
                .padding(.bottom, 10)
            
            //동네 설정한 갯수에 따라 달라져야됨
            HStack(spacing: 20) {
                Button {
                    
                } label: {
                    Text("관악 3동")
                        .padding(.vertical, 5)
                        .padding(.horizontal,8)
                        .font(.system(size: 16, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .foregroundStyle(.white)
                        .background(Color(hex: "59AAE0"))
                        .cornerRadius(20)
                }
                
                Button {
                    
                } label: {
                    Text("+")
                        .padding(.vertical, 5)
                        .padding(.horizontal,8)
                        .font(.system(size: 16, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .foregroundStyle(Color(hex: "59AAE0"))
                        .background(Color(hex: "F4F4F4"))
                        .cornerRadius(20)
                }
            }
            .padding(.bottom, 20)
            .padding(.horizontal)
            
            VStack {
                HStack(alignment: .bottom, spacing: 10) {
                    Text("거리설정")
                        .font(.system(size: 20, weight: .semibold))
                    
                    Text("\(Int(locationViewModel.circleRadius)/10 % 10 + 1)km")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color(hex: "767676"))
                    
                    Spacer()
                }
                
                Slider(value: $locationViewModel.circleRadius, in: 100...120, step: 10.0) { }
                 minimumValueLabel: {
                    Text("1km")
                } maximumValueLabel: {
                    Text("3km")
                }
                .accentColor(Color(hex: "59AAE0"))
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            
            Spacer()
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
    }
}

#Preview {
    TownSettingView()
}
