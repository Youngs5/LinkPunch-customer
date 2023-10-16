//
//  ProfileEditSectionView.swift
//  LinkPunch
//
//  Created by 박채영 on 2023/08/23.
//

import SwiftUI
import Combine

struct ProfileEditSectionView: View {
    @StateObject var myPageStore: MyPageStore
    
    @Binding var editedNickName: String
    @Binding var editedName: String
    @Binding var editedEmail: String
    @Binding var editedShortIntroduce: String
    
    @State private var isOpenPhoto = false
    @State private var showingSheet = false
    
    var imageURLString = ""
    
    var body: some View {
        VStack {
            Button(action: {
                showingSheet = true
            }) {
                if myPageStore.image.cgImage == nil {
                    if let userImage = myPageStore.user.userImage {
                        AsyncImage(url: URL(string: userImage)) { image in
                            image
                                .resizable()
                                .clipShape(Circle())
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 180)
                                .overlay {
                                    ZStack {
                                        Circle()
                                            .trim(from: 0.1, to: 0.4)
                                            .foregroundColor(.black.opacity(0.5))
                                            .frame(width: 180)
                                        Text("편집")
                                            .foregroundColor(.white)
                                            .fontWeight(.semibold)
                                            .offset(y: 50)
                                    }
                                }
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Image(systemName: "person.crop.circle.fill.badge.plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                            .foregroundColor(.mainColor)
                            .padding(EdgeInsets(top: -10, leading: 10, bottom: 20, trailing: 10))
                    }
                } else {
                    Image(uiImage: myPageStore.image)
                        .resizable()
                        .clipShape(Circle())
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 180, height: 180)
                        .overlay {
                            ZStack {
                                Circle()
                                    .trim(from: 0.1, to: 0.4)
                                    .foregroundColor(.black.opacity(0.5))
                                    .frame(width: 180)
                                Text("편집")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                    .offset(y: 50)
                            }
                        }
                }
            }
            .actionSheet(isPresented: $showingSheet) {
                ActionSheet(title: Text("프로필 사진 편집"), buttons: [
                    .default(Text("라이브러리에서 선택")) {
                        isOpenPhoto = true
                    },
                    .default(Text("사진 찍기")) {
                        // TODO: 사진 찍기
                    },
                    .cancel()
                ])
            }
            .onDisappear{
                myPageStore.image = UIImage()
            }
            .sheet(isPresented: $isOpenPhoto, content: {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$myPageStore.image)
            })
            
            .contextMenu(
                ContextMenu(menuItems: {
                    Button {
                        isOpenPhoto = true
                    } label: {
                        Label("라이브러리에서 선택", systemImage: "photo.on.rectangle.angled")
                    }
                    
                    Button {
                        // TODO: 사진 찍기
                    } label: {
                        Label("사진 찍기", systemImage: "camera.fill")
                    }
                })
            )
            
            Section {
                VStack {
                    if let nickName = myPageStore.updateUser.userNickName {
                        TextField("\(nickName)", text: $editedNickName)
                            .textFieldStyle(.roundedBorder)
                    } else {
                        TextField("닉네임을 입력하세요.", text: $editedNickName)
                            .textFieldStyle(.roundedBorder)
                    }
                }
                .frame(width: 360, alignment: .topLeading)
                .fixedSize(horizontal: true, vertical: false)
                .cornerRadius(5)
                .padding([.bottom, .leading, .trailing])
                
            } header: {
                HStack {
                    Text("닉네임")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.leading, 5)
                    Spacer()
                }
            }
            
            Section {
                VStack {
                    if let name = myPageStore.updateUser.name {
                        TextField("\(name)", text: $editedName)
                            .textFieldStyle(.roundedBorder)
                    } else {
                        TextField("이름을 입력하세요.", text: $editedName)
                            .textFieldStyle(.roundedBorder)
                    }
                }
                .frame(width: 360, alignment: .topLeading)
                .fixedSize(horizontal: true, vertical: false)
                .cornerRadius(5)
                .padding([.bottom, .leading, .trailing])
                
            } header: {
                HStack {
                    Text("이름")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.leading, 5)
                    Spacer()
                }
            }
            
            Section {
                VStack {
                    if let userEmail = myPageStore.updateUser.userEmail {
                        TextField("\(userEmail)", text: $editedEmail)
                            .textFieldStyle(.roundedBorder)
                    } else {
                        TextField("이메일을 입력하세요.", text: $editedEmail)
                            .textFieldStyle(.roundedBorder)
                    }
                }
                .frame(width: 360, alignment: .topLeading)
                .fixedSize(horizontal: true, vertical: false)
                .cornerRadius(5)
                .padding([.bottom, .leading, .trailing])
            } header: {
                HStack {
                    Text("이메일")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.leading, 5)
                    Spacer()
                }
            }
            
            Section {
                ZStack(alignment: .trailing) {
                    if let shortIntroduce = myPageStore.updateUser.cv?.shortIntroduce {
                        TextField("\(shortIntroduce)", text: $editedShortIntroduce)
                            .textFieldStyle(.roundedBorder)
                            .onReceive(Just(editedShortIntroduce)) { newValue in
                                if editedShortIntroduce.count > 20 {
                                    editedShortIntroduce = String(editedShortIntroduce.prefix(20))
                                }
                            }
                    } else {
                        TextField("한 줄 소개를 입력하세요.", text: $editedShortIntroduce)
                            .textFieldStyle(.roundedBorder)
                            .onReceive(Just(editedShortIntroduce)) { newValue in
                                if editedShortIntroduce.count > 20 {
                                    editedShortIntroduce = String(editedShortIntroduce.prefix(20))
                                }
                            }
                    }
                    
                    Text("\(editedShortIntroduce.count)/20")
                        .foregroundColor(Color(white: 0.8))
                        .padding(.trailing, 30)
                }
                .frame(width: 360, alignment: .topLeading)
                .fixedSize(horizontal: true, vertical: false)
                .cornerRadius(5)
                .padding([.bottom, .leading, .trailing])
            } header: {
                HStack {
                    Text("한 줄 소개")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.leading, 5)
                    Spacer()
                }
            }
        }
        .padding()
        .onAppear {
            editedNickName = myPageStore.updateUser.userNickName ?? ""
            editedName = myPageStore.updateUser.name ?? ""
            editedEmail = myPageStore.updateUser.userEmail ?? ""
            editedShortIntroduce = myPageStore.updateUser.cv?.shortIntroduce ?? ""
            UITextField.appearance().clearButtonMode = .whileEditing
        }
    }
}

struct ProfileEditSectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProfileEditSectionView(
                myPageStore: MyPageStore(),
                editedNickName: .constant(""),
                editedName: .constant(""),
                editedEmail: .constant(""),
                editedShortIntroduce: .constant("")
            )
        }
    }
}
