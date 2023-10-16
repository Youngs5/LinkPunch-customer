//
//  ExtensionDate.swift
//  LinkPunch
//
//  Created by 최하늘 on 2023/08/23.
//

import Foundation

extension Date {
    func dateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        return dateFormatter.string(from: self)
    }
    
    func dateToStringForMyPage() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM."

        return dateFormatter.string(from: self)
    }
    
    func dateToStringWithTime() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" // 원하는 서식으로 설정
            
            return dateFormatter.string(from: self)
        }

}
