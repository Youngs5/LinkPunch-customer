//
//  EditExperienceBoxView.swift
//  LinkPunch
//
//  Created by 박채영 on 2023/08/29.
//

import SwiftUI

struct EditExperienceBoxView: View {
    @StateObject var myPageStore: MyPageStore

    var experience: Experience
    
    @Binding var isDeleteButtonTapped: Bool
    @Binding var isEditButtonTapped: Bool
    @Binding var selectedItemId: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(experience.title)")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                Text("\(experience.period)")
                    .foregroundColor(.gray)
                
                Menu {
                    Button {
                        selectedItemId = experience.id
                        isEditButtonTapped.toggle()
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive) {
                        selectedItemId = experience.id
                        isDeleteButtonTapped.toggle()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
                .foregroundColor(.black)
            }
            .padding()
            
            Text("\(experience.description)")
                .padding([.bottom, .leading, .trailing])
        }
        .background(Color(white: 0.9))
    }
}

struct EditExperienceBoxView_Previews: PreviewProvider {
    static var previews: some View {
        EditExperienceBoxView(
            myPageStore: MyPageStore(),
            experience: Experience(
                title: "LinkPunch",
                period: "2023.08. ~ Present.",
                description: "CV를 공유하는 어플리케이션 개발 프로젝트"),
            isDeleteButtonTapped: .constant(false),
            isEditButtonTapped: .constant(false),
            selectedItemId: .constant("")
        )
    }
}
