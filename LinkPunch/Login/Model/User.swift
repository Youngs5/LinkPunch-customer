//
//  User.swift
//  LinkPunch
//
//  Created by 최하늘 on 2023/08/23.
//

import Foundation

struct User: Identifiable, Codable {
    var isDeviceDuplicateCheck: Bool = false
    var userNickName: String? //닉네임
    var name: String? //이름
    var signUpDate: String? //가입날짜 생성
    
    var userEmail: String? //로그인용 이메일
    var userPwd: String? //비밀번호
    var userImage: String? // 프사
    var social: Social?

    var education: [Education]?
    var location: [String]?  // 선호지역이라 여러곳을 작성
    var fields: [String]? // 관심분야

    var report: Report?  //신고 관련 struct
    var id : String {
        userEmail ?? ""
    }

    var cv: CV?
    
    var userReport: [UserReport]?
    enum CodingKeys: CodingKey {
        case userNickName
        case name
        case signUpDate
        case userEmail
        case userPwd
        case userImage
        case social
        case education
        case location
        case fields
        case report
        case cv
        case userReport
    }
}

enum Social: String, Codable {
    case none
    case apple
    case google
    case kakao
}

struct Education: Identifiable, Codable {
    var id: String = UUID().uuidString
    var school: String  // 학교
    var status: String // 상태 ( 재학, 졸업, 수료 등) 
    var major: String // 전공
    var admissionYear: String
    var graduateYear: String
    enum CodingKeys: CodingKey {
        case school
        case status
        case major
        case admissionYear
        case graduateYear
    }
}

// 신고 관련 struct
struct Report: Codable {
    var isStopped: Bool = false //정지여부
    var isDeleted: Bool = false // 삭제여부
    var suspensionDate : String? //정지날짜
    var stopCount: Int = 0 //정지횟수 
    var reportedCount: ReportCount
}

// 활동 내역 struct
struct Experience: Identifiable, Codable { //CV 예상
    var id: String = UUID().uuidString
    var title: String
    var period: String
    var description: String
}

// 이력서 정보 struct
struct CV: Codable {
    var shortIntroduce: String? //(짧게 나타내는 한줄 자기소개)
    
    var projects: [Experience]?    // 프로젝트
    var activities: [Experience]?     //활동
    var certifications: [Experience]?   //자격증
    
    //임시데이터
//    var projects: [Experience] = [
//        Experience(title: "LinkPunch", period: "2023.08. ~ Present.", description: "CV를 공유하는 어플리케이션 개발 프로젝트")
//    ]
//    var activities: [Experience] = [
//        Experience(title: "멋쟁이 사자처럼", period: "2023.05. ~ Present.", description: "iOS 앱개발 기초 교육 및 프로젝트 진행")
//    ]
//    var certifications: [Experience] = [
//        Experience(title: "정보처리기능사", period: "2023.05.12. 취득", description: "정보처리기능사")
//    ]

}

