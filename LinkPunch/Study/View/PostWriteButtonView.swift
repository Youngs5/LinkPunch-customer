//
//  PostWriteButtonView.swift
//  LinkPunch
//
//  Created by 유하은 on 2023/08/25.
//

import SwiftUI

struct PostWriteButtonView: View {
    var body: some View {
        ZStack{
            Rectangle()
                .frame(width: 80, height: 34)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 10)
            Text("모집하기")
                .bold()
                .font(.system(size:14))
        }
    }
}

struct PostWriteButtonView_Previews: PreviewProvider {
    static var previews: some View {
        PostWriteButtonView()
    }
}
