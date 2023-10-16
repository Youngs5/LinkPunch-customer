//
//  ActivityEditSheet.swift
//  LinkPunch
//
//  Created by 박채영 on 2023/08/29.
//

import SwiftUI

struct ActivityEditSheet: View {
    @StateObject var myPageStore: MyPageStore
    
    @Binding var isShowingActivityEditSheet: Bool
    
    @Binding var editedActivityTitle: String
    @Binding var editedActivityStartDate: Date
    @Binding var editedActivityEndDate: Date
    @Binding var editedActivityDescription: String
    
    @Binding var editedItemId: String
    
    var edtiedPActivityPeriod: String {
        return "\(editedActivityStartDate.dateToStringForMyPage()) ~ \(editedActivityEndDate.dateToStringForMyPage())"
    }
    
    var editedItem: Experience {
        if let activities = myPageStore.updateUser.cv?.activities {
            return activities.first(where: {
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
                    Text("활동명")
                        .fontWeight(.semibold)
                    
                    TextField("", text: $editedActivityTitle)
                        .textFieldStyle(.roundedBorder)
                }
                
                DatePicker("활동 시작 일자", selection: $editedActivityStartDate, displayedComponents: .date)
                    .fontWeight(.semibold)
                
                DatePicker("활동 마감 일자", selection: $editedActivityEndDate, displayedComponents: .date)
                    .fontWeight(.semibold)
                
                TextField("활동 설명", text: $editedActivityDescription, axis: .vertical)
            }
            .padding()
            .onAppear {
                print("<> activity: \(editedItemId)")
                
                editedActivityTitle = editedItem.title
                editedActivityDescription = editedItem.description
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        isShowingActivityEditSheet.toggle()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("완료") {
                        let editedOne = Experience(
                            id: editedItemId,
                            title: editedActivityTitle,
                            period: edtiedPActivityPeriod,
                            description: editedActivityDescription
                        )
                        
                        myPageStore.updateUser.cv?.activities?.append(editedOne)
                        myPageStore.updateUser.cv?.activities?.remove(at:myPageStore.updateUser.cv?.activities?.firstIndex(where: { $0.id == editedItemId}) ?? 0)
                        
                        myPageStore.updateUserData()
                        
                        isShowingActivityEditSheet.toggle()
                    }
                    .disabled(
                        editedActivityTitle.isEmpty || editedActivityDescription.isEmpty
                    )
                }
            }
            
            Spacer()
        }
    }
}

struct ActivityEditSheet_Previews: PreviewProvider {
    static var previews: some View {
        ActivityEditSheet(
            myPageStore: MyPageStore(),
            isShowingActivityEditSheet: .constant(true),
            editedActivityTitle: .constant(""),
            editedActivityStartDate: .constant(Date()),
            editedActivityEndDate: .constant(Date()),
            editedActivityDescription: .constant(""),
            editedItemId: .constant("")
        )
    }
}
