//
//  CertificationEditSheet.swift
//  LinkPunch
//
//  Created by 박채영 on 2023/08/29.
//

import SwiftUI

struct CertificationEditSheet: View {
    @StateObject var myPageStore: MyPageStore
    
    @Binding var isShowingCertificationEditSheet: Bool
    
    @Binding var editedCertificationTitle: String
    @Binding var editedCertificationStartDate: Date
    @Binding var editedCertificationEndDate: Date
    @Binding var editedCertificationDescription: String
    
    @Binding var editedItemId: String
    
    var edtiedCertificationPeriod: String {
        return "\(editedCertificationStartDate.dateToStringForMyPage()) ~ \(editedCertificationEndDate.dateToStringForMyPage())"
    }
    
    var editedItem: Experience {
        if let certifications = myPageStore.updateUser.cv?.certifications {
            return certifications.first(where: {
                $0.id == editedItemId
            }) ?? Experience(title: "", period: "", description: "")
        } else {
            return Experience(title: "", period: "", description: "")
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("자격증명")
                        .fontWeight(.semibold)
                    
                    TextField("", text: $editedCertificationTitle)
                        .textFieldStyle(.roundedBorder)
                }
                
                DatePicker("자격증 취득 일자", selection: $editedCertificationStartDate, displayedComponents: .date)
                    .fontWeight(.semibold)
                
                DatePicker("자격증 유효 일자", selection: $editedCertificationEndDate, displayedComponents: .date)
                    .fontWeight(.semibold)
                
                TextField("자격증 설명", text: $editedCertificationDescription, axis: .vertical)
            }
            .padding()
            .onAppear {
                print("<> certification: \(editedItemId)")
                
                editedCertificationTitle = editedItem.title
                editedCertificationDescription = editedItem.description
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        isShowingCertificationEditSheet.toggle()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("완료") {
                        let editedOne = Experience(
                            id: editedItemId,
                            title: editedCertificationTitle,
                            period: edtiedCertificationPeriod,
                            description: editedCertificationDescription
                        )
                        
                        myPageStore.updateUser.cv?.certifications?.append(editedOne)
                        myPageStore.updateUser.cv?.certifications?.remove(at:myPageStore.updateUser.cv?.certifications?.firstIndex(where: { $0.id == editedItemId}) ?? 0)
                        
                        myPageStore.updateUserData()
                        
                        isShowingCertificationEditSheet.toggle()
                    }
                    .disabled(
                        editedCertificationTitle.isEmpty || editedCertificationDescription.isEmpty
                    )
                }
            }
            
            Spacer()
        }
    }
}

struct CertificationEditSheet_Previews: PreviewProvider {
    static var previews: some View {
        CertificationEditSheet(
            myPageStore: MyPageStore(),
            isShowingCertificationEditSheet: .constant(true),
            editedCertificationTitle: .constant(""),
            editedCertificationStartDate: .constant(Date()),
            editedCertificationEndDate: .constant(Date()),
            editedCertificationDescription: .constant(""),
            editedItemId: .constant("")
        )
    }
}
