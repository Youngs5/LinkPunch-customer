//
//  MyPageView.swift
//  LinkPunch
//
//  Created by 유하은 on 2023/08/22.
//

import SwiftUI

struct MyPageView: View {
    @StateObject var myPageStore = MyPageStore()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ZStack {
                    Rectangle()
                        .edgesIgnoringSafeArea(.all)
                        .foregroundColor(.mainColor)
                        .frame(height: 60)
                    
                    Text("My Page").foregroundColor(.white)
                        .font(.title)
                        .bold()
                        .offset(y: -10)
                    
                    HStack{
                        NavigationLink {
                            MyPageEditView(myPageStore: myPageStore)
                        } label: {
                            HStack {
                                Spacer()
                                ZStack{
                                    Rectangle()
                                        .frame(width: 80, height: 34)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 10)
                                    Text("편집하기")
                                        .bold()
                                        .font(.system(size:14))
                                }
                                .padding(.trailing, 10)
                                .offset(y: -10)
                            }
                        }
                    }
                }
                
                ScrollView {
                    VStack {
                        Group {
                            ProfileSectionView(myPageStore: myPageStore)
                            
                            HStack {
                                if let shortIntroduce = myPageStore.user.cv?.shortIntroduce {
                                    VStack(alignment: .leading) {
                                        Text("한 줄 소개")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                        Text("\(shortIntroduce)")
                                    }
                                } else {
                                    Text("등록된 한 줄 소개가 없습니다.")
                                }
                                
                                Spacer()
                            }
                            .padding(EdgeInsets(top: 20, leading: 23, bottom: 0, trailing: 0))
                            
                            Spacer(minLength: 40)
                        }
                        
                        Group {
                            FavFieldSectionView(myPageStore: myPageStore)
                            
                            FavRegionSectionView(myPageStore: myPageStore)
                        }
                        
                        Group {
                            
                            ProjectSectionView(myPageStore: myPageStore)
                            
                            Spacer(minLength: 30)
                            
                            ActivitySectionView(myPageStore: myPageStore)
                            
                            Spacer(minLength: 30)
                            
                            CertificationSectionView(myPageStore: myPageStore)
                            
                            Spacer(minLength: 30)
                            
                            EducationSectionView(myPageStore: myPageStore)
                        }
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            myPageStore.updateUser = myPageStore.user
        }
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
