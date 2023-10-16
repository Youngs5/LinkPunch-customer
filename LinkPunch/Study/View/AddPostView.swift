
import SwiftUI
import MapKit
import CoreLocation

struct AddPostView: View {
  @Environment(\.presentationMode) var presentationMode
  
  @ObservedObject var homeStore: HomeStore
  @ObservedObject var studyStore : StudyStore
  @State private var date : Date = Date()
  @State var selectedField : String = "Frontend"
  @State var selectedMember : Int = 3
  @State var title: String = ""
  @State var contents: String = ""
  @State var isOpenMap: Bool = false
  @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780), span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
  
  @State var studyLocation: StudyLocation = StudyLocation(latitude: 37.5665, longitude: 126.9780, address: "서울시청")
  @State var clickLocation: Bool = false
  
  private let titleCharLimit: Int = 30
  private let contentsCharLimit: Int = 300
  private let contentsPlaceholder: String = "내용을 작성해주세요 (시간, 장소, 진행 방식 등)"
  
  
  static let today = Calendar.current.startOfDay(for: Date())
  
  let fields = ["Frontend", "Backend", "AI", "Mobile", "Game", "Graphic", "Etc"]
  
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
              DatePicker("모집 마감 날짜 선택", selection: $date, in: Self.today..., displayedComponents: .date)
                .datePickerStyle(.compact)
                .padding()
              
              Divider()
              
              // 분야
              
              HStack {
                Text("분야 선택")
                
                Spacer()
                
                Picker("분야 선택", selection: $selectedField) {
                  ForEach(fields, id: \.self) { field in
                    Text(field)
                  }
                }
              }
              .padding()
              
              Divider()
              
              
              // 모집 인원
              
              HStack {
                
                Text("모집인원 선택")
                
                Spacer()
                
                Picker("모집인원 선택", selection: $selectedMember) {
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
                  
                  Text(studyLocation.address)
                    .font(.body)
                  
                  ZStack(alignment:.center) {
                    Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: [Location(coordinate: CLLocationCoordinate2D(latitude: studyLocation.latitude, longitude: studyLocation.longitude))]) { location in
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
              
            } //section
            
            Divider()
            
            Section {
              
              // 제목 내용
              VStack(alignment: .trailing) {
                TextField("제목을 작성해주세요", text: $title)
                  .font(.title3)
                  .padding(.top, 0)
                
                // 글자 제한
                  .onChange(of: self.title, perform: {
                    if $0.count > titleCharLimit {
                      self.title = String($0.prefix(titleCharLimit))
                    }
                  })
                Text("\(title.count) / \(titleCharLimit)")
                  .padding(.trailing)
                  .padding(.bottom, -20)
              }
              
              Divider()
              
              
              // TextEditor 부분
              ZStack(alignment: .topLeading) {
                VStack {
                  TextEditor(text: $contents)
                    .keyboardType(.default)
                    .foregroundColor(Color.black)
                    .frame(minHeight: 230)
                    .lineSpacing(10)
                  //                                .shadow(radius: 2.0)
                  // 글자 제한
                    .onChange(of: self.contents, perform: {
                      if $0.count > contentsCharLimit {
                        self.contents = String($0.prefix(contentsCharLimit))
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
                      Text("\(contents.count) / \(contentsCharLimit)")
                    }
                  }
                  .padding(.bottom)
                  .padding(.trailing)  // Text를 떨어뜨리기 위함
                }
                .border(Color.secondary)
                //                            .shadow(radius: 2.0)
                
                // placeholder 직접 구현
                if contents.isEmpty {
                  Text(contentsPlaceholder)
                    .lineSpacing(10)
                    .foregroundColor(Color.primary.opacity(0.25))
                    .padding(.top, 10)
                    .padding(.leading, 10)
                }
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
            StudyMapView(studyStore: studyStore, region: $region, clickLocation: $clickLocation, studyLocation: $studyLocation).presentationDetents([.fraction(0.9)])
          }
          
          //vstack
          
          Text("등록")
            .frame(maxWidth: .infinity, maxHeight: 40)
            .foregroundColor(.white)
            .background(contents=="" || title == "" ? Color.gray : Color.mainColor)
            .cornerRadius(13)
            .padding()
            .onTapGesture {
              if let userEmail = UserDefaultsData.shared.getUserEmail() {
                studyStore.fetchUser(userEmail, homeStore: homeStore) { success in
                  if success {
                    
                    if let userData = studyStore.userData {
                      studyStore.addStudyPost(StudyRecruitment(
                        endDate: date.dateToString(),
                        field: FieldType(rawValue: selectedField) ?? .Etc,
                        location: studyLocation,
                        userName: userEmail,
                        userImgString: "person",
                        title: title,
                        contents: contents,
                        applicantCount: selectedMember,
                        nowApplicant: 1,
                        publisher: userData,
                        participants: [userData],
                        reportCountInfo: ReportCountInfo(
                          isHiddened: false,
                          unrelatedCount: 0,
                          spamFlaggingCount: 0,
                          obscenityCount: 0,
                          offensiveLanguageCount: 0,
                          etcCount: 0)))
                    }
                    
                  }
                }
              }
              presentationMode.wrappedValue.dismiss()
            }
          /*
           studyStore.fetchUser(userEmail, homeStore: homeStore)
           { success in
           if success {
           
           if let userData = studyStore.userData {
           studyStore.addStudyPost(StudyRecruitment(
           endDate: date.dateToString(),
           field: FieldType(rawValue: selectedField) ?? .Etc,
           location: studyLocation,
           userName: userEmail,
           userImgString: "person",
           title: title,
           contents: contents,
           applicantCount: selectedMember,
           nowApplicant: 1,
           publisher: userData,
           participants: [userData],
           reportCountInfo: ReportCountInfo(
           isHiddened: false,
           unrelatedCount: 0,
           spamFlaggingCount: 0,
           obscenityCount: 0,
           offensiveLanguageCount: 0,
           etcCount: 0)))
           }
           
           }
           }
           */
            .disabled(contents=="" || title == "")
        } // VStack
      } // ZStack
      
      //            .toolbarBackground(Color.mainColor, for: .navigationBar)
      //            .toolbarBackground(.visible, for: .navigationBar)
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
              Text("스터디 모집 글쓰기")
                .foregroundColor(.white)
            }
            .padding(.leading, 30)
          }
        }
      }
    } // zstack
  } // body
  
  func setRegion() {
    
    region.center.latitude = studyLocation.latitude
    region.center.longitude = studyLocation.longitude
    
  }
}

struct addPostView_Previews: PreviewProvider {
  static var previews: some View {
    AddPostView(homeStore: HomeStore(), studyStore: StudyStore())
  }
}
