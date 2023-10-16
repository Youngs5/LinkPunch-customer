//
//  BadgeView.swift
//  LinkPunch
//
//  Created by 박채영 on 2023/08/22.
//

import SwiftUI

struct BadgeView: View {
    var text: String
    var fillColor: Color
    var textColor: Color
    
    var body: some View {
        ZStack {
            Capsule(style: .circular)
                .fill(fillColor)
                .frame(height: 26)
            Text(text)
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundColor(textColor)
                .padding([.leading, .trailing])
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}

struct BadgeView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeView(text: "매일 잔디 심는 개발자✨", fillColor: .black, textColor: .white)
    }
}
