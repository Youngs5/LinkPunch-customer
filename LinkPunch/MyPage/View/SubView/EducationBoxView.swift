//
//  EducationBoxView.swift
//  LinkPunch
//
//  Created by 박채영 on 2023/08/28.
//

import SwiftUI

struct EducationBoxView: View {
    var education: Education
    
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
            }
            .padding()
            
            Text("\(education.major) \(education.status)")
                .padding([.leading, .trailing, .bottom])
        }
        .background(Color(white: 0.9))
    }
}

struct EducationBoxView_Previews: PreviewProvider {
    static var previews: some View {
        EducationBoxView(
            education: Education(
                school: "테킷대학교",
                status: "수료",
                major: "컴퓨터공학전공",
                admissionYear: Date().dateToStringForMyPage(),
                graduateYear: Date().dateToStringForMyPage())
        )
    }
}
