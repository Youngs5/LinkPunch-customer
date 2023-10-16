//
//  Store.swift
//  LinkPunch
//
//  Created by 유하은 on 2023/08/22.
//

import Foundation
import FirebaseFirestore

class HomeStore: ObservableObject {
    
    let db = Firestore.firestore()
    @Published var userList: [User]
    
    init() {
        self.userList = []
       /* fetch { success in
            if success {
                self.isSuccess = true
            }
        }*/
    }
    
    func fetch(completion: @escaping (Bool) -> Void) {
        
        userList.removeAll()
        db.collection("users").getDocuments { (querySnapshot, error) in
            
            guard let querySnapshot = querySnapshot, error == nil else {
                print("Error fetching data: (error?.localizedDescription ?? ")
                return
            }
            
            for document in querySnapshot.documents {
                if let jsonData = try? JSONSerialization.data(withJSONObject: document.data(), options: []),
                   let post = try? JSONDecoder().decode(User.self, from: jsonData) {
                    self.userList.append(post)
                }
            }
            completion(true)
            print("유저리스트 패치: \(self.userList)")
        }
    }

}
