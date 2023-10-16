//
//  ExperienceBoxView.swift
//  LinkPunch
//
//  Created by 박채영 on 2023/08/22.
//

import SwiftUI

struct ExperienceBoxView: View {
    var experience: Experience
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(experience.title)")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                Text("\(experience.period)")
                    .foregroundColor(.gray)
            }
            .padding()
            
            Text("\(experience.description)")
                .padding([.bottom, .leading, .trailing])
        }
        .background(Color(white: 0.9))
    }
}

struct ExperienceBoxView_Previews: PreviewProvider {
    static var previews: some View {
        ExperienceBoxView(
            experience: Experience(
                title: "LinkPunch",
                period: "2023.08. ~ Present.",
                description: "CV를 공유하는 어플리케이션 개발 프로젝트")
        )
    }
}
