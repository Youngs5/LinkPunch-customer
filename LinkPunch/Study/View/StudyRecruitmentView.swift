//
//  StudyRecruitmentView.swift
//  LinkPunch
//
//  Created by 유하은 on 2023/08/22.
//

import SwiftUI

struct StudyRecruitmentView: View {
    @State private var selectField: FieldType = .All
    @StateObject var studyStore = StudyStore()
    @State private var selectedButtonIndex: Int = 0
    @ObservedObject var homeStore: HomeStore
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var filteredDummys: [StudyRecruitment] {
        if selectField == .All {
            return studyStore.studyRecruitmentStore
        } else {
            return studyStore.studyRecruitmentStore.filter { $0.field == selectField }
        }
    }
    //파란색바탕 하얀색 글씨. 색은 옅은 횟
    var body: some View {
        NavigationStack{
            ZStack {
                VStack{
                    ZStack{
                        Rectangle().edgesIgnoringSafeArea(.all)
                            .foregroundColor(.mainColor)
                            .frame(height: 60)
                        Text("Study").foregroundColor(.white)
                            .font(.title)
                            .bold()
                            .offset(y:-10)
                        HStack{
                            Spacer()
                            NavigationLink {
                                AddPostView(homeStore: homeStore, studyStore: studyStore)
                            } label: {
                                PostWriteButtonView()
                            }
                        }
                        .offset(y:-10)
                        .padding(10)
                    }
                    
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(alignment: .center){
                            ForEach(FieldType.allCases.indices) { index in
                                let field = FieldType.allCases[index]
                                Button {
                                    selectField = field
                                    selectedButtonIndex = index
                                } label: {
                                    Text(field.rawValue)
                                        .font(.system(size: 14))
                                        .fontWeight(selectedButtonIndex == index ? .heavy : .regular)
                                        .foregroundColor(selectedButtonIndex == index ? .white : .black)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(selectedButtonIndex == index ? .mainColor :  Color(red: 0.8, green: 0.8, blue: 0.8))
                                .cornerRadius(15)
                            }
                        }
                        .padding([.leading],10)
                    }
                    List(filteredDummys) { content in
                        if content.reportCountInfo?.isHiddened == false {
                            NavigationLink {
                                PostDetailView(studyStore: studyStore, homeStore: homeStore, postData: content)
                            }
                        label:{
                            RecruitmentCells(content: content, studyStore: studyStore)
                        }.disabled(content.reportCountInfo?.isHiddened == true)
                            
                        }


                    }
              
                    .listStyle(.plain)
               
                }//Vstack
                Spacer()
                
                //                NavigationLink{
                //                    AddPostView(studyStore: dummys)
                //                } label: {
                //                    Image(systemName: "pencil.circle.fill")
                //                        .resizable()
                //                        .frame(width: 70,height: 70)
                //                }
                //                .offset(y:300)
                //                .padding(.leading,250)
            }
        }
        .accentColor(Color.mainColor)
        .refreshable {
            studyStore.fetchStudyPost()
         
        }
        .onAppear {
            studyStore.fetchStudyPost()
        }
    }
    
}



struct StudyRecruitmentView_Previews: PreviewProvider {
    static var previews: some View {
        StudyRecruitmentView(homeStore: HomeStore())
    }
}
//리크루트뷰
