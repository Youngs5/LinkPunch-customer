//
//  MainTabView.swift
//  LinkPunch
//
//  Created by 유하은 on 2023/08/22.
//

import SwiftUI
struct MainTabView: View {
    //    let users: [User] = sampleUsers
    @StateObject var homeStore: HomeStore = HomeStore()
    
    var body: some View {
        TabView {
            HomeView(homeStore: homeStore)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0)
            StudyRecruitmentView(homeStore: homeStore)
                .tabItem {
                    Image(systemName: "clipboard.fill")
                    Text("Study")
                }
                .tag(1)
            MyPageView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("My")
                }
                .tag(2)
        }
        .onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
        .navigationBarBackButtonHidden()
    }
}


struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
