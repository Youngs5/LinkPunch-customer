//
//  UserDetailView.swift
//  LinkPunch
//
//  Created by 주진형 on 2023/08/23.
//

import SwiftUI

struct UserDetailView: View {
    var selectUser: User
    var userName: String
    
    var body: some View {
        ScrollView {
            VStack {
                UserProfileSectionView(user: selectUser)
                HStack {
                    if let shortIntroduce = selectUser.cv?.shortIntroduce {
                        Text("\(shortIntroduce)")
                            .fontWeight(.semibold)
                    } else {
                        Text("등록된 한 줄 소개가 없습니다.")
                            .fontWeight(.semibold)
                    }
                    Spacer()
                }
                .padding(.leading, 15)
                Divider()
                
                UserFavFieldsSectionView(user: selectUser)
               
                UserFavRegionSectionView(user: selectUser)
                
                Divider()
                
                UserProjectSectionView(user: selectUser)
                
                UserActivitySectionView(user: selectUser)
                
                UserCertificationSectionView(user: selectUser)
                UserEducationSectionView(user: selectUser)
            }
        }
        .navigationTitle("\(userName)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(selectUser: User(userNickName: "둘리아빠친구", name: "홍길동", signUpDate: "2023-08-23", userEmail: "a@naver.com", userPwd: "aaa", userImage: "person", social: Social.none, education: [Education(school: "한국대학교", status: "자연과학대학", major: "정보보호암호융합데이터통계AI응용수학과학전공", admissionYear: Date().dateToStringForMyPage(), graduateYear: Date().dateToStringForMyPage())], location: ["서울"], fields: ["iOS", "Android"], report: nil, cv: CV(shortIntroduce: "안녕하세요", projects: nil, activities: nil , certifications: nil)), userName: "홍길동")
    }
}
