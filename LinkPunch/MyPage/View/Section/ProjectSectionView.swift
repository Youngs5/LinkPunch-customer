//
//  ProjectSectionView.swift
//  LinkPunch
//
//  Created by 박채영 on 2023/08/22.
//

import SwiftUI

struct ProjectSectionView: View {
    @StateObject var myPageStore: MyPageStore
    
    var body: some View {
        Section {
            if let cv = myPageStore.user.cv {
                VStack {
                    ForEach(cv.projects ?? []) { project in
                        ExperienceBoxView(experience: project)
                        
                        if project.id != cv.projects?.last?.id {
                            Divider()
                        }
                    }
                }
                .background(Color(white: 0.9))
                .padding([.bottom, .leading, .trailing], 10)
            }
        } header: {
            HStack {
                Text("프로젝트")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding([.leading, .trailing], 20)
                Spacer()
            }
        }
    }
}

struct ProjectSectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProjectSectionView(myPageStore: MyPageStore())
        }
    }
}
