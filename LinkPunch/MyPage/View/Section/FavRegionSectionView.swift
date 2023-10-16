//
//  FavRegionSectionView.swift
//  LinkPunch
//
//  Created by 박채영 on 2023/08/22.
//

import SwiftUI
import SwiftUIFlowLayout

struct FavRegionSectionView: View {
    @StateObject var myPageStore: MyPageStore
    
    var body: some View {
        Section {
            HStack {
                if let location = myPageStore.updateUser.location {
                    FlowLayout(mode: .scrollable, items: location, itemSpacing: 5) { data in
                        BadgeView(text: data, fillColor: .subColor, textColor: .white)
                    }
//                    ForEach(location, id: \.self) { location in
//                        BadgeView(text: location, fillColor: .mainColor, textColor: .white)
//                    }
                    Spacer()
                }
            }
            .padding([.bottom, .leading, .trailing], 20)
        } header: {
            HStack {
                Text("근무 선호 지역")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding([.leading, .trailing], 20)
                Spacer()
            }
        }
    }
}

struct FavRegionSectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FavRegionSectionView(myPageStore: MyPageStore())
        }
    }
}
