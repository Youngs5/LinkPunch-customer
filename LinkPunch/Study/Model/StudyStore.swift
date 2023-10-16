//
//  StudyStore.swift
//  LinkPunch
//
//  Created by 유하은 on 2023/08/22.
//


import Foundation
import SwiftUI
import FirebaseFirestore

class StudyStore : ObservableObject {
    @Published var studyRecruitmentStore: [StudyRecruitment] = []
    
    @Published var studyData: StudyRecruitment?
    //fetchUser 호출 시 저장하는 유저데이터
    @Published var userData: User?
    @Published var reportCountInfo: ReportCountInfo?
    
    let dataBase = Firestore.firestore().collection("studies")
    
    init(){
        //    initData()
    }
    
    func isHiddened(content: StudyRecruitment) -> Bool {
        guard let reportInfo = content.reportCountInfo else {
            return false
        }
        
        var isHidden = (reportInfo.unrelatedCount >= 3 ||
                        reportInfo.spamFlaggingCount >= 3 ||
                        reportInfo.obscenityCount >= 3 ||
                        reportInfo.offensiveLanguageCount >= 3 ||
                        reportInfo.etcCount >= 3)
        
        return isHidden
        //isHidden변수도 같이 바꿔줘야 하면 여기에 넣어버리면 됨.
    }
    
    
    
    
    func addStudyPost(_ studyPost : StudyRecruitment) {
        print("스터디 추가")
        //파이어베이스에 저장
        dataBase.document(studyPost.id)
            .setData(studyPost.asDictionary())
        print("스터디 추가 성공")
    }
    
    func joinStudyUser(_ studyPost: StudyRecruitment,_ userEmail: String,_ homeStore: HomeStore, completion: @escaping (Bool) -> Void) {
        print("스터디 참여하기")
        var newStudyPost = studyPost
        fetchUser(userEmail, homeStore: homeStore) { success in
            if success {
                guard let userData = self.userData else { return }
                print(userData)
                newStudyPost.participants.append(userData)
                newStudyPost.nowApplicant += 1
                self.dataBase.document(studyPost.id).updateData(newStudyPost.asDictionary())
                
                print("스터디 참여하기 완료")
                completion(true)
            }
        }
    }
    
    func cancelStudyUser(_ studyPost: StudyRecruitment,_ userEmail: String,_ homeStore: HomeStore, completion: @escaping (Bool) -> Void) {
        print("스터디 취소하기")
        var newStudyPost = studyPost
        if let index = studyPost.participants.firstIndex(where: { user in
            user.userEmail == userEmail
        }) {
            
            newStudyPost.participants.remove(at: index)
            newStudyPost.nowApplicant -= 1
            self.dataBase.document(studyPost.id).updateData(newStudyPost.asDictionary())
            print("스터디 취소 완료")
            completion(true)
        }
    }
    
    
    
    /// Add Post 할 때 게시자의 이메일을 이용해 게시자의 유저 객체를 가져옴
    /// - Parameter userEmail: 게시자 이메일
    func fetchUser(_ userEmail: String, homeStore: HomeStore, completion: @escaping (Bool) -> Void) {
        
        homeStore.fetch { success in
            if success {
                for tempUser in homeStore.userList {
                    print(tempUser.name)
                    if tempUser.userEmail == userEmail {
                        self.userData = tempUser
                        completion(true)
                    }
                }
            }
        }
    }
    
    /// 게시글 수정하기
    /// - Parameter studyPost: 게시글
    func editStudyPost(studyPost: StudyRecruitment) async {
        do {
            try await dataBase.document(studyPost.id).updateData(studyPost.asDictionary())
            /* 하늘님 믿어요
             for tempRecruitment in studyRecruitmentStore {
             if tempRecruitment.id == studyPost.id {
             try await dataBase.document(studyPost.id).updateData(studyPost.asDictionary())
             }
             }
             */
        } catch {
            print("Error editing study post: \(error)")
        }
    }
    
    func removePost(_ studyPost: StudyRecruitment) {
        var index: Int = 0
        
        for tempPost in studyRecruitmentStore {
            
            if tempPost.id == studyPost.id {
                studyRecruitmentStore.remove(at: index)
                print(studyRecruitmentStore)
                
                dataBase.document(studyPost.id).delete()
                break
            }
            index += 1
        }
    }
    
    //파베에서 데이터를 가지고 오는 update
    func updateStudyPost(postId: String, completion: @escaping (Bool) -> Void) {
        let studyDocRef = dataBase.document(postId)
        
        studyDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print(document)
                do {
                    
                    if let data = document.data() {
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                        let decoder = JSONDecoder()
                        let studyPost = try decoder.decode(StudyRecruitment.self, from: jsonData)
                        print("StudyPost struct: \(studyPost)")
                        self.studyData = studyPost
                        completion(true)
                    } else {
                        print("Document data is empty")
                        completion(false)
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(false)
                }
            } else {
                print("Document does not exist")
                completion(false)
            }
        }
    }
    
    func fetchStudyPost() {
        studyRecruitmentStore.removeAll()
        dataBase.getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print("Error fetching data: (error?.localizedDescription ?? ")
                return
            }
            
            for document in snapshot.documents {
                
                if let jsonData = try? JSONSerialization.data(withJSONObject: document.data(), options: []),
                   let post = try? JSONDecoder().decode(StudyRecruitment.self, from: jsonData) {
    
//                    var isHidden =
//                    (post.reportCountInfo?.unrelatedCount ?? 0 >= 3 ||
//                     post.reportCountInfo?.spamFlaggingCount ?? 0 >= 3 ||
//                     post.reportCountInfo?.obscenityCount ?? 0 >= 3 ||
//                     post.reportCountInfo?.offensiveLanguageCount ?? 0 >= 3 ||
//                     post.reportCountInfo?.etcCount ?? 0 >= 3)
//
//                    if isHidden {
//                        post.reportCountInfo?.isHiddened = true
//                        print("-------------여기---------------")
//                        print(post.studyData?.reportCountInfo?.isHiddened)
//                    }
                    self.studyRecruitmentStore.append(post)
                }
                
            }
            self.studyRecruitmentStore.sort { $0.createdAt > $1.createdAt }
            print("파이어베이스 스터디 데이터 가져오기 성공")
            // print(self.studyRecruitmentStore)
         
        }
        //빈배열인데 앱에 나옴
    }
    
    func setLocation(latitude: Double, longitude: Double, address: String) -> StudyLocation {
        let location = StudyLocation(latitude: latitude, longitude: longitude, address: address)
        return location
    }
    
    func initData(){
        //        studyRecruitmentStore = [
        //            StudyRecruitment(field: .frontend, location: StudyLocation(latitude: 37.5665, longitude: 126.9780, address: "서울시청"), userName: "성희", userImgString: "person", title: "매주 모의 면접 스터디 하실분", contents: "저랑 같이 공부해봐용", applicantCount: 8, nowApplicant: 1, reportCount:0),
        //            StudyRecruitment(field: .backend, location: StudyLocation(latitude: 37.5665, longitude: 126.9780, address: "서울시청"),userName: "지훈", userImgString: "person", title: "같이 영화볼 분 구합니다", contents: "제 스펙은 좋습니다", applicantCount: 8, nowApplicant: 1,reportCount:0),
        //            StudyRecruitment(field: .mobile, location: StudyLocation(latitude: 37.5665, longitude: 126.9780, address: "서울시청"),userName: "주주", userImgString: "person", title: "플러터로 앱 만들어보실분 구합니다", contents: "디자이너 구인 완료했고, 이미 경험 있으신 분들 원합니다", applicantCount: 2, nowApplicant: 0,reportCount:0),
        //            StudyRecruitment(field: .ai, location: StudyLocation(latitude: 37.5665, longitude: 126.9780, address: "서울시청"),userName: "희준", userImgString: "person", title: "같이 캐글 대회 나가실 분", contents: "cell segmentation competition에서 silver메달 딴 경험 있습니다. 다른 팀원들도 xx대학교 대학원생들로 구성되어 있습니다", applicantCount: 4, nowApplicant: 1,reportCount:0),
        //            StudyRecruitment(field: .game, location: StudyLocation(latitude: 37.5665, longitude: 126.9780, address: "서울시청"),userName: "지혜", userImgString: "person", title: "저랑 게임하실분", contents: "롤 실버예요 ㅋㅋ", applicantCount: 5, nowApplicant: 1,reportCount:0),
        //            StudyRecruitment(field: .mobile, location: StudyLocation(latitude: 37.5665, longitude: 126.9780, address: "서울시청"),userName: "준혁", userImgString: "person", title: "RX Swift 공부해보실분들 구합니다", contents: "xx까지 공부하고 싶어요", applicantCount: 7, nowApplicant: 5,reportCount:0)
        //
        //        ]
    }
}

let studyTestData: StudyRecruitment = StudyRecruitment(
    endDate: "23242",
    field: .Frontend,
    location: StudyLocation(latitude: 37.5665, longitude: 126.9780, address: "서울시청"),
    userName: "성희",
    userImgString: "person",
    title: "매주 모의 면접 스터디 하실분",
    contents: "저랑 같이 공부해봐용",
    applicantCount: 8,
    nowApplicant: 3,
    publisher: User(userNickName: "기가희진", name: "희진", signUpDate: "2020/08/23", userEmail: "test1@test.com", userPwd: "test123", userImage: "admin_Logo", social: .google),
    participants: [User(userNickName: "기가희진", name: "희진", signUpDate: "2020/08/23", userEmail: "test1@test.com", userPwd: "test123", userImage: "admin_Logo", social: .google)],
    reportCountInfo: nil)
