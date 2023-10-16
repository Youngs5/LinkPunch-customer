//
//  UserFavFieldsSectionView.swift
//  LinkPunch
//
//  Created by 주진형 on 2023/08/23.
//

import SwiftUI
import SwiftUIFlowLayout

struct UserFavFieldsSectionView: View {
    var user: User
    
    var body: some View {
        Section {
            HStack {
                if let fields = user.fields {
//                    ForEach(fields, id: \.self) { field in
//                        BadgeView(text: field, fillColor: .subColor, textColor: .white)
//                    }
                    FlowLayout(mode: .scrollable, items: fields, itemSpacing: 5) { data in
                        Text("\(data)")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 4)
                            .background(Color.subColor)
                            .foregroundColor(Color.white)
                            .cornerRadius(30)
                    }
                    
                    Spacer()
                }
            }
            //.padding(.horizontal, 20)
            .padding([.bottom, .leading, .trailing], 20)
        } header: {
            HStack {
                Text("관심 분야")
                    .fontWeight(.bold)
                    .font(.title)
                    .padding([.leading, .trailing], 20)
                Spacer()
            }
        }
    }
}

struct UserFavFieldsSectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UserFavFieldsSectionView(user: User(userNickName: "둘리아빠친구", name: "홍길동", signUpDate: "2023-08-23", userEmail: "a@naver.com", userPwd: "aaa", userImage: "person", social: Social.none, education: [Education(school: "한국대학교", status: "자연과학대학", major: "정보보호암호융합데이터통계AI응용수학과학전공", admissionYear: Date().dateToStringForMyPage(), graduateYear: Date().dateToStringForMyPage())], location: ["서울"], fields: ["iOS", "Android"], report: nil, cv: nil))
        }
    }
}
