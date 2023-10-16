//
//  EditEducationBoxView.swift
//  LinkPunch
//
//  Created by 박채영 on 2023/08/29.
//

import SwiftUI

struct EditEducationBoxView: View {
    @StateObject var myPageStore: MyPageStore

    var education: Education
    
    @Binding var isDeleteButtonTapped: Bool
    @Binding var isEditButtonTapped: Bool
    @Binding var selectedItemId: String
    
    var educationPeriod: String {
        get {
            let startDateString = education.admissionYear
            let endDateString = education.graduateYear
            return "\(startDateString) ~ \(endDateString)"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(education.school)")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                Text("\(educationPeriod)")
                    .foregroundColor(.gray)
                
                Menu {
                    Button {
                        isEditButtonTapped.toggle()
                        selectedItemId = education.id
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive) {
                        isDeleteButtonTapped.toggle()
                        selectedItemId = education.id
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
                .foregroundColor(.black)
            }
            .padding()
            
            Text("\(education.major) \(education.status)")
                .padding([.leading, .trailing, .bottom])
        }
        .background(Color(white: 0.9))
    }
}

struct EditEducationBoxView_Previews: PreviewProvider {
    static var previews: some View {
        EditEducationBoxView(
            myPageStore: MyPageStore(),
            education: Education(
                school: "테킷대학교",
                status: "수료",
                major: "컴퓨터공학전공",
                admissionYear: Date().dateToStringForMyPage(),
                graduateYear: Date().dateToStringForMyPage()),
            isDeleteButtonTapped: .constant(false),
            isEditButtonTapped: .constant(false),
            selectedItemId: .constant("")
        )
    }
}
