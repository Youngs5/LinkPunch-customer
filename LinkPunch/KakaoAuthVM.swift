//
//  KakaoAuthVM.swift
//  LinkPunch
//
//  Created by 오영석 on 2023/08/24.
//

import Foundation
import Combine
import KakaoSDKUser
import Firebase

@MainActor
class KakaoAuthVM : ObservableObject {
    
    @Published var isLoggedIn : Bool = false
    @Published var nickname: String = ""
    @Published var profileImageURL: URL?
    @Published var accountEmail: String?
    @Published var userData: User = User()

    
    func handleLoginWithKakaoTalkApp() async -> Bool {
        
        await withCheckedContinuation{ continuation in
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    self.getUserInfo()
                    continuation.resume(returning: true)
                    
                }
                
            }
        }
    }
    
    func handleLoginWithKakaoAccount() async -> Bool {
        
        await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    self.getUserInfo()
                    continuation.resume(returning: true)
                    
                }
            }
        }
    }
    
    @MainActor
    func handleKakaoLogin(completion: @escaping (Bool) -> Void) {
        Task {
            // 카카오톡 설치 여부 확인 - 설치 되었을 때
            if (UserApi.isKakaoTalkLoginAvailable()) {
                // 카카오 앱을 통해 로그인
                isLoggedIn = await handleLoginWithKakaoTalkApp()
            } else { // 설치 안되어 있을 때
                // 웹뷰를 열어 카카오계정으로 로그인
                isLoggedIn = await handleLoginWithKakaoAccount()
            }
            
            if isLoggedIn {
                DispatchQueue.main.async {
                    completion(true)
                }
            } else {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    func kakaoLoginWithFirebase() {
        
        guard let userEmail = userData.userEmail, !userEmail.isEmpty else {
            return
        }
        
        UserDefaultsData.shared.setUser(email: userEmail, nickName: userData.userNickName ?? "", social: .kakao)
        userData.name = "LoginWithKakao"
        userData.social = Social.kakao
        userData.signUpDate = Date().dateToString()
        
        let dataBase = Firestore.firestore()
        let dbCollectionDocument = dataBase.collection("users").document(userEmail)
        
        dbCollectionDocument.getDocument { document, error in
            if let document = document, document.exists {
                // 카카오계정 회원정보가 있는 경우
                dbCollectionDocument.updateData(self.userData.asDictionary()) { error in
                    if let error = error {
                        print("도큐먼트 업데이트 에러: \(error)")
                    } else {
                        print("카카오계정으로 로그인 성공")
                    }
                }
            } else {
                // 카카오로그인을 처음 사용하는 경우 (회원가입)
                dbCollectionDocument.setData(self.userData.asDictionary()) { error in
                    if let error = error {
                        print(error)
                    } else {
                        print("카카오계정으로 회원가입")
                    }
                }
            }
        }
    }
    
    
    func getUserInfo() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                
                guard let nickname = user?.kakaoAccount?.profile?.nickname else {
                    
                    return
                }
                guard let profileImageURL = user?.kakaoAccount?.profile?.profileImageUrl else {
                    
                    return
                }
                guard let accountEmail = user?.kakaoAccount?.email else {
                    
                    return
                }
                
                DispatchQueue.main.async {
                    self.userData.userNickName = nickname
                    self.userData.userImage = profileImageURL.absoluteString
                    self.userData.userEmail = accountEmail
                    self.userData.report = Report(isStopped: false, isDeleted: false, suspensionDate: "", stopCount: 0, reportedCount: ReportCount())
                    self.kakaoLoginWithFirebase()
                    
                }
            }
        }
    }
    
    // 로그아웃 관련
    func handleKakaoLogout() {
        self.logoutKakaoAccount { success in
            if success {
                MyPageStore().removeUserData()
                print("카카오계정 로그아웃 성공")
            } else {
                print("카카오계정 로그아웃 에러")
            }
        }
    }
    
    func logoutKakaoAccount(completion: @escaping (Bool) -> Void) {
        UserApi.shared.logout { error in
            if let error = error {
                print(error)
                
                completion(false)
            } else {
                self.isLoggedIn = false
                self.nickname = ""
                self.profileImageURL = nil
                self.accountEmail = nil
                self.userData = User()
                completion(true)
            }
        }
    }
    
    // 앱에서 카카오계정 삭제 - 회원탈퇴
    func deleteKakaoAccount() {
        guard let userEmail = userData.userEmail, !userEmail.isEmpty else {
            return
        }
        
        MyPageStore().deleteUser(userEmail: userEmail)
        MyPageStore().removeUserData()
        print("카카오계정 삭제 성공")
    }
    
}
