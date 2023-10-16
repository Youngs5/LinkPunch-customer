//
//  UserReport.swift
//  LinkPunch
//
//  Created by 최세근 on 2023/08/23.
//

import Foundation

struct UserReport: Codable {
    var id: String = UUID().uuidString
    var reporterNickname: String //신고자
    var reporterEmail: String // 신고자 이메일
    var reportDateString: String // 신고 일자
    var userReportedReason: [UserRepoertedReason] //신고 사유
    var ReportedReasonDetail: String // 기타일 경우
}


enum UserRepoertedReason: String, CaseIterable, Codable {
    case impersonation = "사칭 계정"  // 사칭 계정
    case fakeAccount = "허위 계정"  // 허위 계정
    case fakeCV = "CV 허위"  // CV 허위
    case offensive = "불쾌한 사적 연락"  // 불쾌한 사적 연락
    case extra = "기타"  //기타 -> textField로 연결
}

struct ReportCount: Codable {
    //사칭계정 신고 카운트
    var impersonationCount: Int = 0

    //허위계정 신고 카운트
    var fakeAccountCount: Int = 0
    //허위CV 신고 카운트
    var fakeCVCount: Int = 0
    //불쾌한 사적연락 신고 카운트
    var offensiveCount: Int = 0
    //기타 신고 카운트
    var extraCount: Int = 0
    
    var total: Int = 0
}
