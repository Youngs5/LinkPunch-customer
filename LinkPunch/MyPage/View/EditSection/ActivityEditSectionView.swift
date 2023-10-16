//
//  ActivityEditSectionView.swift
//  LinkPunch
//
//  Created by 박채영 on 2023/08/23.
//

import SwiftUI

struct ActivityEditSectionView: View {
    @StateObject var myPageStore: MyPageStore
    
    @Binding var isShowingActivityAddSheet: Bool
    @Binding var isShowingActivityEditSheet: Bool
    
    @Binding var editedItemId: String
    
    @State var isDeleteButtonTapped: Bool = false
    @State var isEditButtonTapped: Bool = false
    @State var selectedItemId: String = ""
    
    var body: some View {
        Section {
            if let cv = myPageStore.updateUser.cv {
                VStack {
                    ForEach(cv.activities ?? []) { activity in
                        EditExperienceBoxView(myPageStore: myPageStore, experience: activity, isDeleteButtonTapped: $isDeleteButtonTapped, isEditButtonTapped: $isEditButtonTapped, selectedItemId: $selectedItemId)
                        
                        if activity.id != cv.activities?.last?.id {
                            Divider()
                        }
                    }
                }
                .background(Color(white: 0.9))
                .padding([.bottom, .leading, .trailing], 10)
                .onChange(of: isDeleteButtonTapped) { _ in
                    myPageStore.updateUser.cv?.activities = cv.activities?.filter { $0.id != selectedItemId }
                    myPageStore.userCv.activities = cv.activities?.filter { $0.id != selectedItemId }
                    print("삭제")
                    print(myPageStore.updateUser)
                    print(myPageStore.userCv)
                    print("deletedId: \(selectedItemId)")
                }
                .onChange(of: isEditButtonTapped) { _ in
                    editedItemId = selectedItemId
                    isShowingActivityEditSheet.toggle()
                }
            }
        } header: {
            HStack {
                Text("활동 및 경력")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding([.leading, .trailing], 20)
                Spacer()
                Button("항목 추가") {
                    isShowingActivityAddSheet.toggle()
                }
                .padding(.trailing, 20)
            }
        }
    }
}

struct ActivityEditSectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ActivityEditSectionView(myPageStore: MyPageStore(), isShowingActivityAddSheet: .constant(false), isShowingActivityEditSheet: .constant(false), editedItemId: .constant(""))
        }
    }
}
