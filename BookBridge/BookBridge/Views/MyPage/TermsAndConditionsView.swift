//
//  TermsAndConditionsView.swift
//  BookBridge
//
//  Created by 이현호 on 3/18/24.
//

import SwiftUI

struct TermsAndConditionsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink {
                TermsOfServiceView()
            } label: {
                HStack {
                    Text("서비스 이용약관")
                        .padding(.vertical, 10)
                        .font(.system(size: 17))
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 17))
                        .foregroundStyle(Color(hex: "3C3C43"))
                }
            }
            .padding(.top, 10)
            Divider()
            
            NavigationLink {
                PrivacypolicyView()
            } label: {
                HStack {
                    Text("개인정보 처리방침")
                        .padding(.vertical, 10)
                        .font(.system(size: 17))
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 17))
                        .foregroundStyle(Color(hex: "3C3C43"))
                }
            }
            Divider()
            
            NavigationLink {
                LocationPolicyView()
            } label: {
                HStack {
                    Text("위치기반서비스 이용약관")
                        .padding(.vertical, 10)
                        .font(.system(size: 17))
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 17))
                        .foregroundStyle(Color(hex: "3C3C43"))
                }
            }
            Divider()
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("약관 및 정책")
        .navigationBarTitleDisplayMode(.inline)
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
