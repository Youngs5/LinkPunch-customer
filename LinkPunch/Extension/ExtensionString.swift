//
//  ExtensionString.swift
//  LinkPunch
//
//  Created by 박채영 on 2023/08/30.
//

import SwiftUI

extension String {
    func stringToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM."
        return dateFormatter.date(from: self) ?? Date()
    }
}
