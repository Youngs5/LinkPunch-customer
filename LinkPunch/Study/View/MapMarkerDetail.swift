//
//  MapMarkerDetail.swift
//  LinkPunch
//
//  Created by 김상규 on 2023/08/31.
//

import SwiftUI

struct MapMarkerDetail: View {
    var body: some View {
        VStack {
            Image(systemName: "mappin")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .font(.headline)
                .foregroundColor(.white)
                .padding(6)
                .background(Color.systemColor)
                .cornerRadius(40)
            
            Image(systemName: "triangle.fill")
                .resizable()
                .foregroundColor(.systemColor)
                .frame(width: 11, height: 14)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -14)
                .padding(.bottom, 40)
        }
    }
}

struct MapMarkerDetail_Previews: PreviewProvider {
    static var previews: some View {
        MapMarkerDetail()
    }
}
