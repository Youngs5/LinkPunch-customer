//
//  PublisherCellView.swift
//  LinkPunch
//
//  Created by 유하은 on 2023/08/28.
//

import SwiftUI

struct PublisherCellView: View {
  // 데이터
  // 이미지, 이름
  let publisher: User
  
  var body: some View {
    HStack{
      AsyncImage(url:URL(string: publisher.userImage ?? "admin_Logo")) { image in
        image
          .resizable()
          .aspectRatio(contentMode: .fit)
          .clipShape(Circle())
          .frame(width: 62)
      } placeholder: {
        Image(systemName: "person.circle.fill")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .clipShape(Circle())
          .frame(width: 40)
          .padding(5)
          .foregroundColor(.subColor)
      }
      Text(publisher.userNickName ?? publisher.userEmail!)
      Image(systemName: "medal.fill")
      
    }
  }
}

struct PublisherCellView_Previews: PreviewProvider {
  static var previews: some View {
    PublisherCellView(publisher: User(userNickName: "기가희진", name: "희진", signUpDate: "2020/08/23", userEmail: "test1@test.com", userPwd: "test123", userImage: "admin_Logo", social: .google))
  }
}
