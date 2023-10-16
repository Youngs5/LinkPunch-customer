//
//  HomeView.swift
//  LinkPunch
//
//  Created by on 2023/08/22.
//

import SwiftUI
import SwiftUIFlowLayout

struct HomeView: View {
    
    @StateObject var myPageStore = MyPageStore()
    @ObservedObject var homeStore: HomeStore
    @State private var isHomeViewLoading = false
    
    var body: some View {
        
        NavigationStack {
            if !isHomeViewLoading {
                ProgressView("Loading...")
            } else {
                VStack {
                    /// 상단 내비게이션 바
                    ZStack {
                        Rectangle()
                            .edgesIgnoringSafeArea(.all)
                            .foregroundColor(.mainColor)
                            .frame(height: 60)
                        Text("Home")
                            .foregroundColor(.white)
                            .font(.title)
                            .bold()
                            .offset(y: -10)
                    }
                    
                    ScrollView {
                        LazyVStack {
                            ForEach(homeStore.userList.filter({ user in
                                let userSelf = myPageStore.user
                                if let fields = user.fields, let fieldsSelf = userSelf.fields {
                                    return user.id != userSelf.id && commonFieldCheck(fields, fieldsSelf)
                                } else {
                                    return user.id != myPageStore.user.id
                                }
                            })) { user in
                                HomeElementView(user: user)
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .refreshable {
            homeStore.fetch { success in
                if success {
                    isHomeViewLoading = true
                }
            }
        }
        .task {
            homeStore.fetch { success in
                if success {
                    isHomeViewLoading = true
                }
            }
        }
    }
    
    func commonFieldCheck(_ a: [String], _ b: [String]) -> Bool {
        let setA = Set(a)
        let setB = Set(b)
        
        let commonElements = setA.intersection(setB)
        
        return !commonElements.isEmpty
    }
}

struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeView(homeStore: HomeStore())
    }
}

struct HomeElementView: View {
    
    var user: User
    @State var isShowingReportView: Bool = false
    @State var text: String = ""
    
    var body: some View {
        if let nickName = user.userNickName, let name = user.name, let education = user.education, let location = user.location, let fields = user.fields {
            HStack(alignment: .top, spacing: 20) {
                NavigationLink {
                    UserDetailView(selectUser: user, userName: name)
                } label: {
                    HStack(alignment: .top, spacing: 10) {
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
                        
                        VStack(alignment: .leading, spacing: 0) {
                            /// 유저 닉네임 + 이름
                            HStack(spacing: 5) {
                                Text("\(nickName)")
                                    .font(.headline)
                                    .bold()
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                
                                Text("\(name)")
                                    .font(.callout)
                                    .bold()
                                    .foregroundColor(.gray)
                            }
                            .padding([.horizontal, .bottom], 5)
                            
                            /// 학력
                            ForEach(education) { education in
                                Text("\(education.school) \(education.status) \(education.major)")
                                    .font(.subheadline)
                                    .multilineTextAlignment(.leading)
                                    .padding([.horizontal, .bottom], 5)
                            }
                            
                            /// 관심 분야
                            Section {
                                FlowLayout(mode: .scrollable, items: fields, itemSpacing: 5) { data in
                                    Text("\(data)")
                                        .font(.footnote)
                                        .padding(8)
                                        .background(Color.subColor)
                                        .cornerRadius(8)
                                }
                            } header: {
                                Text("관심 분야")
                                    .font(.caption)
                                    .padding([.leading, .bottom], 5)
                                    .padding(.top, 10)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.top, 5)
                    .frame(maxHeight: .infinity)
                }
                
                /// 신고 메뉴
                Menu {
                    Button (role: .destructive) {
                        isShowingReportView.toggle()
                    } label: {
                        Text("신고")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(.gray)
                }
            }
            .tint(.black)
            .padding()
            .sheet(isPresented: $isShowingReportView) {
                UserReportingView(userPostData: User(), isShowingReportView: $isShowingReportView, user: user)
                    .presentationDetents([.large])
            }
            
            Divider()
        }
    }
}
