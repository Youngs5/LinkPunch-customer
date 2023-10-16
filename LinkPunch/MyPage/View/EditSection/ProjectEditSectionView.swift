//
//  ProjectEditSectionView.swift
//  LinkPunch
//
//  Created by 박채영 on 2023/08/23.
//

import SwiftUI

struct ProjectEditSectionView: View {
    @StateObject var myPageStore: MyPageStore
    
    @Binding var isShowingProjectAddSheet: Bool
    @Binding var isShowingProjectEditSheet: Bool
    
    @Binding var editedItemId: String
    
    @State var isDeleteButtonTapped: Bool = false
    @State var isEditButtonTapped: Bool = false
    @State var selectedItemId: String = ""
    
    var body: some View {
        Section {
            if let cv = myPageStore.updateUser.cv {
                VStack {
                    ForEach(cv.projects ?? []) { project in
                        EditExperienceBoxView(myPageStore: myPageStore, experience: project, isDeleteButtonTapped: $isDeleteButtonTapped, isEditButtonTapped: $isEditButtonTapped, selectedItemId: $selectedItemId)
                        
                        if project.id != cv.projects?.last?.id {
                            Divider()
                        }
                    }
                }
                .background(Color(white: 0.9))
                .padding([.bottom, .leading, .trailing], 10)
                .onChange(of: isDeleteButtonTapped) { _ in
                    myPageStore.updateUser.cv?.projects = cv.projects?.filter { $0.id != selectedItemId }
                    myPageStore.userCv.projects = cv.projects?.filter { $0.id != selectedItemId }
                    print("삭제")
                    print(myPageStore.updateUser)
                    print(myPageStore.userCv)
                    print("deletedId: \(selectedItemId)")
                }
                .onChange(of: isEditButtonTapped) { _ in
                    editedItemId = selectedItemId
                    isShowingProjectEditSheet.toggle()
                }
            }
        } header: {
            HStack {
                Text("프로젝트")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading, 20)
                Spacer()
                Button("항목 추가") {
                    isShowingProjectAddSheet.toggle()
                }
                .padding(.trailing, 20)
            }
        }
    }
}

struct ProjectEditSectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProjectEditSectionView(myPageStore: MyPageStore(), isShowingProjectAddSheet: .constant(false), isShowingProjectEditSheet: .constant(false), editedItemId: .constant(""))
        }
    }
}
