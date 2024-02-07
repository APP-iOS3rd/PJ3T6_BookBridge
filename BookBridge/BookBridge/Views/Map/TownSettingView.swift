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
    let locationManager = LocationManager.shared
    @State private var sliderValue = 1.0
    @State var locations = [Location]()
    @State var type: TownSetting = .setting
    @State var selectedLocation: Location?
    @State private var showAlert = false
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
                                guard let index = locations.firstIndex(where: {$0.id == location.id}) else {
                                    print("선택한 Location을 찾을 수 없습니다.")
                                    return
                                }
                                
                                // locations의 해당 location 삭제
                                locations.remove(at: index)
                                
                                // 삭제된 locations Firestore에 저장
                                let locationData = locations.map { $0.dictionaryRepresentation }
                                
                                let docRef = db.collection("User").document(UserManager.shared.uid)
                                
                                docRef.updateData([
                                    "location": locationData
                                ]) { err in
                                    if let err = err {
                                        print(err)
                                        print("Location 삭제가 실패하였습니다.")
                                    } else {
                                        print("Location 삭제가 성공하였습니다.")
                                    }
                                }
                                
                                
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
                        let location = Location(id: UUID().uuidString, lat: locationManager.lat, long: locationManager.long, city: locationManager.city, distriction: locationManager.distriction, dong: locationManager.dong, distance: 1)
                        
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
                // index 찾기
                guard let index = locations.firstIndex(where: {$0.id == selectedLocation?.id}) else {
                    print("선택한 Location을 찾을 수 없습니다.")
                    return
                }
                
                // 변경된 distance값 가져오기
                let targetDistance = userLocationViewModel.changeKilometerToDistance(value: Int(userLocationViewModel.circleRadius))
                
                // 값변경 저장하기
                if index < locations.count && (locations[index].distance != targetDistance) {
                    locations[index].distance = targetDistance
                    let locationData = locations.map { $0.dictionaryRepresentation }
                    
                    let docRef = db.collection("User").document(UserManager.shared.uid)
                    
                    docRef.updateData([
                        "location": locationData
                    ]) { err in
                        if let err = err {
                            print(err)
                            print("Location 업데이트에 실패하였습니다.")
                        } else {
                            print("Location 업데이트가 성공하였습니다.")
                        }
                    }
                }
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
            let docRef = db.collection("User").document(UserManager.shared.uid)

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let locationData = document.data()?["location"] as? [[String: Any]] {
                        let locations = locationsFromArray(locationData)
                        self.locations = locations
                        print("Location 변환 성공!")
                    } else {
                        print("Location field does not exist or is not in the expected format")
                    }
                } else {
                    print("User document does not exist")
                }
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
    
    func locationsFromArray(_ dataArray: [[String: Any]]) -> [Location] {
        var locations: [Location] = []
        for data in dataArray {
            if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) {
                do {
                    let decoder = JSONDecoder()
                    let location = try decoder.decode(Location.self, from: jsonData)
                    locations.append(location)
                } catch {
                    print("Error decoding location data: \(error.localizedDescription)")
                }
            }
        }
        return locations
    }
}

#Preview {
    TownSettingView()
}
