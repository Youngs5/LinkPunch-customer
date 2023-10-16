//
//  UserEducationSectionView.swift
//  LinkPunch
//
//  Created by 주진형 on 2023/08/29.
//

import SwiftUI

struct UserEducationSectionView: View {
    var user: User
    var body: some View {
        Section {
            if let educations = user.education {
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
                    .font(.title)
                    .fontWeight(.bold)
                    .padding([.leading, .trailing], 20)
                Spacer()
            }
        }
    }
}

struct UserEducationSectionView_Previews: PreviewProvider {
    static var previews: some View {
      UserEducationSectionView(user: User(userNickName: "둘리아빠친구", name: "홍길동", signUpDate: "2023-08-23", userEmail: "a@naver.com", userPwd: "aaa", userImage: "person", social: Social.none, education: [Education(school: "한국대학교", status: "자연과학대학", major: "정보보호암호융합데이터통계AI응용수학과학전공", admissionYear: Date().toString(), graduateYear: Date().toString())], location: ["서울"], fields: ["iOS", "Android"], report: nil, cv: nil))
    }
}
