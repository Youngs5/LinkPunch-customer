//
//  EducationEditSheet.swift
//  LinkPunch
//
//  Created by 박채영 on 2023/08/29.
//

import SwiftUI

struct EducationEditSheet: View {
    let statusArray = ["재학", "휴학", "수료", "졸업"]
    
    @StateObject var myPageStore: MyPageStore
    
    @Binding var isShowingEducationEditSheet: Bool
    
    @Binding var editedEducationSchool: String
    @Binding var editedEducationStatus: String
    @Binding var editedEducationMajor: String
    @Binding var editedAdmissionYear: Date
    @Binding var editedGraduateYear: Date
    
    @Binding var editedItemId: String
    var editedItem: Education {
        return myPageStore.userEducation.first(where: {
            $0.id == editedItemId
        }) ?? Education(school: "", status: "", major: "", admissionYear: "", graduateYear: "")
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("학교")
                        .fontWeight(.semibold)
                    
                    TextField("", text: $editedEducationSchool)
                        .textFieldStyle(.roundedBorder)
                }
                
                HStack {
                    Text("전공")
                        .fontWeight(.semibold)
                    
                    TextField("", text: $editedEducationMajor)
                        .textFieldStyle(.roundedBorder)
                }
                
                HStack {
                    Text("상태")
                        .fontWeight(.semibold)
                    Spacer()
                    Picker("상태", selection: $editedEducationStatus) {
                        ForEach(statusArray, id: \.self) { status in
                            Text("\(status)")
                        }
                    }
                }
                
                DatePicker("입학 일자", selection: $editedAdmissionYear, displayedComponents: .date)
                    .fontWeight(.semibold)
                
                DatePicker("졸업(예정) 일자", selection: $editedGraduateYear, displayedComponents: .date)
                    .fontWeight(.semibold)
            }
            .padding()
            .onAppear {
                print("<> education: \(editedItemId)")
                
                editedEducationSchool = editedItem.school
                editedEducationMajor = editedItem.major
                editedEducationStatus = editedItem.status
                editedAdmissionYear = editedItem.admissionYear.stringToDate()
                editedGraduateYear = editedItem.graduateYear.stringToDate()
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        isShowingEducationEditSheet.toggle()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("완료") {
                        let editedOne = Education(
                            school: editedEducationSchool,
                            status: editedEducationStatus,
                            major: editedEducationMajor,
                            admissionYear: editedAdmissionYear.dateToStringForMyPage(),
                            graduateYear: editedGraduateYear.dateToStringForMyPage()
                        )
                        
                        myPageStore.userEducation.append(editedOne)
                        myPageStore.userEducation.remove(at:myPageStore.userEducation.firstIndex(where: { $0.id == editedItemId}) ?? 0)
                        
                        myPageStore.addUpdateEducationData()
                        
                        isShowingEducationEditSheet.toggle()
                    }
                    .disabled(
                        editedEducationSchool.isEmpty || editedEducationMajor.isEmpty
                    )
                }
            }
            
            Spacer()
        }
    }
}

struct EducationEditSheet_Previews: PreviewProvider {
    static var previews: some View {
        EducationEditSheet(
            myPageStore: MyPageStore(),
            isShowingEducationEditSheet: .constant(true),
            editedEducationSchool: .constant(""),
            editedEducationStatus: .constant(""),
            editedEducationMajor: .constant(""),
            editedAdmissionYear: .constant(Date()),
            editedGraduateYear: .constant(Date()),
            editedItemId: .constant("")
        )
    }
}
