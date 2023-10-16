//
//  PostEditView.swift
//  LinkPunch
//
//  Created by kokori on 2023/08/29.
//

import SwiftUI
import MapKit
import CoreLocation

struct PostEditView: View {
  
  @Environment(\.presentationMode) var presentationMode
  
  var userDefaults = UserDefaultsData()
  
  @ObservedObject var studyStore: StudyStore
  @ObservedObject var homeStore: HomeStore
  
  @State private var startingPoint = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780), span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
  @State private var date : Date = Date()
  
  @Binding var postData: StudyRecruitment
  @State var isOpenMap: Bool = false
  @State var clickLocation: Bool = false
  private let titleCharLimit: Int = 30
  private let contentsCharLimit: Int = 300
  private let today = Calendar.current.startOfDay(for: Date())
  
  let fields: [FieldType] = [.Frontend, .Backend, .AI, .Mobile, .Game, .Graphic, .Etc]
  let members = [3,4,5,6,7,8,9,10]
  
  var body: some View {
    
    NavigationStack{
      ZStack {
        VStack {
          ZStack {
            Rectangle().edgesIgnoringSafeArea(.all)
              .frame(height: 10)
              .background().foregroundColor(.mainColor)
          }
          
          ScrollView {
            
            Section {
              
                // 마감 날짜
                // to do post data에 있는 enddate(String?) -> Date 타입으로 변환 필요
                DatePicker("모집 마감 날짜 선택", selection: $date, in: self.today..., displayedComponents: .date)
                  .datePickerStyle(.compact)
                  .padding()
                
                Divider()
                
                // 분야
                
                HStack {
                  Text("분야 선택")
                  
                  Spacer()
                  
                  Picker("분야 선택", selection: $postData.field) {
                    ForEach(fields, id: \.self) { field in
                        Text(field.rawValue)
                    }
                  }
                }
                .padding()
                
                Divider()
                
                
                // 모집 인원
                
                HStack {
                  
                  Text("모집인원 선택")
                  
                  Spacer()
                  
                  //to do
                  //만약에 처음에 5명 모집이었는데, 4명이고, 3명으로 줄이고싶다고하면 x
                  Picker("모집인원 선택", selection: $postData.applicantCount) {
                    ForEach(members, id: \.self) { memeber in
                      Text("\(memeber)명")
                    }
                  }
                  .pickerStyle(.menu)
                }
                .padding()
                
                Divider()
                
                // 장소
                
                VStack(alignment: .center) {
                  HStack {
                    Text("스터디 장소 선택")
                    
                    Spacer()
                    
                    Button {
                      isOpenMap.toggle()
                      setRegion()
                    } label: {
                      Label("지역 검색", systemImage: "mappin")
                    }
                    .buttonStyle(.borderedProminent)
                  }
                  .padding()
                  
                  if clickLocation {
                    
                    Text(postData.location.address)
                      .font(.body)
                    
                    ZStack(alignment:.center) {
                      //....?????
                      //to do
                      Map(coordinateRegion: $startingPoint,
                          showsUserLocation: true,
                          annotationItems: [Location(coordinate:
                                                      CLLocationCoordinate2D(
                                                        latitude: postData.location.latitude,
                                                        longitude: postData.location.longitude))]) {
                                                          location in
                                                          MapMarker(coordinate: location.coordinate)
                                                        }
                    }.frame(width: 370, height: 150)
                      .padding([.leading, .trailing,.bottom])
                  } else {
                    Text("스터디 장소를 선택해주세요")
                      .font(.body)
                      .foregroundColor(.gray)
                      .padding([.leading,.bottom])
                  }
                }
                
            }//Section
            
            Divider()
            
            Section {
              
              // 제목 내용
              VStack(alignment: .trailing) {
                TextField("제목을 작성해주세요", text: $postData.title)
                  .font(.title3)
                  .padding(.top, 0)
                
                // 글자 제한
                  .onChange(of: postData.title, perform: {
                    if $0.count > titleCharLimit {
                      postData.title = String($0.prefix(titleCharLimit))
                    }
                  })
                Text("\(postData.title.count) / \(titleCharLimit)")
                  .padding(.trailing)
                  .padding(.bottom, -20)
              }
              
              Divider()
              
              
              // TextEditor 부분
              ZStack(alignment: .topLeading) {
                VStack {
                  TextEditor(text: $postData.contents)
                    .keyboardType(.default)
                    .foregroundColor(Color.black)
                    .frame(minHeight: 230)
                    .lineSpacing(10)
                  //                                .shadow(radius: 2.0)
                  // 글자 제한
                    .onChange(of: postData.contents, perform: {
                      if $0.count > contentsCharLimit {
                        postData.contents = String($0.prefix(contentsCharLimit))
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
                      Text("\(postData.contents.count) / \(contentsCharLimit)")
                    }
                  }
                  .padding(.bottom)
                  .padding(.trailing)  // Text를 떨어뜨리기 위함
                }
                .border(Color.secondary)
                //                            .shadow(radius: 2.0)
                
                //editview 에서는 postData의 contents가 empty 일 수 없음
                // placeholder 직접 구현
                
                //                if postData.contents.isEmpty {
                //                  Text(contentsPlaceholder)
                //                    .lineSpacing(10)
                //                    .foregroundColor(Color.primary.opacity(0.25))
                //                    .padding(.top, 10)
                //                    .padding(.leading, 10)
                //                }
              }  // ZStack
              
              
              //                        ZStack(alignment: .topLeading){
              //
              //                            TextEditor(text: $contents)
              //
              //                            //내용 작성 보더 줘서 수정
              //                            if contents.isEmpty {
              //                                Text("내용을 작성해주세요 (시간, 장소, 진행 방식 등)")
              //                                    .foregroundColor(.gray)
              //                                    .padding(10)
              //                            }
              //                        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
              
              
            } // section
            .padding()
            
            Spacer()
            
          }
          //                .navigationTitle("스터디 글쓰기")
          .sheet(isPresented: $isOpenMap) {
            //요기서 fraction 값 바꾸면 시트 비율조정 가능
            StudyMapView(studyStore: studyStore, region: $startingPoint, clickLocation: $clickLocation, studyLocation: $postData.location).presentationDetents([.fraction(0.9)])
          }
          
          //vstack
          
          Text("수정 완료")
            .frame(maxWidth: .infinity, maxHeight: 40)
            .foregroundColor(.white)
            .background(postData.contents=="" || postData.title == "" ? Color.gray : Color.mainColor)
            .cornerRadius(13)
            .padding()
            .onTapGesture {
                Task{
                    await studyStore.editStudyPost(studyPost:postData)
                    studyStore.fetchStudyPost()
                }
              presentationMode.wrappedValue.dismiss()
            }
            .disabled(postData.contents=="" || postData.title == "")
        } // VStack
      } // ZStack
      .navigationBarBackButtonHidden()  // 네비게이션바와 색이 같아서 없앰
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          HStack {
            Button {
              // 네비게이션 루트로 돌아가도록 만들기
              presentationMode.wrappedValue.dismiss()
            } label: {
              HStack {
                Image(systemName: "chevron.backward")
                Text("Back")
              }
              .font(.title3)
            }
            .tint(.white)
            
            HStack(alignment: .center) {
              Text("스터디 모집 글 수정")
                .foregroundColor(.white)
            }
            .padding(.leading, 30)
          }
        }
      }
    } // zstack
  } // body
  
  
  //set center region
  func setRegion() {
    
    startingPoint.center.latitude = postData.location.latitude
    startingPoint.center.longitude = postData.location.longitude
    
  }
}

struct PostEditView_Previews: PreviewProvider {
  static var previews: some View {
      PostEditView(studyStore: StudyStore(), homeStore: HomeStore(),postData: .constant(StudyRecruitment(endDate: "23", field: .Game, location: StudyLocation( latitude: 37.5665, longitude: 126.9780, address: "서울시청"), userName: "기가희진", userImgString: "admin_Logo", title: "", contents: "방가워요잉", applicantCount: 3, nowApplicant: 1, publisher: User(userNickName: "기가희진", name: "희진", signUpDate: "2020/08/23", userEmail: "test1@test.com", userPwd: "test123", userImage: "admin_Logo", social: .google), participants: [User(userNickName: "기가희진", name: "희진", signUpDate: "2020/08/23", userEmail: "test1@test.com", userPwd: "test123", userImage: "admin_Logo", social: .google)])))
  }
}
