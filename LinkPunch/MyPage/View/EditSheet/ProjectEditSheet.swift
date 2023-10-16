//
//  ProjectEditSheet.swift
//  LinkPunch
//
//  Created by 박채영 on 2023/08/29.
//

import SwiftUI

struct ProjectEditSheet: View {
    @StateObject var myPageStore: MyPageStore
    
    @Binding var isShowingProjectEditSheet: Bool
    
    @Binding var editedProjectTitle: String
    @Binding var editedProjectStartDate: Date
    @Binding var editedProjectEndDate: Date
    @Binding var editedProjectDescription: String
    
    @Binding var editedItemId: String
    
    var edtiedProjectPeriod: String {
        return "\(editedProjectStartDate.dateToStringForMyPage()) ~ \(editedProjectEndDate.dateToStringForMyPage())"
    }
    
    var editedItem: Experience {
        if let projects = myPageStore.updateUser.cv?.projects {
            return projects.first(where: {
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
                    Text("프로젝트명")
                        .fontWeight(.semibold)
                    
                    TextField("", text: $editedProjectTitle)
                        .textFieldStyle(.roundedBorder)
                }
                
                DatePicker("프로젝트 시작 일자", selection: $editedProjectStartDate, displayedComponents: .date)
                    .fontWeight(.semibold)
                
                DatePicker("프로젝트 마감 일자", selection: $editedProjectEndDate, displayedComponents: .date)
                    .fontWeight(.semibold)
                
                TextField("프로젝트 설명", text: $editedProjectDescription, axis: .vertical)
            }
            .padding()
            .onAppear {
                print("<> project: \(editedItemId)")
                
                editedProjectTitle = editedItem.title
                editedProjectDescription = editedItem.description
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        isShowingProjectEditSheet.toggle()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("완료") {
                        let editedOne = Experience(
                            id: editedItemId,
                            title: editedProjectTitle,
                            period: edtiedProjectPeriod,
                            description: editedProjectDescription
                        )
                        
                        myPageStore.updateUser.cv?.projects?.append(editedOne)
                        myPageStore.updateUser.cv?.projects?.remove(at:myPageStore.updateUser.cv?.projects?.firstIndex(where: { $0.id == editedItemId}) ?? 0)
                        
                        myPageStore.updateUserData()
                        
                        isShowingProjectEditSheet.toggle()
                    }
                    .disabled(
                        editedProjectTitle.isEmpty || editedProjectDescription.isEmpty
                    )
                }
            }
            
            Spacer()
        }
    }
}
    
struct ProjectEditSheet_Previews: PreviewProvider {
    static var previews: some View {
        ProjectEditSheet(
            myPageStore: MyPageStore(),
            isShowingProjectEditSheet: .constant(true),
            editedProjectTitle: .constant(""),
            editedProjectStartDate: .constant(Date()),
            editedProjectEndDate: .constant(Date()),
            editedProjectDescription: .constant(""),
            editedItemId: .constant("")
        )
    }
}
