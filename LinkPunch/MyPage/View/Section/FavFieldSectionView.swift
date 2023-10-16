//
//  FavFieldSectionView.swift
//  LinkPunch
//
//  Created by 박채영 on 2023/08/22.
//

import SwiftUI
import SwiftUIFlowLayout

struct FavFieldSectionView: View {
    @StateObject var myPageStore: MyPageStore
    
    var body: some View {
        Section {
            HStack {
                if let fields = myPageStore.user.fields {
                    FlowLayout(mode: .scrollable, items: fields, itemSpacing: 5) { data in
                        BadgeView(text: data, fillColor: .subColor, textColor: .white)
                    }
                    
                    Spacer()
                }
            }
            .padding([.bottom, .leading, .trailing], 20)
        } header: {
            HStack {
                Text("관심 분야")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding([.leading, .trailing], 20)
                Spacer()
            }
        }
    }
}

struct FavFieldSectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FavFieldSectionView(myPageStore: MyPageStore())
        }
    }
}
