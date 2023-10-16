//
//  Store.swift
//  LinkPunch
//
//  Created by 유하은 on 2023/08/22.
//

import Foundation
import FirebaseFirestore

class MyPageStore: ObservableObject {
    @Published var user: User = User()
    @Published var updateUser: User = User()
    var userCv = CV(projects: [],activities: [],certifications: [])
    var userEducation = [Education]()
    @Published var isNavigateToLoginView = false
    var userEmail = UserDefaultsData.shared.getUserEmail()
    lazy var dbRef = Firestore.firestore().collection("users").document(userEmail ?? "test@test.com")
    init() {
        fetchData()
//        updateUser = user
//        print("????")
//        print(updateUser)
        user.cv = CV()
        user.education = [Education(school: "테킷대학교", status: "재학", major: "컴퓨터공학전공", admissionYear: Date().dateToStringForMyPage(), graduateYear: Date().dateToStringForMyPage())]
        
        isNavigateToLoginView = false
       
    }
    
    func addFavRegion(city: String, state: String) {
        let location = "\(city) \(state)"
        
        if user.location == nil {
            user.location = []
        }
        
        guard let locations = user.location else { return }
        
        if !locations.contains(location) {
            user.location?.append(location)
        }
    }
    
    func deleteFavRegion(location: String) {
        user.location?.removeAll(where: {$0 == location})
    }
    
    func fetchData(){
       dbRef.getDocument(){[weak self] snapshot,error in
           guard error == nil else {
               debugPrint("파이어베이스 데이터 로드에러 \(String(describing: error?.localizedDescription))")
               return
           }
           if let snapshot = snapshot{
               guard let data = snapshot.data() else {return}
               let docData: [String : Any] = data
               print("마이페이지 데이터 시작")
               print(docData)
                   do {
                       let jsonData = try JSONSerialization.data(withJSONObject: docData, options: [])
                       let decoder = JSONDecoder()
                       let userData = try decoder.decode(User.self, from: jsonData)
                       
                       // 디코딩된 데이터 사용
                       print(userData)
                       DispatchQueue.main.async {
                           self?.user = userData
                           self?.updateUser = userData

                           self?.userCv = userData.cv ?? CV(projects: [],activities: [],certifications: [])
                           self?.userEducation = userData.education ?? []
                       }
                   } catch {
                       print("디코딩 에러: \(error)")
                   }
               }
           }
       }
    
    func updateUserData(){
       dbRef.updateData(updateUser.asDictionary())
       fetchData()
    }
    func addUpdateCVData(){
        updateUser.cv = userCv
        print("데이터 추가")
        print(userCv)
        print(updateUser)
    }
    func addUpdateEducationData(){
        
        updateUser.education = userEducation
        print("데이터 추가")
        print(userCv)
        print(userEducation)
    }
    func removeUserData() {
        UserDefaults.standard.removeObject(forKey: "isAutoLogin")
        UserDefaultsData.shared.removeAll() //유저디폴츠 데이터 삭제~
        isNavigateToLoginView = true
    }
    
    func deleteUser(userEmail: String) {
        let dataBase = Firestore.firestore()
        
        dataBase
            .collection("users")
            .document(userEmail).delete()
    }
}
