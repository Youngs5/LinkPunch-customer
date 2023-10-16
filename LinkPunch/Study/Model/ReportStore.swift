//
//  ReportStore.swift
//  LinkPunch
//
//  Created by 유하은 on 2023/08/22.
//

import Foundation
import FirebaseFirestore

class ReportStore: ObservableObject {
    
    
    init(){
        
    }
    
    
    
    func addStudyReport(postData: StudyRecruitment, postReport: PostReport) {
        
        //신고 케이스 카운트
        guard let repostCountInfo = postData.reportCountInfo else { return }
        var newCountInfo = ReportCountInfo(isHiddened: false,
                                           unrelatedCount: repostCountInfo.unrelatedCount,
                                           spamFlaggingCount: repostCountInfo.spamFlaggingCount,
                                           obscenityCount: repostCountInfo.obscenityCount,
                                           offensiveLanguageCount: repostCountInfo.offensiveLanguageCount,
                                           etcCount: repostCountInfo.etcCount
        )
        for reportCase in postReport.reportcase {
            switch reportCase {
            case .unrelated:
                newCountInfo.unrelatedCount += 1
            case .spamFlagging:
                newCountInfo.spamFlaggingCount += 1
            case .obscenity:
                newCountInfo.obscenityCount += 1
            case .offensiveLanguage:
                newCountInfo.offensiveLanguageCount += 1
            case .etc:
                newCountInfo.etcCount += 1
            }
            if newCountInfo.unrelatedCount > 2 || newCountInfo.spamFlaggingCount > 2 || newCountInfo.obscenityCount > 2 || newCountInfo.offensiveLanguageCount > 2 || newCountInfo.etcCount > 2 {
                newCountInfo.isHiddened = true
            }
        }
        
        //신고내역
        var newPostReport: [PostReport] = postData.postReport ?? []
        newPostReport.append(postReport)
        
        let db = Firestore.firestore()
        let documentRef = db.collection("studies").document(postData.id)
        
        documentRef.updateData([
            "postReport": newPostReport.map { $0.asDictionary() },
            "reportCountInfo": newCountInfo.asDictionary()
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}
