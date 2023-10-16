//
//  StudyRecruitment.swift
//  LinkPunch
//
//  Created by 유하은 on 2023/08/22.
//
import Foundation
import SwiftUI
import CoreLocation
import MapKit

// 게시글 관련 구조체
struct StudyRecruitment: Identifiable, Codable {
    var id: String = UUID().uuidString
    var endDate: String
    var createdAt: Double = Date().timeIntervalSince1970
    var field: FieldType
    var location: StudyLocation
    var userName: String // 유저 네임          // 수정 필요, -> publisher가 있는데 있을 필요가 없음
    var userImgString: String // 유저 이미지    // 수정 필요, -> publisher가 있는데 있을 필요가 없음
    var title: String
    var contents: String
    var applicantCount: Int
    var nowApplicant: Int

//    var reportCount: Int  //신고횟수 추가
    var publisher: User         // 게시글 작성자   // 옵셔널인 이유..?
    var participants: [User]    // 스터디 참여자
    
    var postReport: [PostReport]?         //신고 관련 Struct
    var reportCountInfo: ReportCountInfo?  //신고 카운트 struct
    var createdDate: String {
        let dateCreatedAt: Date = Date(timeIntervalSince1970: createdAt)
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "MM월dd일 HH:mm"
        return dateFormatter.string(from: dateCreatedAt)
    }
    
    var createdDateWithHour: Date {
       let dateCreatedAt: Date = Date(timeIntervalSince1970: createdAt)
       
       let dateFormatter: DateFormatter = DateFormatter()
       dateFormatter.locale = Locale(identifier: "ko_kr")
       dateFormatter.timeZone = TimeZone(abbreviation: "KST")
       dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
       
       let dateString: String = dateFormatter.string(from: dateCreatedAt)
       return dateFormatter.date(from: dateString) ?? Date()
   }
    
    var userImg: Image {
        Image(systemName: userImgString)
    }
}
enum FieldType: String, CaseIterable, Identifiable, Codable {
    
    case All
    case Frontend
    case Backend
    case AI
    case Mobile
    case Game
    case Graphic
    case Etc
    
    var id: String { self.rawValue }
    
}

extension StudyRecruitment {
    
}

struct Location: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}


struct StudyLocation: Identifiable, Codable {
    var id: UUID = UUID()
    let latitude: Double // 위도
    let longitude: Double // 경도
    let address: String // 주소
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }
    class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
        private let locationManager = CLLocationManager()
        @Published var location: CLLocation?
        
        override init() {
            super.init()
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            location = locations.last
        }
    }
}
