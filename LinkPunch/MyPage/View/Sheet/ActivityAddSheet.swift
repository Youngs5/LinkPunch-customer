//
//  ActivityAddSheet.swift
//  LinkPunch
//
//  Created by 박채영 on 2023/08/23.
//

import SwiftUI

struct ActivityAddSheet: View {
    @StateObject var myPageStore: MyPageStore
    
    @Binding var isShowingActivityAddSheet: Bool
    
    @Binding var activityTitle: String
    @Binding var activityStartDate: Date
    @Binding var activityEndDate: Date
    @Binding var activityDescription: String
    
    var activityPeriod: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM."
            
            let startDateString = formatter.string(from: activityStartDate)
            let endDateString = formatter.string(from: activityEndDate)
            return "\(startDateString) ~ \(endDateString)"
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("활동명")
                        .fontWeight(.semibold)
                    
                    TextField("", text: $activityTitle)
                        .textFieldStyle(.roundedBorder)
                }
                
                DatePicker("활동 시작 일자", selection: $activityStartDate, displayedComponents: .date)
                    .fontWeight(.semibold)
                
                DatePicker("활동 마감 일자", selection: $activityEndDate, displayedComponents: .date)
                    .fontWeight(.semibold)
                
                TextField("활동 설명", text: $activityDescription, axis: .vertical)
            }
            .presentationDetents([.medium, .large])
            .padding()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        isShowingActivityAddSheet.toggle()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("완료") {
                        let newActivity = Experience(
                            title: activityTitle,
                            period: activityPeriod,
                            description: activityDescription
                        )
                        
                        myPageStore.userCv.activities?.append(newActivity)
                        myPageStore.addUpdateCVData()
                        
                        activityTitle = ""
                        activityStartDate = Date()
                        activityEndDate = Date()
                        activityDescription = ""
                        
                        isShowingActivityAddSheet.toggle()
                    }
                    .disabled(
                        activityTitle.isEmpty || activityDescription.isEmpty
                    )
                }
            }
            
            Spacer()
        }
    }
}

struct ActivityAddSheet_Previews: PreviewProvider {
    static var previews: some View {
        ActivityAddSheet(
            myPageStore: MyPageStore(),
            isShowingActivityAddSheet: .constant(true),
            activityTitle: .constant(""),
            activityStartDate: .constant(Date()),
            activityEndDate: .constant(Date()),
            activityDescription: .constant("")
        )
    }
}
