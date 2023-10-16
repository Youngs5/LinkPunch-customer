//
//  FavFieldsEditSectionView.swift
//  LinkPunch
//
//  Created by 박채영 on 2023/08/23.
//

import SwiftUI
import SwiftUIFlowLayout

struct FavFieldsEditSectionView: View {
    @StateObject var myPageStore: MyPageStore
    @Binding var selectedFields: [String]
    
    let fieldItems = ["Frontend", "Backend", "AI", "Mobile", "Game", "Graphic", "Etc"]
    
    var body: some View {
        Section {
            HStack {
                FlowLayout(mode: .scrollable, items: fieldItems, itemSpacing: 5) { data in
                    FieldView(myPageStore: myPageStore, selectedFields: $selectedFields, isSelected: selectedFields.contains(data), title: data)
                }
                Spacer()
            }
            .padding([.bottom, .leading, .trailing], 20)
            .onAppear {
                selectedFields = myPageStore.updateUser.fields ?? []
            }
        } header: {
            HStack {
                Text("관심 분야")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading, 20)
                Spacer()
            }
        }
    }
}

struct FieldView: View {
    @StateObject var myPageStore: MyPageStore
    @Binding var selectedFields: [String]
    @State var isSelected: Bool
    var title: String
    
    var body: some View {
        Button {
            isSelected.toggle()
            if isSelected {
                selectedFields.append(title)
            } else {
                selectedFields.removeAll(where: {$0 == title})
            }
        } label: {
            Text(title)
                .font(.body).bold()
                .foregroundColor(isSelected ? .white : .subColor)
                .padding([.leading, .trailing], 12)
                .padding([.top, .bottom], 7)
                .background(isSelected ? Color.subColor : .white)
                .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.subColor, lineWidth: 3.5)
                    )
                .cornerRadius(20)
        }
    }
}

struct FavFieldsEditSectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FavFieldsEditSectionView(myPageStore: MyPageStore(), selectedFields: .constant([]))
        }
    }
}
