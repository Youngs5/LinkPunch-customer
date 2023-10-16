//
//  RecruitmentCells.swift
//  LinkPunch
//
//  Created by 유하은 on 2023/08/22.
//

import SwiftUI

struct RecruitmentCells: View {
    @State var content: StudyRecruitment
    var studyStore: StudyStore
    var body: some View {
        if !studyStore.isHiddened(content: content) {
            VStack(alignment: .listRowSeparatorLeading){
                HStack {
                    VStack(alignment: .leading) {
                        Text(content.title)
                            .fontWeight(.bold)
                            .padding(10)
                    }
                    .frame(height: 25)
                    
                    Spacer()
                    
                    if content.nowApplicant == content.applicantCount {
                        VStack(alignment: .center) {
                            ZStack {
                                
                                Color.systemColor
                                    .frame(width: 60, height: 23)
                                    .cornerRadius(5)
                                
                                Text("모집 마감")
                                    .font(.system(size: 13))
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        }
                        .padding(.trailing, 5)
                    }
                }
                
                VStack(alignment: .listRowSeparatorLeading) {
                    
                    HStack{
                        Text("분야:")
                        Text(content.field.rawValue)
                            .bold()
                        
                        Spacer()
                        
                        Text("신청자 수:")
                        Text("\(content.nowApplicant)/\(content.applicantCount)")
                            .bold()
                    }
                    .padding(.bottom,1)
                    
                }
                .frame(width: 295)
                .font(.footnote)
            }
            .frame(width: 300)
            
        }
        else
        {
            Text("숨김처리 된 글 입니다.")
        }
    }
    
    
}
        struct RecruitmentCells_Previews: PreviewProvider {
        static var previews: some View {
            RecruitmentCells(content: StudyRecruitment( endDate: "23232", field: .Frontend, location: StudyLocation(latitude: 37.5665, longitude: 126.9780, address: "서울시청"), userName: "haeun", userImgString: "admin_Logo", title: "안녕하세ddddddddddddddddddddddd용", contents: "방가워요잉", applicantCount: 3, nowApplicant: 3, publisher: User(userNickName: "기가희진", name: "희진", signUpDate: "2020/08/23", userEmail: "test1@test.com", userPwd: "test123", userImage: "admin_Logo", social: .google), participants: [User(userNickName: "기가희진", name: "희진", signUpDate: "2020/08/23", userEmail: "test2@test.com", userPwd: "test123", userImage: "admin_Logo", social: .google),User(userNickName: "기가희진", name: "희진", signUpDate: "2020/08/23", userEmail: "test1@test.com", userPwd: "test123", userImage: "admin_Logo", social: .google),User(userNickName: "기가희진", name: "희진", signUpDate: "2020/08/23", userEmail: "test1@test.com", userPwd: "test123", userImage: "admin_Logo", social: .google)]), studyStore: StudyStore())
        }
    }
