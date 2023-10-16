//
//  CertificationSectionView.swift
//  LinkPunch
//
//  Created by 박채영 on 2023/08/22.
//

import SwiftUI

struct CertificationSectionView: View {
    @StateObject var myPageStore: MyPageStore
    
    var body: some View {
        Section {
            if let cv = myPageStore.user.cv {
                VStack {
                    ForEach(cv.certifications ?? []) { certification in
                        ExperienceBoxView(experience: certification)
                        
                        if certification.id != cv.certifications?.last?.id {
                            Divider()
                        }
                    }
                }
                .background(Color(white: 0.9))
                .padding([.bottom, .leading, .trailing], 10)
            }
        } header: {
            HStack {
                Text("자격증")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding([.leading, .trailing], 20)
                Spacer()
            }
        }
    }
}

struct CertificationSectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CertificationSectionView(myPageStore: MyPageStore())
        }
    }
}
