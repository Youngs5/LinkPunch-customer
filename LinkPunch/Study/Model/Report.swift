//
//  Report.swift
//  LinkPunch
//
//  Created by 박성훈 on 2023/08/22.
//

import Foundation

struct PostReport: Codable, Identifiable {
    var id: String = UUID().uuidString
    var reportedBy: String // 신고자 이메일
    var reportedDate: String  // 신고한 날짜
    var reportcase: [ReportCase] // 신고사유 중복가능
    var reportReason: String = "" // enum에 etc 기타사유가 작성
}


struct ReportCountInfo: Codable {
    var isHiddened: Bool
    var unrelatedCount: Int //관련없는 글
    var spamFlaggingCount: Int//스팸
    var obscenityCount: Int // 음란물
    var offensiveLanguageCount: Int //불쾌한 표현
    var etcCount: Int //기타
    
    var total: Int {
    unrelatedCount + spamFlaggingCount + obscenityCount + offensiveLanguageCount + etcCount
    }
}


// 관련 없는 글, 스팸/도배 글, 음란물, 불쾌한 표현, 기타(선택 시 textField)
enum ReportCase: String, CaseIterable, Codable {
    case unrelated = "관련 없는 글" // 관련 없는 글
    case spamFlagging = "스팸/도배 글"  // 스팸/도배 글
    case obscenity = "음란물" // 음란물
    case offensiveLanguage = "불쾌한 표현"  // 불쾌한 표현
    case etc = "기타 사유"  // 기타(선택 시 textField)
}
