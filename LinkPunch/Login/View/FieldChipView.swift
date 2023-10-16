//
//  TestView.swift
//  LinkPunch
//
//  Created by 나예슬 on 2023/08/23.
//

import SwiftUI

struct FieldChipView: View {
    
    //let systemImage: String
//    let titleKey: LocalizedStringKey
     @Binding var fieldChipModel : FieldChipModel
    var body: some View {
        HStack(spacing: 4) {
                //Image.init(systemName: systemImage).font(.body)
            Text(fieldChipModel.titleKey).font(.body).lineLimit(1)
            }
            .padding(.vertical, 4)
            .padding(.leading, 10)
            .padding(.trailing, 10)
            .foregroundColor(fieldChipModel.isSelected ? .white : .blue)
            .background(fieldChipModel.isSelected ? Color.blue : Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.blue, lineWidth: 1.5)
                
            ).onTapGesture {
                fieldChipModel.isSelected.toggle()
            }
            }
}

//struct FieldChipView_Previews: PreviewProvider {
//    static var previews: some View {
//        FieldChipView(titleKey: "Frontend", isSelected: false)
//    }
//}
