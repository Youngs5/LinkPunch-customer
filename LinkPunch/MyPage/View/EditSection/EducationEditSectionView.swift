//
//  EducationEditSectionView.swift
//  LinkPunch
//
//  Created by 박채영 on 2023/08/28.
//

import SwiftUI

struct EducationEditSectionView: View {
    @StateObject var myPageStore: MyPageStore
    
    @Binding var isShowingEducationAddSheet: Bool
    @Binding var isShowingEducationEditSheet: Bool
    
    @Binding var editedItemId: String
    
    @State var isDeleteButtonTapped: Bool = false
    @State var isEditButtonTapped: Bool = false
    @State var selectedItemId: String = ""
    
    var body: some View {
        Section {
            if let educations = myPageStore.updateUser.education {
                VStack {
                    ForEach(educations) { education in
                        EditEducationBoxView(myPageStore: myPageStore, education: education, isDeleteButtonTapped: $isDeleteButtonTapped, isEditButtonTapped: $isEditButtonTapped, selectedItemId: $selectedItemId)
                        
                        if education.id != educations.last?.id {
                            Divider()
                        }
                    }
                }
                .background(Color(white: 0.9))
                .padding([.bottom, .leading, .trailing], 10)
                .onChange(of: isDeleteButtonTapped) { _ in
                    myPageStore.updateUser.education = educations.filter { $0.id != selectedItemId }
                    myPageStore.userEducation = educations.filter { $0.id != selectedItemId }
                    print("삭제")
                    print(myPageStore.updateUser)
                    print(myPageStore.userEducation)
                    print("deletedId: \(selectedItemId)")
                    
                }
                .onChange(of: isEditButtonTapped) { _ in
                    editedItemId = selectedItemId
                    isShowingEducationEditSheet.toggle()
                }
            }
        } header: {
            HStack {
                Text("학력")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding([.leading, .trailing], 20)
                Spacer()
                Button("항목 추가") {
                    isShowingEducationAddSheet.toggle()
                }
                .padding(.trailing, 20)
            }
        }
    }
}

struct EducationEditSectionView_Previews: PreviewProvider {
    static var previews: some View {
        EducationEditSectionView(myPageStore: MyPageStore(), isShowingEducationAddSheet: .constant(false), isShowingEducationEditSheet: .constant(false), editedItemId: .constant(""))
    }
}
