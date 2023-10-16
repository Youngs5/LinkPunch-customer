//
//  Store.swift
//  LinkPunch
//
//  Created by 유하은 on 2023/08/22.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class MyPageStore: ObservableObject {
    @Published var user: User = User()
    @Published var updateUser: User = User()
    @Published var image = UIImage()
    
    var userCv = CV(projects: [],activities: [],certifications: [])
    var userEducation = [Education]()
    
    @Published var isNavigateToLoginView = false
    
    var userEmail = UserDefaultsData.shared.getUserEmail()
    lazy var dbRef = Firestore.firestore().collection("users").document(userEmail ?? "test@test.com")
    
    init() {
        fetchData()
        
        user.cv = CV()
        user.education = [
            Education(
                school: "테킷대학교",
                status: "재학",
                major: "컴퓨터공학전공",
                admissionYear: Date().dateToStringForMyPage(),
                graduateYear: Date().dateToStringForMyPage())
        ]
        
        isNavigateToLoginView = false
    }
    
    func addFavRegion(city: String, state: String) {
        let location = "\(city) \(state)"
        
        if updateUser.location == nil {
            updateUser.location = []
        }
        
        guard let locations = updateUser.location else { return }
        
        if !locations.contains(location) {
            updateUser.location?.append(location)
        }
    }
    
    func deleteFavRegion(location: String) {
        updateUser.location?.removeAll(where: { $0 == location })
    }
    
    func uploadImage(completion: @escaping (Bool?) -> Void) {
         guard image.cgImage != nil else {
             completion(nil)
             return
         }
        let storageRef = Storage.storage().reference()
        guard let userEmail = userEmail else {return}
        let imageRef = storageRef.child("userImage").child(userEmail)
        guard let imageData = image.jpegData(compressionQuality: 0.1) else { return }
        _ = imageRef.putData(imageData, metadata: nil) { [weak self] (metadata, error) in
            guard let metadata = metadata else {
                // TODO: 에러 처리
                return
            }
            
            let size = metadata.size
            print(size)
            
            imageRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
                // 에러처리
                completion(nil)
              return
            }
                self?.updateUser.userImage = downloadURL.absoluteString
                completion(true)
                print(downloadURL.absoluteString)
            }
        }
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
                       
                       // 디코딩 된 데이터 사용
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
        guard let userEmail = UserDefaultsData.shared.getUserEmail() else { return }
        
        Task {
            await updateCheckDeviceDuplicate(userEmail: userEmail)
        }
        
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
    
    private func updateCheckDeviceDuplicate(userEmail: String) async {
        
        let dataBase = Firestore.firestore().collection("users")
        do {
            let datas = try await dataBase.document(userEmail).getDocument()
            if let data = datas.data(), !data.isEmpty {
                do {
                    try await dataBase
                        .document(userEmail)
                        .updateData([
                            "isDeviceDuplicateCheck": false
                            ])
                    
                } catch{
                    debugPrint("updateData error")
                }
            }
        } catch {
            debugPrint("getDocument error")
        }
    }

}
