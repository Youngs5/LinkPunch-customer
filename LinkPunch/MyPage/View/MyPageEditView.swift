//
//  MyPageEditView.swift
//  LinkPunch
//
//  Created by 박채영 on 2023/08/23.
//

import SwiftUI

struct MyPageEditView: View {
    @StateObject var myPageStore: MyPageStore
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var editedNickName: String = ""
    @State var editedName: String = ""
    @State var editedEmail: String = ""
    @State var editedShortIntroduce: String = ""
    @State var editedLocation: [String] = []
    @State var editedFields: [String] = []
    @State var editedProjects: [Experience] = []
    @State var editedActivities: [Experience] = []
    @State var editedCertifications: [Experience] = []
    
    @State var isShowingProjectAddSheet: Bool = false
    @State var isShowingActivityAddSheet: Bool = false
    @State var isShowingCertificationAddSheet: Bool = false
    @State var isShowingEducationAddSheet: Bool = false
    
    @State var isShowingProjectEditSheet: Bool = false
    @State var isShowingActivityEditSheet: Bool = false
    @State var isShowingCertificationEditSheet: Bool = false
    @State var isShowingEducationEditSheet: Bool = false
    
    @State var projectTitle: String = ""
    @State var projectStartDate: Date = Date()
    @State var projectEndDate: Date = Date()
    @State var projectDescription: String = ""
    
    @State var activityTitle: String = ""
    @State var activityStartDate: Date = Date()
    @State var activityEndDate: Date = Date()
    @State var activityDescription: String = ""
    
    @State var certificationTitle: String = ""
    @State var certificationStartDate: Date = Date()
    @State var certificationEndDate: Date = Date()
    @State var certificationDescription: String = ""
    
    @State var educationSchool: String = ""
    @State var educationStatus: String = ""
    @State var educationMajor: String = ""
    @State var admissionYear: Date = Date()
    @State var graduateYear: Date = Date()
    
    @State var editedItemId: String = ""
    @State var editedItem: Experience = Experience(title: "", period: "", description: "")
    
    @State var editedProjectTitle: String = ""
    @State var editedProjectStartDate: Date = Date()
    @State var editedProjectEndDate: Date = Date()
    @State var editedProjectDescription: String = ""
    
    @State var editedActivityTitle: String = ""
    @State var editedActivityStartDate: Date = Date()
    @State var editedActivityEndDate: Date = Date()
    @State var editedActivityDescription: String = ""
    
    @State var editedCertificationTitle: String = ""
    @State var editedCertificationStartDate: Date = Date()
    @State var editedCertificationEndDate: Date = Date()
    @State var editedCertificationDescription: String = ""
    
    @State var editedEducationSchool: String = ""
    @State var editedEducationStatus: String = ""
    @State var editedEducationMajor: String = ""
    @State var editedAdmissionYear: Date = Date()
    @State var editedGraduateYear: Date = Date()
    
    @State private var isShowingLogOutAlert: Bool = false
    @State private var isShowingDeleteAccountAlert: Bool = false
    
    @StateObject var kakaoAuthVM : KakaoAuthVM = KakaoAuthVM()
    
    var socialValue = UserDefaultsData.shared.getUserSocial()
    
    init(myPageStore: MyPageStore) {
        self._myPageStore = StateObject(wrappedValue: myPageStore)
        self._editedFields = State(initialValue: myPageStore.updateUser.fields ?? [])
    }
    
    var body: some View {
        VStack {
            ZStack {
              Rectangle().edgesIgnoringSafeArea(.all)
                .frame(height: 10)
                .background().foregroundColor(.mainColor)
            }
            
            ScrollView {
                LazyVStack {
                    ProfileEditSectionView(
                        myPageStore: myPageStore,
                        editedNickName: $editedNickName,
                        editedName: $editedName,
                        editedEmail: $editedEmail,
                        editedShortIntroduce: $editedShortIntroduce
                    )
                    
                    FavFieldsEditSectionView(myPageStore: myPageStore, selectedFields: $editedFields)
                    
                    FavRegionEditSectionView(myPageStore: myPageStore)
                    
                    ProjectEditSectionView(
                        myPageStore: myPageStore,
                        isShowingProjectAddSheet: $isShowingProjectAddSheet,
                        isShowingProjectEditSheet: $isShowingProjectEditSheet,
                        editedItemId: $editedItemId
                    )
                    
                    ActivityEditSectionView(
                        myPageStore: myPageStore,
                        isShowingActivityAddSheet: $isShowingActivityAddSheet,
                        isShowingActivityEditSheet: $isShowingActivityEditSheet,
                        editedItemId: $editedItemId
                    )
                    
                    CertificationEditSectionView(
                        myPageStore: myPageStore,
                        isShowingCertificationAddSheet: $isShowingCertificationAddSheet,
                        isShowingCertificationEditSheet: $isShowingCertificationEditSheet,
                        editedItemId: $editedItemId
                    )
                    
                    EducationEditSectionView(
                        myPageStore: myPageStore,
                        isShowingEducationAddSheet: $isShowingEducationAddSheet,
                        isShowingEducationEditSheet: $isShowingEducationEditSheet,
                        editedItemId: $editedItemId
                    )
                    
                    Spacer(minLength: 100)
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            isShowingLogOutAlert.toggle()
                        } label: {
                            Text("로그아웃")
                        }
                        .alert(isPresented: $isShowingLogOutAlert) {
                            Alert(title: Text("로그아웃"), message: Text("로그아웃 하시겠습니까?"), primaryButton: .destructive(Text("로그아웃"), action: {
                                if let social = socialValue {
                                    switch social {
                                    case .kakao:
                                        kakaoAuthVM.handleKakaoLogout()
                                    default:
                                        myPageStore.removeUserData()
                                    }
                                }
                            }), secondaryButton: .cancel(Text("취소")))
                        }
                        
                        Spacer()
                        
                        Button(role: .destructive) {
                            isShowingDeleteAccountAlert.toggle()
                        } label: {
                            Text("계정 삭제")
                        }
                        .buttonStyle(.borderless)
                        .alert(isPresented: $isShowingDeleteAccountAlert) {
                            Alert(title: Text("계정 삭제"), message: Text("계정을 삭제하시겠습니까?"), primaryButton: .destructive(Text("계정 삭제"), action: {
                                if let social = socialValue {
                                    switch social {
                                    case .apple:
                                        // TODO: 애플계정 회원탈퇴
                                        break
                                    case .kakao:
                                        kakaoAuthVM.deleteKakaoAccount()
                                        break
                                    default:
                                        guard let userEmail = UserDefaultsData.shared.getUserEmail() else { return
                                        }
                                        myPageStore.deleteUser(userEmail: userEmail)
                                        myPageStore.removeUserData()
                                    }
                                }
                            }), secondaryButton: .cancel(Text("취소")))
                        }
                        
                        Spacer()
                    }
                }
            }
            .navigationTitle("My Page Edit")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $myPageStore.isNavigateToLoginView) {
                // 로그아웃 > 로그인 뷰로 이동
                ContentView()
            }
            .sheet(
                isPresented: $isShowingProjectAddSheet,
                content: {
                    ProjectAddSheet(
                        myPageStore: myPageStore,
                        isShowingProjectAddSheet: $isShowingProjectAddSheet,
                        projectTitle: $projectTitle,
                        projectStartDate: $projectStartDate,
                        projectEndDate: $projectEndDate,
                        projectDescription: $projectDescription
                    )
                    .presentationDetents([.medium, .large])
            })
            .sheet(
                isPresented: $isShowingActivityAddSheet,
                content: {
                    ActivityAddSheet(
                        myPageStore: myPageStore,
                        isShowingActivityAddSheet: $isShowingActivityAddSheet,
                        activityTitle: $activityTitle,
                        activityStartDate: $activityStartDate,
                        activityEndDate: $activityEndDate,
                        activityDescription: $activityDescription
                    )
                    .presentationDetents([.medium, .large])
            })
            .sheet(
                isPresented: $isShowingCertificationAddSheet,
                content: {
                    CertificationAddSheet(
                        myPageStore: myPageStore,
                        isShowingCertificationAddSheet: $isShowingCertificationAddSheet,
                        certificationTitle: $certificationTitle,
                        certificationStartDate: $certificationStartDate,
                        certificationEndDate: $certificationEndDate,
                        certificationDescription: $certificationDescription
                    )
                    .presentationDetents([.medium, .large])
            })
            .sheet(
                isPresented: $isShowingEducationAddSheet,
                content: {
                    EducationAddSheet(
                        myPageStore: myPageStore,
                        isShowingEducationAddSheet: $isShowingEducationAddSheet,
                        educationSchool: $educationSchool,
                        educationStatus: $educationStatus,
                        educationMajor: $educationMajor,
                        admissionYear: $admissionYear,
                        graduateYear: $graduateYear
                    )
                    .presentationDetents([.medium, .large])
            })
            .sheet(
                isPresented: $isShowingProjectEditSheet,
                content: {
                    ProjectEditSheet(
                        myPageStore: myPageStore,
                        isShowingProjectEditSheet: $isShowingProjectEditSheet,
                        editedProjectTitle: $editedProjectTitle,
                        editedProjectStartDate: $editedProjectStartDate,
                        editedProjectEndDate: $editedProjectEndDate,
                        editedProjectDescription: $editedProjectDescription,
                        editedItemId: $editedItemId
                    )
            })
            .sheet(
                isPresented: $isShowingActivityEditSheet,
                content: {
                    ActivityEditSheet(
                        myPageStore: myPageStore,
                        isShowingActivityEditSheet: $isShowingActivityEditSheet,
                        editedActivityTitle: $editedActivityTitle,
                        editedActivityStartDate: $editedActivityStartDate,
                        editedActivityEndDate: $editedActivityEndDate,
                        editedActivityDescription: $editedActivityDescription,
                        editedItemId: $editedItemId
                    )
                    .presentationDetents([.medium, .large])
            })
            .sheet(isPresented: $isShowingCertificationEditSheet,
               content: {
                    CertificationEditSheet(
                        myPageStore: myPageStore,
                        isShowingCertificationEditSheet: $isShowingCertificationEditSheet,
                        editedCertificationTitle: $editedCertificationTitle,
                        editedCertificationStartDate: $editedCertificationStartDate,
                        editedCertificationEndDate: $editedCertificationEndDate,
                        editedCertificationDescription: $editedCertificationDescription,
                        editedItemId: $editedItemId
                    )
                    .presentationDetents([.medium, .large])
            })
            .sheet(
                isPresented: $isShowingEducationEditSheet,
                content: {
                    EducationEditSheet(
                        myPageStore: myPageStore,
                        isShowingEducationEditSheet: $isShowingEducationEditSheet,
                        editedEducationSchool: $editedEducationSchool,
                        editedEducationStatus: $editedEducationStatus,
                        editedEducationMajor: $editedEducationMajor,
                        editedAdmissionYear: $editedAdmissionYear,
                        editedGraduateYear: $editedGraduateYear,
                        editedItemId: $editedItemId
                    )
                    .presentationDetents([.medium, .large])
            })
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Back")
                            .foregroundColor(.white)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if !editedNickName.isEmpty {
                            myPageStore.updateUser.userNickName = editedNickName
                        }
                        
                        if !editedName.isEmpty {
                            myPageStore.updateUser.name = editedName
                        }
                        
                        if !editedEmail.isEmpty {
                            myPageStore.updateUser.userEmail = editedEmail
                        }
                        if !editedFields.isEmpty{
                            myPageStore.updateUser.fields = editedFields
                        }
                        if !editedShortIntroduce.isEmpty {
                            myPageStore.userCv.shortIntroduce = editedShortIntroduce
                        }
                        
                        myPageStore.addUpdateCVData()
                        
                        myPageStore.uploadImage { bool in
                            if bool == true {
                                debugPrint("사진저장함")
                                myPageStore.updateUserData()
                            } else {
                                debugPrint("사진 저장 안함")
                                myPageStore.updateUserData()
                            }
                        }
                        
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Save")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

struct MyPageEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MyPageEditView(myPageStore: MyPageStore())
        }
    }
}
