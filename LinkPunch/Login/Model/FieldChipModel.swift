//
//  ChipModel.swift
//  LinkPunch
//
//  Created by 나예슬 on 2023/08/23.
//

import Foundation
import SwiftUI

struct FieldChipModel: Identifiable {
    var isSelected: Bool
    let id = UUID()
    //let systemImage: String
    let titleKey: String
    //    let titleKey: LocalizedStringKey
}

class ChipsViewModel: ObservableObject {
    @Published var chipArray: [FieldChipModel] = [
        FieldChipModel(isSelected: false, titleKey: "Frontend"),
        FieldChipModel(isSelected: false, titleKey: "Backend"),
        FieldChipModel(isSelected: false, titleKey: "AI"),
        FieldChipModel(isSelected: false, titleKey: "Mobile"),
        FieldChipModel(isSelected: false, titleKey: "Game"),
        FieldChipModel(isSelected: false, titleKey: "Graphic"),
        FieldChipModel(isSelected: false, titleKey: "ETC"),
    ]
}
