//
//  ProjectAddSheet.swift
//  LinkPunch
//
//  Created by 박채영 on 2023/08/23.
//

import SwiftUI

struct ProjectAddSheet: View {
    @StateObject var myPageStore: MyPageStore
    
    @Binding var isShowingProjectAddSheet: Bool
    
    @Binding var projectTitle: String
    @Binding var projectStartDate: Date
    @Binding var projectEndDate: Date
    @Binding var projectDescription: String
    
    var projectPeriod: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM."
            
            let startDateString = formatter.string(from: projectStartDate)
            let endDateString = formatter.string(from: projectEndDate)
            return "\(startDateString) ~ \(endDateString)"
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("프로젝트명")
                        .fontWeight(.semibold)
                    
                    TextField("", text: $projectTitle)
                        .textFieldStyle(.roundedBorder)
                }
                
                DatePicker("프로젝트 시작 일자", selection: $projectStartDate, displayedComponents: .date)
                    .fontWeight(.semibold)
                
                DatePicker("프로젝트 마감 일자", selection: $projectEndDate, displayedComponents: .date)
                    .fontWeight(.semibold)
                
                TextField("프로젝트 설명", text: $projectDescription, axis: .vertical)
            }
            .presentationDetents([.medium, .large])
            .padding()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        isShowingProjectAddSheet.toggle()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("완료") {
                        let newProject = Experience(
                            title: projectTitle,
                            period: projectPeriod,
                            description: projectDescription
                        )
                        
                        myPageStore.userCv.projects?.append(newProject)
                        myPageStore.addUpdateCVData()
                        
                        projectTitle = ""
                        projectStartDate = Date()
                        projectEndDate = Date()
                        projectDescription = ""
                        
                        isShowingProjectAddSheet.toggle()
                    }
                    .disabled(
                        projectTitle.isEmpty || projectDescription.isEmpty
                    )
                }
            }
            
            Spacer()
        }
    }
}

struct ProjectAddSheet_Previews: PreviewProvider {
    static var previews: some View {
        ProjectAddSheet(
            myPageStore: MyPageStore(),
            isShowingProjectAddSheet: .constant(true),
            projectTitle: .constant(""),
            projectStartDate: .constant(Date()),
            projectEndDate: .constant(Date()),
            projectDescription: .constant("")
        )
    }
}
