//
//  TownSettingSlideView.swift
//  BookBridge
//
//  Created by 이민호 on 2/8/24.
//

import SwiftUI

struct TownSettingSlideView: View {
    @StateObject var userLocationViewModel = UserLocationViewModel.shared
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom, spacing: 10) {
                Text("거리설정")
                    .font(.system(size: 20, weight: .semibold))
                
                Text("\(Int(userLocationViewModel.circleRadius)/10 % 10 + 1)km")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color(hex: "767676"))
                
                Spacer()
            }
            
            Slider(value: $userLocationViewModel.circleRadius, in: 100...120, step: 10.0) { }
             minimumValueLabel: {
                Text("1km")
            } maximumValueLabel: {
                Text("3km")
            }
            .accentColor(Color(hex: "59AAE0"))
        }
    }
}

#Preview {
    TownSettingSlideView()
}
