//
//  ExchangeHopeView.swift
//  BookBridge
//
//  Created by 김지훈 on 2024/02/06.
//

import SwiftUI
import NMapsMap
import CoreLocation

struct ChatExchangeInfoView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var myCoord: (Double, Double) = (0, 0)
    @State var markerCoord: NMGLatLng?
    @State var location: String = ""
    
    var partnerId: String
    var uid: String
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .foregroundStyle(.black)
                        }
                        
                        Spacer()
                    }
                    
                    Text("위치보기")
                }
                .padding(.horizontal)
                
                ChatUIExchangeHopeView(myCoord: $myCoord, markerCoord: $markerCoord, location: $location)
                    .frame(maxHeight: geometry.size.height)
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
