//
//  SignUpEducationView.swift
//  LinkPunch
//
//  Created by 나예슬 on 2023/08/22.
//

import SwiftUI

struct SignUpEducationView: View {
    @StateObject var signUpStore: SignUpStore
    @State private var school: String = ""
    @State private var degree: String = ""
    @State private var major: String = ""
    @State private var admissionDatePicker = Date()
    @State private var graduationDatePicker = Date()
    @FocusState private var focusField: Field?
    
    var isNextAvailable: Bool {
        switch focusField {
            case .school:
                return !school.trimmingCharacters(in: .whitespaces).isEmpty
            case .degree:
                return !degree.trimmingCharacters(in: .whitespaces).isEmpty
            case .major:
                return !major.trimmingCharacters(in: .whitespaces).isEmpty
            case .none:
                return false
            }
    }
    
    enum Field {
        case school
        case degree
        case major
    }
    
    var isFieldAllWrite: Bool {
        let currentDate = Calendar.current.startOfDay(for: Date())
        return !school.trimmingCharacters(in: .whitespaces).isEmpty &&
            !degree.trimmingCharacters(in: .whitespaces).isEmpty &&
            !major.trimmingCharacters(in: .whitespaces).isEmpty &&
            Calendar.current.startOfDay(for: admissionDatePicker) != currentDate &&
            Calendar.current.startOfDay(for: graduationDatePicker) != currentDate
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text("추가 정보를 입력해주세요")
                    .font(.title)
                    .bold()
                    .padding(.top, 5)
                
                VStack(alignment: .leading) {
                    Text("학교")
                        .padding(.top, 40)
                        .bold()
                    TextField("", text: $school)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .focused($focusField, equals: .school)
                    
                    Text("학위")
                        .padding(.top, 40)
                        .bold()
                    TextField("", text: $degree)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .focused($focusField, equals: .degree)
                    
                    Text("세부전공")
                        .padding(.top, 40)
                        .bold()
                    TextField("", text: $major)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .focused($focusField, equals: .major)
                }
                .padding(.horizontal, 12)
                
                VStack {
                    HStack {
                        Text("입학 연도")
                            .bold()
                        
                        Spacer()
                        
                        DatePicker("date select", selection: $admissionDatePicker, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                    }
                    .padding(.top, 40)
                    .padding(.horizontal, 12)
                    
                    HStack {
                        Text("졸업 연도(예정)")
                            .bold()
                        Spacer()
                        DatePicker("date select", selection: $graduationDatePicker, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                    }
                    .padding(.horizontal, 12)
                }
            }
            .padding(.top, 40)
        }
        .onTapGesture {
            hideKeyboard()
        }
        
        if isFieldAllWrite  {
            NavigationLink {
                SignUpLocationView(signUpStore: signUpStore)
            } label: {
                Text("추가정보 입력")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(6)
            }
            .simultaneousGesture(TapGesture().onEnded{
                signUpStore.addEducationInfo(school: school, degree: degree, major: major, admissionDatePicker: admissionDatePicker.dateToString(), graduationDatePicker: graduationDatePicker.dateToString())
            })
            .padding(.horizontal, 12)
        } else {
            Button {
                nextFocusConditions()
            } label: {
                Text("다음")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(isNextAvailable ? .blue : .secondary)
                    .cornerRadius(6)
            }
            .disabled(!isNextAvailable)
            .padding(.horizontal, 12)
        }
    }
    
    func nextFocusConditions() {
        if school.isEmpty {
            focusField = .school
            print("\(admissionDatePicker)")
        } else if degree.isEmpty {
            focusField = .degree
        } else if major.isEmpty {
            focusField = .major
        } else {
            focusField = nil
        }
    }
}

struct SignUpEducationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignUpEducationView(signUpStore: SignUpStore())
        }
    }
}
