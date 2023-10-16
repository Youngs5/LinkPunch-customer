//
//  ContentView.swift
//  LinkPunch
//
//  Created by 유하은 on 2023/08/22.
//

import SwiftUI

struct ContentView: View {
    @State var isAutoLogin: Bool = UserDefaults.standard.bool(forKey: "isAutoLogin")
    
    var body: some View {
        if isAutoLogin {
            MainTabView()
        } else {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
