//
//  LocationAddView.swift
//  LinkPunch
//
//  Created by 나예슬 on 2023/08/24.
//

import SwiftUI

struct LocationAddView: View {
    
    var locationModel: LocationModel
    let location: LocationData
    
    var body: some View {
        HStack {
            Text("\(location.selectedCityName)")
            Text("\(location.selectedCityStateName)")
            
            Spacer()
            
            Button {
                locationModel.removeLocation(location)
            } label: {
                Image(systemName: "x.circle")
                    .foregroundColor(.black)
            }

        }
    }
}

struct LocationAddView_Previews: PreviewProvider {
    static var previews: some View {
        LocationAddView(locationModel: LocationModel(), location: LocationData(selectedCityName: "서울특별시", selectedCityStateName: "강남구"))
    }
}
