//
//  UserProfileSectionView.swift
//  LinkPunch
//
//  Created by 주진형 on 2023/08/23.
//

import SwiftUI

struct UserProfileSectionView: View {
    var user: User
    
    var body: some View {
        HStack {
            if let userImage = user.userImage {
                AsyncImage(url:URL(string: userImage)) { image in
                            image
                                .resizable()
                                .clipShape(Circle())
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 160)
                                .padding(.leading, -10)
                        } placeholder: {
                           ProgressView()
                        }
            } else {
                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100)
                                    .foregroundColor(.subColor)
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 15))
            }
            VStack(alignment: .leading) {
                if let nickName = user.name {
                    Text("\(nickName)")
                        .font(.title)
                        .fontWeight(.semibold)
                } else {
                    Text("등록된 이름이 없습니다.")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                
//                if let name = user.name {
//                    Text("\(name)")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                } else {
//                    Text("등록된 이름이 없습니다.")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                }
                
                if let userEmail = user.userEmail {
                    Text("\(userEmail)")
                        .fontWeight(.semibold)
                        .tint(.black)
                } else {
                    Text("등록된 이메일이 없습니다.")
                        .font(.subheadline)
                }
                
//                HStack {
//                    if let shortIntroduce = user.cv?.shortIntroduce {
//                        BadgeView(text: "\(shortIntroduce)", fillColor: Color(white: 0.9), textColor: .black)
//                    } else {
//                        BadgeView(text: "등록된 한 줄 소개가 없습니다.", fillColor: Color(white: 0.9), textColor: .black)
//                    }
//                }
            }
            Spacer()
        }
        .padding()
    }
}

struct UserProfileSectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UserProfileSectionView(user: User(userNickName: "둘리아빠친구", name: "홍길동", signUpDate: "2023-08-23", userEmail: "a@naver.com", userPwd: "aaa", userImage: "person", social: Social.none, education: [Education(school: "한국대학교", status: "자연과학대학", major: "정보보호암호융합데이터통계AI응용수학과학전공", admissionYear: Date().dateToStringForMyPage(), graduateYear: Date().dateToStringForMyPage())], location: ["서울"], fields: ["iOS", "Android"], report: nil, cv: nil))
        }
    }
}
