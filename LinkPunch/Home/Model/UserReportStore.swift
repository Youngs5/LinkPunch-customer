//
//  UserReportStore.swift
//  LinkPunch
//
//  Created by 최세근 on 2023/08/23.
//

import SwiftUI
import Firebase

class UserReportStore: ObservableObject {
    @Published var userReport: UserReport
    @Published var userReports: [UserReport] = []
    let userDefaultsEmail = UserDefaultsData.shared.getUserEmail()
    let userDefaultsNickname = UserDefaultsData.shared.getUserNickName()
    let dataBase = Firestore.firestore()
    
    init() {
        userReport = UserReport(reporterNickname: userDefaultsNickname ?? "", reporterEmail: userDefaultsEmail ?? "", reportDateString: "", userReportedReason: [], ReportedReasonDetail: "")
    }
    
    
    func reportUser(_ userReportSet: [UserRepoertedReason], _ ReportedReasonDetail: String, _ reportedUser: User) {
        var newReport = UserReport(
            reporterNickname: userDefaultsNickname ?? "",
            reporterEmail: userDefaultsEmail ?? "",
            reportDateString: "",
            userReportedReason: [],
            ReportedReasonDetail: ""
        )
        
        newReport.userReportedReason = userReportSet
        newReport.ReportedReasonDetail = ReportedReasonDetail
        
        let todayDate = Date()
        newReport.reportDateString = todayDate.dateToString()
        
        addToFirebaseReport(reportedUser, newReport)
        checkReportCount(reportedUser, newReport)
    }
    
    func checkReportCount(_ reportedUser: User, _ newReport: UserReport) {
        guard var reportedUserReport = reportedUser.report else { return }

        for userReportCase in newReport.userReportedReason {
            switch userReportCase {
            case .impersonation:
                reportedUserReport.reportedCount.impersonationCount += 1
            case .fakeAccount:
                reportedUserReport.reportedCount.fakeAccountCount += 1
            case .fakeCV:
                reportedUserReport.reportedCount.fakeCVCount += 1
            case .offensive:
                reportedUserReport.reportedCount.offensiveCount += 1
            case .extra:
                reportedUserReport.reportedCount.extraCount += 1
            }
        }
        reportedUserReport.reportedCount.total += 1
        
        addToFirebaseReportCount(reportedUser, reportedUserReport)
    } 
    
    func addToFirebaseReport(_ reportedUser: User, _ newReport: UserReport) {
        
        if let userEmail = reportedUser.userEmail {
            dataBase.collection("users").document(userEmail).getDocument { document, error in
                if let error = error {
                    print(error)
                } else if let document = document, document.exists {
                    var userReports = document.data()?["userReports"] as? [[String: Any]] ?? []
                    
                    let userReport = newReport.asDictionary()
                    
                    userReports.append(userReport)
                    
                    self.dataBase.collection("users").document(userEmail).updateData([
                        "userReports": userReports
                    ]) { error in
                        if let error = error {
                            print(error)
                        } else {
                            print("유저 신고했당")
                        }
                    }
                }
            }
        }
    }
    
    func addToFirebaseReportCount(_ reportedUser: User, _ reportedUserReport: Report) {
        
        if let userEmail = reportedUser.userEmail {
            dataBase.collection("users").document(userEmail).updateData([
                "report": reportedUserReport.asDictionary()
            ]) { error in
                if let error = error {
                    print(error)
                } else {
                    print("유저 리포트 업데이트")
                }
            }
        }
    }
}

struct CheckToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            
            configuration.isOn.toggle()
            
        }, label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                //                    .font(.title)
                //                    .foregroundColor(Color.subColor) 컬러 우선 뺌// 통일성
                configuration.label
            }
        })
    }
}

