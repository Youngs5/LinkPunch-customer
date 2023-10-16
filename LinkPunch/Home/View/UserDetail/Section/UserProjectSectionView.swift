//
//  UserProjectSectionView.swift
//  LinkPunch
//
//  Created by 주진형 on 2023/08/23.
//

import SwiftUI

struct UserProjectSectionView: View {
    var user: User
    
    var body: some View {
        Section {
            if let cv = user.cv {
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
                    .font(.title)
                    .fontWeight(.bold)
                    .padding([.leading, .trailing], 20)
                Spacer()
            }
        }
    }
}

struct UserProjectSectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UserProjectSectionView(user: User(userNickName: "둘리아빠친구", name: "홍길동", signUpDate: "2023-08-23", userEmail: "a@naver.com", userPwd: "aaa", userImage: "person", social: Social.none, education: [Education(school: "한국대학교", status: "자연과학대학", major: "정보보호암호융합데이터통계AI응용수학과학전공", admissionYear: Date().dateToStringForMyPage(), graduateYear: Date().dateToStringForMyPage())], location: ["서울"], fields: ["iOS", "Android"], report: nil, cv: nil))
        }
    }
}
