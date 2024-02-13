//
//  GeohashTestView.swift
//  BookBridge
//
//  Created by 이민호 on 2/13/24.
//

import SwiftUI

struct GeohashTestView: View {
    @State var temps: [Temp] = []
    var body: some View {
        VStack {
            List(temps, id: \.self) { temp in
                Text(temp.name)
            }
        }
        .onAppear() {
            do {
                Task {
                    await GeohashManager.geoQuery(lat: 37.2855, long: 127.0632, distance: 1) { res in
                        temps = res
                    }
                }
            }
        }
        
    }
        
}

#Preview {
    GeohashTestView()
}
