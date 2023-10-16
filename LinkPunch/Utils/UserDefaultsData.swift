//
//  UserDefaultsData.swift
//  LinkPunch
//
//  Created by 김민기 on 2023/08/24.
//

import Foundation

class UserDefaultsData {
    enum Key: String, CaseIterable {
        case userEmail
        case userNickname
        case social
    }
    
    static let shared: UserDefaultsData = {
        return UserDefaultsData()
    }()
    
    func removeAll() {
        Key.allCases.forEach { key in
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        }
    }
    func setUser(email: String, nickName:String, social: Social) {
        UserDefaults.standard.setValue(email, forKey: Key.userEmail.rawValue)
        UserDefaults.standard.setValue(nickName, forKey: Key.userNickname.rawValue)
        UserDefaults.standard.setValue(social.rawValue  , forKey: Key.social.rawValue)
        UserDefaults.standard.synchronize()
    }
//    func setUserNickName(nickName: String) {
//        UserDefaults.standard.setValue(nickName, forKey: Key.userNickname.rawValue)
//        UserDefaults.standard.synchronize()
//    }
    func getUserEmail() -> String? {
        guard let email = UserDefaults.standard.string(forKey: Key.userEmail.rawValue) else {
            return nil
        }
        return email
    }
    func getUserNickName() -> String? {
        guard let nickname = UserDefaults.standard.string(forKey: Key.userNickname.rawValue) else {
            return nil
        }
        return nickname
    }
    
    func getUserSocial() -> Social? {
        guard let socialValue = UserDefaults.standard.string(forKey: Key.social.rawValue) else {
            return nil
        }
        
        return Social(rawValue: socialValue)
    }
}

//사용법
//UserDefaultsData.shared.getUser()
//호출하면 유저 이메일 쓸수있어요
