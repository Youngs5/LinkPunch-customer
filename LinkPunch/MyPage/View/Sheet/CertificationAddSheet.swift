//
//  CertificationAddSheet.swift
//  LinkPunch
//
//  Created by 박채영 on 2023/08/23.
//

import SwiftUI

struct CertificationAddSheet: View {
    @StateObject var myPageStore: MyPageStore
    
    @Binding var isShowingCertificationAddSheet: Bool
    
    @Binding var certificationTitle: String
    @Binding var certificationStartDate: Date
    @Binding var certificationEndDate: Date
    @Binding var certificationDescription: String
    
    var certificationPeriod: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM."
            
            let startDateString = formatter.string(from: certificationStartDate)
            let endDateString = formatter.string(from: certificationEndDate)
            return "\(startDateString) ~ \(endDateString)"
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("자격증명")
                        .fontWeight(.semibold)
                    
                    TextField("", text: $certificationTitle)
                        .textFieldStyle(.roundedBorder)
                }
                
                DatePicker("자격증 취득 일자", selection: $certificationStartDate, displayedComponents: .date)
                    .fontWeight(.semibold)
                
                DatePicker("자격증 유효 일자", selection: $certificationEndDate, displayedComponents: .date)
                    .fontWeight(.semibold)
                
                TextField("자격증 설명", text: $certificationDescription, axis: .vertical)
            }
            .presentationDetents([.medium, .large])
            .padding()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        isShowingCertificationAddSheet.toggle()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("완료") {
                        let newCertification = Experience(
                            title: certificationTitle,
                            period: certificationPeriod,
                            description: certificationDescription
                        )
                        
                        myPageStore.userCv.certifications?.append(newCertification)
                        myPageStore.addUpdateCVData()
                        
                        certificationTitle = ""
                        certificationStartDate = Date()
                        certificationEndDate = Date()
                        certificationDescription = ""
                        
                        isShowingCertificationAddSheet.toggle()
                    }
                    .disabled(
                        certificationTitle.isEmpty || certificationDescription.isEmpty
                    )
                }
            }
            
            Spacer()
        }
    }
}

struct CertificationAddSheet_Previews: PreviewProvider {
    static var previews: some View {
        CertificationAddSheet(
            myPageStore: MyPageStore(),
            isShowingCertificationAddSheet: .constant(true),
            certificationTitle: .constant(""),
            certificationStartDate: .constant(Date()),
            certificationEndDate: .constant(Date()),
            certificationDescription: .constant("")
        )
    }
}
