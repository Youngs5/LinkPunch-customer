//
//  UserProfileCellView.swift
//  LinkPunch
//
//  Created by 박성훈 on 2023/08/22.
//

import SwiftUI

struct UserProfileCellView: View {
    @State var user: User
  var body: some View {
      HStack{
          if let userImage = user.userImage {
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

          Text(user.userNickName ?? "")
      }
  }
    
}

struct UserProfileCellView_Previews: PreviewProvider {
    static var previews: some View {
      UserProfileCellView(user: User(userNickName: "기가희진", name: "희진", signUpDate: "2020/08/23", userEmail: "test1@test.com", userPwd: "test123", userImage: "admin_Logo", social: .kakao))
    }
}
