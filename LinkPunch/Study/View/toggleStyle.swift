//
//  toggleStyle.swift
//  LinkPunch
//
//  Created by 유하은 on 2023/08/22.
//

import Foundation
import SwiftUI

struct iOSCheckboxToggleStyle: ToggleStyle {
    //@Binding private var reportReasons: Bool
    @Binding var selectedToggle: [Bool]
    @Binding var notSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        // 1
        Button {
            // 2
            configuration.isOn.toggle()
            
            if selectedToggle.contains(true) {
                notSelected = false
            } else {
                notSelected = true
            }
        } label: {
            HStack {
                // 3
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                configuration.label
            }
        }
        
    }
}
