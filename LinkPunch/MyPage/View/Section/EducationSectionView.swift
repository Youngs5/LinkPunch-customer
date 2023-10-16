//
//  EducationSectionView.swift
//  LinkPunch
//
//  Created by 박채영 on 2023/08/28.
//

import SwiftUI

struct EducationSectionView: View {
    @StateObject var myPageStore: MyPageStore
    
    var body: some View {
        Section {
            if let educations = myPageStore.user.education {
                VStack {
                    ForEach(educations) { education in
                        EducationBoxView(education: education)
                        
                        if education.id != educations.last?.id {
                            Divider()
                        }
                    }
                }
                .background(Color(white: 0.9))
                .padding([.bottom, .leading, .trailing], 10)
            }
        } header: {
            HStack {
                Text("학력")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding([.leading, .trailing], 20)
                Spacer()
            }
        }
    }
}

struct EducationSectionView_Previews: PreviewProvider {
    static var previews: some View {
        EducationSectionView(myPageStore: MyPageStore())
    }
}
