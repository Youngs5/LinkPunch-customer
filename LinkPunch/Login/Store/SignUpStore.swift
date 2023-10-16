//
//  SignUpStore.swift
//  LinkPunch
//
//  Created by 최하늘 on 2023/08/23.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

class SignUpStore : ObservableObject{
    @Published var userData: User = User()
    
    func addDefaultInfo(nickName:String,name:String,email:String,password:String) {
        userData.userNickName = nickName
        userData.name = name
        userData.userEmail = email
        userData.userPwd = password
        print(userData)
    }
    
    func addEducationInfo(school: String, degree: String, major: String, admissionDatePicker: String, graduationDatePicker: String) {
        
        let education = Education(school: school, status: degree, major: major, admissionYear: admissionDatePicker, graduateYear: graduationDatePicker)
        
        userData.education = [education]
        print(userData)
    }
    
    func addLocationInfo(location: String, fields: [String]) {
        let location = [location]
        
        userData.location = location
        userData.fields = fields
        print(userData)
        
        //회원가입
        signUp()
    }
    
    
    func signUp() {
        guard isSignUp() else { return }
        //isSignUp 에서 옵셔널 확인한 후이기 때문에 강제처리
        Auth.auth().createUser(withEmail: userData.userEmail!, password: userData.userPwd!) { result, error in
            guard let _ = result?.user.uid else { return }
            print("회원가입 진행")
            self.insertUserData()
            
        }
    }
    
    func insertUserData() {
        userData.social = Social.none
        userData.report = Report(isStopped: false, isDeleted: false, suspensionDate: "", stopCount: 0, reportedCount: ReportCount())
        userData.signUpDate = Date().dateToString()
        
        let dataBase = Firestore.firestore()
        dataBase.collection("users")
            .document(userData.userEmail!)
            .setData(userData.asDictionary())
        print("")
        print("회원가입 성공")
    }
    
    func isSignUp() -> Bool {
        print("회원가입 체크")
        guard let nickName = userData.userNickName, !nickName.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        
        guard let name = userData.name, !name.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        
        guard let userEmail = userData.userEmail, !userEmail.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        
        guard let userPwd = userData.userPwd, !userPwd.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        
        guard let _ = userData.education else { return false }
        
        guard let location = userData.location, !location.isEmpty else { return false }
        
        guard let fields = userData.fields, !fields.isEmpty else { return false }
        
        return true
    }
    func doubleCheckEmail(email:String) async -> Bool {
        do{
            let datas = try await Firestore.firestore().collection("users").document(email).getDocument()
            if let data = datas.data(), !data.isEmpty {
                return false
            }else {
                return true
            }
        }
        catch{
            debugPrint("getDocument error")
            return false
        }
    }
}
