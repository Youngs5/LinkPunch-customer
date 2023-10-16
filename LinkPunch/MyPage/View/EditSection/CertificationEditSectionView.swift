//
//  CertificationEditSectionView.swift
//  LinkPunch
//
//  Created by 박채영 on 2023/08/23.
//

import SwiftUI

struct CertificationEditSectionView: View {
    @StateObject var myPageStore: MyPageStore
    
    @Binding var isShowingCertificationAddSheet: Bool
    @Binding var isShowingCertificationEditSheet: Bool
    
    @Binding var editedItemId: String
    
    @State var isDeleteButtonTapped: Bool = false
    @State var isEditButtonTapped: Bool = false
    @State var selectedItemId: String = ""
    
    var body: some View {
        Section {
            if let cv = myPageStore.updateUser.cv {
                VStack {
                    ForEach(cv.certifications ?? []) { certification in
                        EditExperienceBoxView(myPageStore: myPageStore, experience: certification, isDeleteButtonTapped: $isDeleteButtonTapped, isEditButtonTapped: $isEditButtonTapped, selectedItemId: $selectedItemId)
                        
                        if certification.id != cv.certifications?.last?.id {
                            Divider()
                        }
                    }
                }
                .background(Color(white: 0.9))
                .padding([.bottom, .leading, .trailing], 10)
                .onChange(of: isDeleteButtonTapped) { _ in
                    myPageStore.updateUser.cv?.certifications = cv.certifications?.filter { $0.id != selectedItemId }
                    myPageStore.userCv.certifications = cv.certifications?.filter { $0.id != selectedItemId }
                    print("삭제")
                    print(myPageStore.updateUser)
                    print(myPageStore.userCv)
                    print("deletedId: \(selectedItemId)")
                    
                }
                .onChange(of: isEditButtonTapped) { _ in
                    editedItemId = selectedItemId
                    isShowingCertificationEditSheet.toggle()
                }
            }
        } header: {
            HStack {
                Text("자격증")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding([.leading, .trailing], 20)
                Spacer()
                Button("항목 추가") {
                    isShowingCertificationAddSheet.toggle()
                }
                .padding(.trailing, 20)
            }
        }
    }
}

struct CertificationEditSectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CertificationEditSectionView(myPageStore: MyPageStore(), isShowingCertificationAddSheet: .constant(false), isShowingCertificationEditSheet: .constant(false), editedItemId: .constant(""))
        }
    }
}
