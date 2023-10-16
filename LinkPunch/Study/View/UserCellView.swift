//
//  UserCellView.swift
//  LinkPunch
//
//  Created by 박성훈 on 2023/08/29.
//

import SwiftUI

struct UserCellView: View {
    // 데이터
    // 이미지, 이름
    let participant: User
    
    /*
     /// 유저 프로필 사진
     if let userImage = user.userImage {
         AsyncImage(url:URL(string: userImage)) { image in
             image
                 .resizable()
                 .frame(width: 75, height: 75)
                 .clipShape(Circle())
         } placeholder: {
             Image(systemName: "person.circle.fill")
                 .resizable()
                 .frame(width: 75, height: 75)
                 .foregroundColor(.subColor)
                 .padding(.trailing, 10)
         }
     } else {
         Image(systemName: "person.circle.fill")
             .resizable()
             .frame(width: 75, height: 75)
             .foregroundColor(.subColor)
             .padding(.trailing, 10)
     }
     */
    
    var body: some View {
        HStack{
            if let userImage = participant.userImage {
                AsyncImage(url:URL(string: userImage)) { image in
                    image
                        .resizable()
                        .frame(width: 55, height: 55)
                        .clipShape(Circle())
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 55, height: 55)
                        .foregroundColor(.subColor)
                        .padding(.trailing, 10)
                }
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 55, height: 55)
                    .foregroundColor(.subColor)
                    .padding(.trailing, 10)
            }
            
            Text(participant.userNickName ?? participant.userEmail ?? "")
        }
    }
}

struct UserCellView_Previews: PreviewProvider {
    static var previews: some View {
        UserCellView(participant: User(userNickName: "기가희진", name: "희진", signUpDate: "2020/08/23", userEmail: "test1@test.com", userPwd: "test123", userImage: "admin_Logo", social: .google))
    }
}
