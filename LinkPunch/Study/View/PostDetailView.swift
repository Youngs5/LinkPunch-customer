//
//  PostDetailView.swift
//  LinkPunch
//
//  Created by 유하은 on 2023/08/22.
//

import SwiftUI
import MapKit
import CoreLocation

struct PostDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var studyStore: StudyStore
    @ObservedObject var homeStore: HomeStore
    
    @State var postData: StudyRecruitment
    @State private var isLoading = true
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780), span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009))
    
    @State var isJoinStudy: Bool = false              // 스터디 참여 여부
    @State var isShowingStudyAlert: Bool = false      // 스터디 참여 알럿
    @State var isShowingLeavingAlert: Bool = false    // 스터디 탈퇴 알럿
    @State var personnelLimits: Bool = false // 인원제한 알럿
    @State var isShowingDeleteAlert: Bool = false     // 게시글 삭제 알럿
    @State var isShowReportView: Bool = false         // 신고하기 sheet
    private let shareUrl = URL(string: "https://www.naver.com")!  // url 공유
    @State var publisherData: User?
    
    var body: some View {
        VStack(alignment: .leading){
            
            if !isLoading {
                ProgressView("Loading...")
            } else {
                List {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("\(postData.title)")
                                .font(.title2)
                                .bold()
                                .frame(width: 300, height: 50, alignment: .leading)
                            Spacer()
                            
                            if postData.publisher.userEmail == UserDefaultsData.shared.getUserEmail() {
                                Menu {
                                    ShareLink(item: shareUrl) {
                                        Label("공유하기", systemImage: "square.and.arrow.up")
                                    }
                                    
                                    // 수정하기 & 삭제하기는 작성자만 보이도록
                                    NavigationLink {
                                        PostEditView(studyStore: studyStore, homeStore: homeStore, postData: $postData)
                                    } label: {
                                        Label("수정하기", systemImage: "square.and.pencil")
                                    }
                                    
                                    
                                    Button(role: .destructive) {
                                        // 삭제
                                        isShowingDeleteAlert.toggle()
                                    } label : {
                                        Label("삭제하기", systemImage: "trash")
                                    }
                                    
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .padding(20)  // 버튼 터치 영역을 넓히기 위함
                                }
                                .foregroundColor(Color.secondary)
                            } else {   // 게시자가 아닐 때
                                Menu {
                                    ShareLink(item: shareUrl) {
                                        Label("공유하기", systemImage: "square.and.arrow.up")
                                    }
                                    
                                    // 신고하기는 글 작성자가 아닐경우 보여주기
                                    Button(role: .destructive) {
                                        isShowReportView.toggle()
                                    } label: {
                                        Label("신고하기", systemImage: "exclamationmark.triangle")
                                    }
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .padding(20)  // 버튼 터치 영역을 넓히기 위함
                                }
                                .foregroundColor(Color.secondary)
                                
                            }
                        } // HStack
                        Divider()
                        if let publisherData {
                            NavigationLink(destination: {
                                UserDetailView(selectUser: publisherData, userName: publisherData.name ?? "닉네임 설정이 되지 않았습니다.")
                            }, label: {
                                PublisherCellView(publisher: publisherData)    // 게시자 프로필 셀
                                    .padding(.vertical, 7)
                            })
                        }
                        HStack {
                            Text("작성시간: \(postData.createdDate)")
                                .padding(.trailing)
                            Text("신청자수: \(postData.participants.count) / \(postData.applicantCount)")
                        } // HStack
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 12)
                        
                    } // VStack
                    
                    VStack(alignment: .leading) {
                            VStack(alignment: .leading){
                                HStack {
                                    Text("분야:")
                                        .bold()
                                    Text("\(postData.field.rawValue)")
                                }
                                .padding(.top, 12)
                                .padding(.bottom, 1)
                                
                                HStack {
                                    Text("인원:")
                                        .bold()
                                    Text("\(postData.participants.count)/\(postData.applicantCount)명")
                                }
                                .padding(.bottom, 1)
                                
                                HStack() {
                                    Text("마감일자:")
                                        .bold()
                                    Text(postData.endDate)
                                }
                                .padding(.bottom, 1)
                                
                                
                                HStack() {
                                    Text("지역:")
                                        .bold()
                                    Text("\(postData.location.address)")
                                }
                            }
                            .font(.system(size:14))
                            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems:
                                    [Location(coordinate: CLLocationCoordinate2D(latitude: postData.location.latitude, longitude: postData.location.longitude))]) { location in
                                MapAnnotation(coordinate: location.coordinate) {
                                    MapMarkerDetail()
                                }
                            }
                                    .frame(height: 150)
                                    .padding(.bottom)
                        Divider()
                            .padding(.bottom,12)
                        Text("\(postData.contents)")
                            .padding(.bottom, 12)
                            .font(.system(size:15))
                    }
                    
                    Section {
                        VStack(alignment: .center) {
                            Divider()
                                .opacity(0)
                            
                            // 스터디 모집글 게시자가 아닐 때
                            if postData.publisher.userEmail != UserDefaultsData.shared.getUserEmail() {
                                
                                // 모집인원보다 많거나 같을 때
                                if postData.participants.count >= postData.applicantCount {
                                    Text("이미 모집이 마감된 스터디입니다.")
                                        .font(.title3)
                                        .foregroundColor(Color.red)
                                        .padding(12)
                                } else if !isJoinStudy {  // 모집인원보다 적고, 스터디에 참여하지 않았을 때
                                    Button {
                                        // 스터디 참여 알럿 띄우기
                                        isShowingStudyAlert.toggle()
                                        
                                    } label: {
                                        Text("참여하기")
                                            .frame(width: 80, height: 30)
                                    }
                                    .padding(.top, 10)
                                    .buttonStyle(.borderedProminent)
                                }
                                
                                if isJoinStudy {  // 스터디에 참여했을 때
                                    Button {
                                        // 스터디 탈퇴 알럿 띄우기
                                        isShowingLeavingAlert.toggle()
                                        
                                    } label: {
                                        Text("참여취소")
                                            .frame(width: 80, height: 30)
                                    }
                                    .padding(.top, 10)
                                    .buttonStyle(.borderedProminent)
                                    
                                    // 해당 스터디의 참여자가 아닐 때
                                }
                            }
                        }
                        .listRowSeparator(.hidden)
                        
                        Text("참여자 목록")
                            .font(.title3)
                            .bold()
                        
                        ForEach(postData.participants) { participant in
                            NavigationLink {
                                UserDetailView(selectUser: participant, userName: participant.name ?? "닉네임 설정이 되지 않았습니다.")
                            } label: {
                                UserCellView(participant: participant)
                                
                            }
                        }
                    }
                    
                }
                .listStyle(.plain)
            }
        }
        // 게시글 삭제 알럿
        .alert(isPresented: $isShowingDeleteAlert) {
            Alert(title: Text("게시글 삭제"),
                  message: Text("해당 게시글을 삭제합니다."),
                  primaryButton: .destructive(Text("삭제")) {
                studyStore.removePost(postData)
                dismiss()
            },
                  secondaryButton: .cancel(Text("취소")))
        }
        
        .alert("스터디 참가", isPresented: $isShowingStudyAlert) {
            Button("참가", role: .destructive) {
                isJoinStudy.toggle()
                
                isLoading = false
                if let myEmail = UserDefaultsData.shared.getUserEmail() {
                    studyStore.joinStudyUser(postData, myEmail, homeStore) { success in
                        if success {
                            studyStore.updateStudyPost(postId: postData.id) { suc in
                                if suc {
                                    if let studyData =  studyStore.studyData {
                                        postData = studyData
                                        isLoading = true
                                        print("클로저")
                                    }
                                }
                            }
                            
                        }
                    }
                }
                
            }
            Button("취소", role: .cancel) { }
        } message: {
            Text("해당 스터디에 참가합니다")
        }
        
        .alert("스터디 탈퇴", isPresented: $isShowingLeavingAlert) {
            Button("탈퇴", role: .destructive) {
                isJoinStudy.toggle()
                
                isLoading = false
                if let myEmail = UserDefaultsData.shared.getUserEmail() {
                    studyStore.cancelStudyUser(postData, myEmail, homeStore) { success in
                        if success {
                            studyStore.updateStudyPost(postId: postData.id) { suc in
                                if suc {
                                    if let studyData =  studyStore.studyData {
                                        postData = studyData
                                        isLoading = true
                                        print("클로저")
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
            Button("취소", role: .cancel) { print("\(isShowingStudyAlert)") }
        } message: {
            Text("해당 스터디를 탈퇴합니다.")
        }
        
        .sheet(isPresented: $isShowReportView, onDismiss: {
            if !isShowReportView {
                studyStore.updateStudyPost(postId: postData.id) { success in
                    if success {
                        guard let successData = studyStore.studyData else { return }
                        postData = successData
                        isLoading = true
                    }
                }
            }
        }) {
            ReportView(isShowReportView: $isShowReportView, postData: $postData)
                .presentationDetents([.large])
        }
        //        .navigationTitle("스터디 모집")
        .toolbarBackground(Color.mainColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarBackButtonHidden()  // 네비게이션바와 색이 같아서 없앰
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    // 네비게이션 루트로 돌아가도록 만들기
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Back")
                    }
                    .font(.title3)
                }
                .tint(.white)
            }
        }
        .onAppear {
            studyStore.updateStudyPost(postId: postData.id) { success in
                if success {
                    guard let successData = studyStore.studyData else { return }
                    postData = successData
                    isLoading = true
                    
                    region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: postData.location.latitude, longitude: postData.location.longitude), span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009))
                }
            }
            
            // 화면이 나타날 때 스터디 참여 유무에 따라 isJoinStudy에 Bool값 리턴
            for participant in postData.participants {
                if let userEmail = participant.userEmail {
                    isJoinStudy = userEmail.contains(UserDefaultsData.shared.getUserEmail() ?? "")
                }
            }
            
            makePublisher()
        }
    }
    
    // 받아와서 썼습니다 확인해주세용 뽀뽀쪽
    // 게시자 정보
    func makePublisher() {
        
        if let publisher = postData.publisher.userEmail {
            studyStore.fetchUser(publisher, homeStore: homeStore) { success  in
                if success {
                    publisherData = studyStore.userData
                }
            }
        }
    }
    
}


struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PostDetailView(studyStore: StudyStore(), homeStore: HomeStore(), postData: StudyRecruitment(endDate: "23232", field: .Game, location: StudyLocation(latitude: 37.5665, longitude: 126.9780, address: "서울시청"), userName: "haeun", userImgString: "admin_Logo", title: "", contents: "방가워요잉", applicantCount: 3, nowApplicant: 3, publisher: User(userNickName: "기가희진", name: "희진", signUpDate: "2020/08/23", userEmail: "test1@test.com", userPwd: "test123", userImage: "admin_Logo", social: .google), participants: [User(userNickName: "기가희진", name: "희진", signUpDate: "2020/08/23", userEmail: "test1@test.com", userPwd: "test123", userImage: "admin_Logo", social: .google)]))
        }
    }
}
