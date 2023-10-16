//
//  LocationModel.swift
//  LinkPunch
//
//  Created by 나예슬 on 2023/08/23.
//

import Foundation
import SwiftUI

struct LocationData: Identifiable {
    var id: UUID = UUID()
    var selectedCityName: String
    var selectedCityStateName: String
}

class LocationModel: ObservableObject {
    @Published var locations: [LocationData] = []
    
    init() {
        locations = [
            
        ]
    }
    
    func addLocation(selectedCityName: String, selectedCityStateName: String) {
        let location = LocationData(selectedCityName: selectedCityName, selectedCityStateName: selectedCityStateName)
        
        locations.insert(location, at:0)
    }
    
    func removeLocation(_ location: LocationData) {
        var index: Int = 0
        
        for tempLocation in locations {
            
            if tempLocation.id == location.id {
                locations.remove(at: index)
                break
            }
            index += 1
        }
    }
}
