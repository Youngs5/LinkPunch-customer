//
//  UserFavRegionSectionView.swift
//  LinkPunch
//
//  Created by 주진형 on 2023/08/23.
//

import SwiftUI
import SwiftUIFlowLayout

struct UserFavRegionSectionView: View {
    var user: User
    
    var body: some View {
        Section {
            VStack {
                if let location = user.location {
//                    ForEach(location, id: \.self) { location in
//                        BadgeView(text: location, fillColor: .subColor, textColor: .white)
//                    }
                    FlowLayout(mode: .scrollable, items: location, itemSpacing: 5) { data in
                        Text("\(data)")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 4)
                            .background(Color.subColor)
                            .foregroundColor(Color.white)
                            .cornerRadius(30)
                    }
//                    .padding(.vertical, 20)
                    
//                    Spacer()
                }
            }
            .padding([.bottom, .leading, .trailing], 20)
        } header: {
            HStack {
                Text("근무 선호 지역")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding([.leading, .trailing], 20)
                Spacer()
            }
        }
    }
}

struct UserFavRegionSectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UserFavRegionSectionView(user: User(userNickName: "둘리아빠친구", name: "홍길동", signUpDate: "2023-08-23", userEmail: "a@naver.com", userPwd: "aaa", userImage: "person", social: Social.none, education: [Education(school: "한국대학교", status: "자연과학대학", major: "정보보호암호융합데이터통계AI응용수학과학전공", admissionYear: Date().dateToStringForMyPage(), graduateYear: Date().dateToStringForMyPage())], location: ["서울"], fields: ["iOS", "Android"], report: nil, cv: nil))
        }
    }
}
