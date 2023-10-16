//
//  ReportView.swift
//  LinkPunch
//
//  Created by 박성훈 on 2023/08/22.
//

import SwiftUI

struct ReportView: View {
    // 포커스필드를 위한 열거형
    enum Field: Hashable {
        case reasonForReporting
    }
    
    @FocusState private var focusedField: Field?
    @State var isShowingAlert: Bool = false
    @ObservedObject var reportStore: ReportStore = ReportStore()
    @State var reportReasons: [ReportCase] = ReportCase.allCases //
    @State var reportSet: [ReportCase] = []
    @State var etcDetailReason: String = ""
    @State private var selectedToggle: [Bool] = Array(repeating: false, count: ReportCase.allCases.count)
    @Binding var isShowReportView: Bool
    @Binding var postData: StudyRecruitment
    
    private let placeholder: String = "신고 사유를 입력해주세요."
    private let limitChar: Int = 100
    @State private var notSelected: Bool = true
    
    @State private var isSelectedEtc: Bool = false
    
    
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                // 모든 VStack에 leading을 주기 휘함
                VStack(alignment: .leading) {
                    Divider()
                        .opacity(0)
                    
                    Text("이 게시물을 신고하는 이유")
                        .padding(.top)
                    Text("지식재산권 침해를 신고하는 경우를 제외하고 회원님의 신고는 익명으로 처리됩니다. 누군가 위급한 상황에 있다고 생각된다면 즉시 현지 응급 서비스 기관에 연락하시기를 바랍니다.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.bottom)
                    
                    //selectedToggle = index
                    
                    //ReportStore.reportCase에 toggle true인 값만 append하면 됨.
                    ForEach(ReportCase.allCases.indices) { index in
                        Toggle(isOn: $selectedToggle[index]) {
                            Text(ReportCase.allCases[index].rawValue)
                        }
                        .foregroundColor(.black)
                        .toggleStyle(iOSCheckboxToggleStyle(selectedToggle: $selectedToggle, notSelected: $notSelected))
                        
                        Divider()
                    }
                    
                    .onChange(of: selectedToggle[ReportCase.allCases.count - 1], perform: { newValue in
                        isSelectedEtc.toggle()
                        etcDetailReason = ""
                    })
                    .padding(.vertical, 3)
                    
                    // TextEditor 부분
                    if isSelectedEtc {
                        ZStack(alignment: .topLeading) {
                            // placeholder 구현
                            if etcDetailReason.isEmpty {
                                Text(placeholder)
                                    .lineSpacing(10)
                                    .foregroundColor(Color.primary.opacity(0.25))
                                    .padding(.top, 10)
                                    .padding(.leading, 10)
                                    .zIndex(1)
                                    .onTapGesture {
                                            self.focusedField = .reasonForReporting
                                    }
                            }
                            
                            // 텍스트 에디터
                            VStack {
                                TextEditor(text: $etcDetailReason)
                                    .keyboardType(.default)
                                    .foregroundColor(Color.black)
                                    .frame(height: 150)
                                    .lineSpacing(10)
                                    .focused($focusedField, equals: .reasonForReporting)
                                // 글자 수 제한
                                    .onChange(of: self.etcDetailReason, perform: {
                                        if $0.count > limitChar {
                                            self.etcDetailReason = String($0.prefix(limitChar))
                                        }
                                    })
                                // 텍스트에디터를 다시 누르면 키보드 내려가게 함
                                    .onTapGesture {
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    }
                                
                                VStack(alignment: .trailing) {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Text("\(etcDetailReason.count) / \(limitChar)")
                                    }
                                }
                                .padding()  // Text를 떨어뜨리기 위함
                            }
                            .border(.secondary)
                        }  // ZStack
                    }
                }  // VStack
                .padding(.horizontal)
                
            }
            Spacer()
            /*
             selectedToggle[index] 가 true 경우 그 인덱스를 가져와서
             reportReason[index] 얘를 append해서 보내 .
             */
            
            Button(role: .destructive) {
                isShowingAlert = true
            } label: {
                Text("신고하기")
                    .font(.title2)
            }
            .padding(.bottom)
            .disabled(notSelected)
            .alert(isPresented: $isShowingAlert) {
                // Handle alert presentation
                Alert(title: Text("알림"), message: Text("신고하시겠습니까?"), primaryButton:
                        .destructive(Text("신고"), action: {
                            for index in 0..<ReportCase.allCases.count {
                                if selectedToggle[index]  {
                                    reportSet.append(reportReasons[index])
                                }
                            }
                            
                            isShowReportView.toggle()
                            
                            if let userEmail = UserDefaultsData.shared.getUserEmail() {
                                reportStore.addStudyReport(
                                    postData: postData,
                                    postReport:
                                        PostReport(
                                            reportedBy: userEmail,
                                            reportedDate: Date().dateToStringWithTime(),
                                            reportcase: reportSet,
                                            reportReason: etcDetailReason)
                                )
                            }
                            
                        }), secondaryButton: .cancel(Text("취소")))
                
            }
            .navigationTitle("신고")
            .navigationBarTitleDisplayMode(.inline)
        } // NavigationStack
        
    }
    
    fileprivate func showTextEditor(index: Int) {
        if ReportCase.allCases.count - 1 == index {
            isShowReportView.toggle()
        }
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView(isShowReportView: .constant(true), postData: .constant(studyTestData))
    }
}


