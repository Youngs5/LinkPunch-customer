//
//  GoogleSignInVM.swift
//  LinkPunch
//
//  Created by 정유진 on 2023/08/24.
//

import Foundation
import Firebase
import GoogleSignIn


enum AuthenticationError: Error {
    case tokenError(message: String)
}

@MainActor
class GoogleSignInVM: ObservableObject {
    @Published var userData: User = User()
    @Published var email: String = ""
    @Published var password: String = ""
    
    //MARK: - Google Sign - In
    func signInWithGoogle() async -> Bool {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No client ID found")
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let window = windowScene.windows.first,
                let rootViewController = window.rootViewController else {
            print("There is no root view controller!")
            return false
        }
        
        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user = userAuthentication.user
            guard let idToken = user.idToken else {
                throw AuthenticationError.tokenError(message: "ID token missing")
            }
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user
            print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
            return await googleLoginWithFirebase(name: firebaseUser.displayName, email: firebaseUser.email, uid: firebaseUser.uid, signupdata: firebaseUser.metadata.creationDate)
        } catch {
            print(error.localizedDescription)
            return false
            
        }
            
        
            
    }
    
    func googleLoginWithFirebase(name: String?,email: String?,uid: String?,signupdata:Date?) async -> Bool{
        
        guard let userEmail = email, !userEmail.isEmpty else {
            return false
        }
        UserDefaultsData.shared.setUser(email: userEmail, nickName: name ?? "", social: .google)
        
        userData.name = name ?? "LoginWithGoogle"
        userData.userEmail = userEmail
        userData.userNickName = name ?? ""
        userData.social = Social.google
        userData.report = Report(isStopped: false, isDeleted: false, suspensionDate: "", stopCount: 0, reportedCount: ReportCount())
        userData.signUpDate = signupdata?.dateToString()
        
        let dataBase = Firestore.firestore()
        do {
            let datas = try await Firestore.firestore().collection("users").document(userEmail).getDocument()
            if let data = datas.data(), !data.isEmpty {
                do {
                    try await dataBase.collection("users")
                        .document(userEmail)
                        .updateData(userData.asDictionary())
                    return true
                } catch{
                    debugPrint("updateData error")
                    return false
                }
            } else {
                do {
                    try await dataBase.collection("users")
                        .document(userEmail)
                        .setData(userData.asDictionary())
                    return true
                } catch{
                    debugPrint("setData error")
                    return false
                }
            }
        } catch {
            debugPrint("getDocument error")
            return false
           
        }
       

    }
        
}

