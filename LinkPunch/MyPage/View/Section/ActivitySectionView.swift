//
//  ActivitySectionView.swift
//  LinkPunch
//
//  Created by 박채영 on 2023/08/22.
//

import SwiftUI

struct ActivitySectionView: View {
    @StateObject var myPageStore: MyPageStore
    
    var body: some View {
        Section {
            if let cv = myPageStore.user.cv {
                VStack {
                    ForEach(cv.activities ?? []) { activity in
                        ExperienceBoxView(experience: activity)
                        
                        if activity.id != cv.activities?.last?.id {
                            Divider()
                        }
                    }
                }
                .background(Color(white: 0.9))
                .padding([.bottom, .leading, .trailing], 10)
            }
        } header: {
            HStack {
                Text("활동 및 경력")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding([.leading, .trailing], 20)
                Spacer()
            }
        }
    }
}

struct ActivitySectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ActivitySectionView(myPageStore: MyPageStore())
        }
    }
}
