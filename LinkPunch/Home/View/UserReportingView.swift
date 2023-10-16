//
//  UserReportingView.swift
//  LinkPunch
//
//  Created by 최세근 on 2023/08/22.
//
import SwiftUI

struct UserReportingView: View {
    
    @StateObject var userReport: UserReportStore = UserReportStore()
    
    @State private var userReportSet: [UserRepoertedReason] = []
    @State private var userReportReasons: [UserRepoertedReason] = UserRepoertedReason.allCases
    @State private var userSelectedToggle: [Bool] = Array(repeating: false, count: UserRepoertedReason.allCases.count)
    @State var userPostData: User
    @State private var reportIndex: Int = 0
    @State private var elseReport: String = ""
    @State private var userReporterNickname: String = ""
    @State private var isShowUserAlert: Bool = false
    @Binding var isShowingReportView: Bool
    @State private var canNotReport: Bool = false
    
    let user: User
    
    //
    private let userplaceholder: String = "자세한 신고 사유를 입력해주세요."
    private let userlimitChar: Int = 100
    // 스터디 쪽과 통합
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("이 계정에 대해 무엇을 신고하려고 하시나요?")
                    .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 25))
                    .font(.system(size: 19, weight: .bold))
            }
            List {
                ForEach(Array(UserRepoertedReason.allCases.indices), id: \.self) { index in
                    Toggle(isOn: $userSelectedToggle[index]) {
                        Text(UserRepoertedReason.allCases[index].rawValue)
                    }
                    .toggleStyle(CheckToggleStyle())
                }
                
                if userSelectedToggle[UserRepoertedReason.allCases.count - 1] {
                    Text("문제에 대해 자세히 알려주세요.")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top)
                    
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $elseReport)
                            .keyboardType(.default)
                            .foregroundColor(Color.black)
                            .frame(height: 200)
                            .lineSpacing(10)
                            .shadow(radius: 2.0)
                            .onChange(of: self.elseReport, perform: {
                                if $0.count > userlimitChar {
                                    self.elseReport = String($0.prefix(userlimitChar))
                                }
                            })
                        
                            .onTapGesture {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                        
                        VStack(alignment: .trailing) {
                            Spacer()
                            HStack {
                                Spacer()
                                Text("\(elseReport.count) / \(userlimitChar)")
                                    .padding(.bottom)
                            }
                        }
                        .padding()
                        
                        if elseReport.isEmpty {
                            Text(userplaceholder)
                                .lineSpacing(10)
                                .foregroundColor(Color.primary.opacity(0.25))
                                .padding(.top, 10)
                                .padding(.leading, 10)
                        }
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .font(.title3)
            .listStyle(.plain)
            
            Button(role: .destructive) {
                isShowUserAlert = true
            } label: {
                Text("신고 제출")
                    .font(.title2)
            }
            .padding(.bottom)
            .disabled(!userSelectedToggle.contains(true))
            .alert(isPresented: $isShowUserAlert) {
                
                if canNotReport {
                    return Alert(title: Text("알림"), message: Text("이미 신고하셨습니다."), dismissButton: .cancel(Text("확인")))
                } else {
                    return Alert(
                        title: Text("사용자 신고"),
                        message: Text("이 계정을 신고합니다."), primaryButton:
                                .destructive(Text("신고하기"), action: {
                                    // report가 제출된 후 더 이상 추가되지 않도록 방지
                                    // canNotReport Bool타입 변수 추가
                                    
                                    canNotReport = true
                                    
                                    ///신고 내용 전달
                                    addUserReport()
                                    
                                    userReport.reportUser(userReportSet, elseReport, user)
                                    
                                    // 바로 toggle하면 추가 신고 방지를 할 수 없음
                                    isShowingReportView.toggle()
                                    
                                    if let reportUserEmail = UserDefaultsData.shared.getUserEmail() {
                                        userReport.addToFirebaseReport(
                                            userPostData,
                                            UserReport(
                                                reporterNickname: userReporterNickname,
                                                reporterEmail: reportUserEmail,
                                                reportDateString:
                                                    Date().dateToStringWithTime(),
                                                userReportedReason: userReportSet,
                                                ReportedReasonDetail: elseReport)
                                        
                                        )
                                    }
                                    
                                    
                                }), secondaryButton: .cancel(Text("취소")))
                }
            }
            .navigationTitle("사용자 신고")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingReportView.toggle()
                    } label: {
                        Text("취소")
                    }
                }
            }
        } // NavigationStack
    } // body
    
    private func addUserReport() {
        for index in 0..<UserRepoertedReason.allCases.count {
            if userSelectedToggle[index] {
                userReportSet.append(userReportReasons[index])
            }
        }
    }
    
    fileprivate func showUserTextEditor(index: Int) {
        if UserRepoertedReason.allCases.count - 1 == index {
            isShowingReportView.toggle()
        }
    }
    
    
}

struct UserReportingView_Previews: PreviewProvider {
    static var previews: some View {
        UserReportingView(userPostData: User(), isShowingReportView: .constant(true), user: User())
    }
}
