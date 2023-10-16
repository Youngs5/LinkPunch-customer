//
//  EducationAddSheet.swift
//  LinkPunch
//
//  Created by 박채영 on 2023/08/28.
//

import SwiftUI

struct EducationAddSheet: View {
    let statusArray = ["재학", "휴학", "수료", "졸업"]
    
    @StateObject var myPageStore: MyPageStore
    
    @Binding var isShowingEducationAddSheet: Bool
    
    @Binding var educationSchool: String
    @Binding var educationStatus: String
    @Binding var educationMajor: String
    @Binding var admissionYear: Date
    @Binding var graduateYear: Date
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("학교")
                        .fontWeight(.semibold)
                    
                    TextField("", text: $educationSchool)
                        .textFieldStyle(.roundedBorder)
                }
                
                HStack {
                    Text("전공")
                        .fontWeight(.semibold)
                    
                    TextField("", text: $educationMajor)
                        .textFieldStyle(.roundedBorder)
                }
                
                HStack {
                    Text("상태")
                        .fontWeight(.semibold)
                    Spacer()
                    Picker("상태", selection: $educationStatus) {
                        ForEach(statusArray, id: \.self) { status in
                            Text("\(status)")
                        }
                    }
                }
                
                DatePicker("입학 일자", selection: $admissionYear, displayedComponents: .date)
                    .fontWeight(.semibold)
                
                DatePicker("졸업(예정) 일자", selection: $graduateYear, displayedComponents: .date)
                    .fontWeight(.semibold)
            }
            .presentationDetents([.medium, .large])
            .padding()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        isShowingEducationAddSheet.toggle()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("완료") {
                        let newEducation = Education(
                            school: educationSchool,
                            status: educationStatus,
                            major: educationMajor,
                            admissionYear: admissionYear.dateToStringForMyPage(),
                            graduateYear: graduateYear.dateToStringForMyPage()
                        )
                        
                        myPageStore.userEducation.append(newEducation)
                        myPageStore.addUpdateEducationData()
                        
                        educationSchool = ""
                        educationStatus = ""
                        educationMajor = ""
                        admissionYear = Date()
                        graduateYear = Date()
                        
                        isShowingEducationAddSheet.toggle()
                    }
                    .disabled(
                        educationSchool.isEmpty || educationMajor.isEmpty
                    )
                }
            }
            
            Spacer()
        }
    }
}

struct EducationAddSheet_Previews: PreviewProvider {
    static var previews: some View {
        EducationAddSheet(
            myPageStore: MyPageStore(),
            isShowingEducationAddSheet: .constant(true),
            educationSchool: .constant(""),
            educationStatus: .constant(""),
            educationMajor: .constant(""),
            admissionYear: .constant(Date()),
            graduateYear: .constant(Date())
        )
    }
}
