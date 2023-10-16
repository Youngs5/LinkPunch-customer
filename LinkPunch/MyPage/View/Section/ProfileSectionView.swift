//
//  ProfileSectionView.swift
//  LinkPunch
//
//  Created by 박채영 on 2023/08/22.
//

import SwiftUI

struct ProfileSectionView: View {
    @StateObject var myPageStore: MyPageStore
    
    var body: some View {
        HStack {
            if let userImage = myPageStore.user.userImage {
                AsyncImage(url: URL(string: userImage)) { image in
                    image
                        .resizable()
                        .clipShape(Circle())
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 140)
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10))
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                    .foregroundColor(.mainColor)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            }
            
            VStack(alignment: .leading) {
                if let nickName = myPageStore.user.userNickName {
                    Text("\(nickName)")
                        .font(.title)
                        .fontWeight(.semibold)
                } else {
                    Text("등록된 닉네임이 없습니다.")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                
                if let name = myPageStore.user.name {
                    Text("\(name)")
                        .foregroundColor(.gray)
                        .padding(.bottom, 5)
                } else {
                    Text("등록된 이름이 없습니다.")
                        .foregroundColor(.gray)
                        .padding(.bottom, 5)
                }
                
                if let userEmail = myPageStore.user.userEmail {
                    Text("\(userEmail)")
                        .tint(.black)
                        .fontWeight(.semibold)
                } else {
                    Text("등록된 이메일이 없습니다.")
                        .fontWeight(.semibold)
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

struct ProfileSectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProfileSectionView(myPageStore: MyPageStore())
        }
    }
}
