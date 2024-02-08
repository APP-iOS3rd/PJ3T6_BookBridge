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
    @State var locations = [Location]()    
    @State var selectedLocation: Location?
    @State private var showAlert = false
    let locationManager = LocationManager.shared
    let db = Firestore.firestore()
    
    var body: some View {
        VStack {
            // 지도
            TownSettingMapView()
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity)
                .frame(height: 450)
                .padding(.vertical, 10)
                .padding(.bottom, 10)
            
                        
            HStack(spacing: 20) {
                ForEach(locations, id: \.id) { location in
                    Button {
                        selectedLocation = location
                        userLocationViewModel.setLocation(lat: location.lat ?? 0.0, lng: location.long ?? 0.0, distance: location.distance ?? 1)
                    } label: {
                        HStack {
                            Text(location.dong ?? "")
                                .padding(.leading, 10)
                            Spacer()
                            
                            // 동네 삭제버튼
                            Button {
                                if locations.count == 1 {
                                    showAlert.toggle()
                                    return
                                }
                                // index값 가져오기
                                guard let index = FirestoreManager.getIndexWithId(value: locations, id: location.id ?? "") else { return }
                                                                                               
                                // locations의 해당 location 삭제
                                locations.remove(at: index)
                                
                                // 삭제된 locations Firestore에 저장
                                FirestoreManager.deleteLocation(id: UserManager.shared.uid, locations: locations)
                                                                                                
                            } label: {
                                Image(systemName: "multiply")
                            }
                            .padding(.trailing, 10)
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("동네를 삭제할 수 없습니다."),
                                    message: Text("동네는 적어도 한 개 이상 설정되어야 합니다."),
                                    dismissButton: .default(Text("확인")) {
                                        showAlert.toggle() // showAlert 변수 토글
                                    }
                                )
                            }
                        }
                        .modifier(TownButtonStyle())
                    }
                    
                }
                
                if locations.count < 2 {
                    Button {
                        let location = FirestoreManager.makeLocationByCurLocation()
                                                
                        selectedLocation = location
                            
                        userLocationViewModel.setLocation(lat: location.lat ?? 0.0, lng: location.long ?? 0.0, distance: location.distance ?? 1)
                        
                        locations.append(location)
                    } label: {
                        TownBtnText(text: "+", color: "59AAE0", backgroundColor: "F4F4F4")
                    }
                }
            }
            .padding(.bottom, 20)
            .padding(.horizontal)
            
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
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            
            Spacer()
            
            Button {
                FirestoreManager.saveLocationDistance(id: selectedLocation?.id ?? "", locations: locations, circleRadius: Int(userLocationViewModel.circleRadius))
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
            FirestoreManager.getLocations(id: UserManager.shared.uid) { locations in
                self.locations = locations
                selectedLocation = locations[0]
                userLocationViewModel.setLocation(lat: selectedLocation?.lat ?? 0.0, lng: selectedLocation?.long ?? 0.0, distance: selectedLocation?.distance ?? 1)
            }
        }
    }
}

extension TownSettingView {
    struct TownButtonStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .padding(.vertical, 5)
                .padding(.horizontal, 8)
                .font(.system(size: 16, weight: .medium))
                .frame(maxWidth: .infinity)
                .frame(height: 45)
                .foregroundStyle(Color(hex: "FFFFFF"))
                .background(Color(hex: "59AAE0"))
                .cornerRadius(20)
        }
    }
        
    struct TownBtnText: View {
        var text: String
        var color: String
        var backgroundColor: String
        var body: some View {
            Text(text)
                .padding(.vertical, 5)
                .padding(.horizontal,8)
                .font(.system(size: 16, weight: .medium))
                .frame(maxWidth: .infinity)
                .frame(height: 45)
                .foregroundStyle(Color(hex: color))
                .background(Color(hex: backgroundColor))
                .cornerRadius(20)
        }
    }
}

#Preview {
    TownSettingView()
}
