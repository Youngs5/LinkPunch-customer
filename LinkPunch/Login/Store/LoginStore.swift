//
//  LoginStore.swift
//  LinkPunch
//
//  Created by 김민기 on 2023/08/23.
//

import Foundation
import Foundation
import FirebaseAuth
import FirebaseFirestore

class LoginStore: ObservableObject{
    @Published var successLogin: Bool = false
    
    @MainActor
    func signIn(email:String,password:String) async -> LoginState {
        var isDeviceDuplicateCheck: Bool = false
        
        do {
            // 비동기로 로그인 실행
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            
            let user = authResult.user
            
            // 이메일 없으면 false 리턴
            guard let userEmail = user.email else {
                successLogin = false
                return .fail
            }
            
            let snapshot = try await Firestore.firestore().collection("users").document(userEmail).getDocument()
            
            if let data = snapshot.data() {
                let docData: [String : Any] = data
                let userNickName: String = docData["userNickName"] as? String ?? ""
                
                isDeviceDuplicateCheck = docData["isDeviceDuplicateCheck"] as? Bool ?? false
                UserDefaultsData.shared.setUser(email: userEmail, nickName: userNickName, social: .none)
                if !isDeviceDuplicateCheck {
                    await checkDeviceDuplicate(userEmail: email)
                    debugPrint(email)
                    debugPrint("로그인성공")
                    
                    // 모두 성공하면 true 리턴
                    successLogin = true
                    return .success
                } else  {
                    return .duplication
                }
            }
            //isDeviceDuplicateCheck값이 트루일때 -> 디바이스에 로그인이 된 기기가 있을 경우
            //여기에서 fasle값이 들어오면 이미 다른기기에서 로그인된 경우라서
            successLogin = false
            return .fail
            
        } catch {
            // 만약 try 실패하면 에러 출력하고 false 리턴
            debugPrint(error)
            successLogin = false
            return .fail
        }
    }
    
    func autoLogin(){
        UserDefaults.standard.set(true, forKey: "isAutoLogin")
    }
    
    func checkDeviceDuplicate(userEmail: String) async {
        let dataBase = Firestore.firestore().collection("users")
        do {
            let datas = try await dataBase.document(userEmail).getDocument()
            if let data = datas.data(), !data.isEmpty {
                do {
                    try await dataBase
                        .document(userEmail)
                        .updateData([
                            "isDeviceDuplicateCheck": true
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

