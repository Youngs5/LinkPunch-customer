//
//  SignUpView.swift
//  LinkPunch
//
//  Created by 나예슬 on 2023/08/22.
//

import SwiftUI

//색상 추출
extension Color {
    
    static let blue = Color(hex: "#1C7CED")
    static let yellow = Color(hex: "#F3CF54")
    static let red = Color(hex: "#E04941")  // #을 제거하고 사용해도 됩니다.
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct SignUpView: View {
    @StateObject var signUpStore: SignUpStore = SignUpStore()
    
    @State private var nickName: String = ""
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isEmailValid: Bool = true
    @State private var isPasswordValid: Bool = true
    @State private var showPassword: Bool = false
    @State private var checkEmail: Bool = false
    @State private var checkEmailColor: Color = Color.red
    @State private var cautionEmail: String = ""
    @State private var isHiddenCheckButton: Bool = false
    @FocusState private var focusField: Field?
    
    var isNextAvailable: Bool {
        switch focusField {
        case .nickName:
            return !nickName.isEmpty
        case .name:
            return !name.isEmpty
        case .email:
            return !email.isEmpty && isValidEmail(email)
        case .password:
            return password.count >= 6
        case .none:
            return false
        }
    }
    
    var isFieldAllWrite: Bool {
        return !nickName.isEmpty &&
        !name.isEmpty &&
        !email.isEmpty &&
        !password.isEmpty &&
        password.count >= 6 &&
        checkEmail == true
    }
    
    enum Field {
        case nickName
        case name
        case email
        case password
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("닉네임")
                    .padding(.top, 30)
                    .bold()
                
                TextField("", text: $nickName)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .focused($focusField, equals: .nickName)
                    .onChange(of: nickName) { newValue in
                        nickName = newValue.trimmingCharacters(in: .whitespaces)
                    }
                
                Text("이름")
                    .padding(.top, 30)
                    .bold()
                TextField("", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .focused($focusField, equals: .name)
                    .onChange(of: name) { newValue in
                        name = newValue.trimmingCharacters(in: .whitespaces)
                    }
                
                HStack {
                    Text("이메일 주소")
                        .padding(.top, 30)
                        .bold()
                    
                    Spacer()
                    if isHiddenCheckButton{
                        Button {
                            Task{
                                checkEmail = await signUpStore.doubleCheckEmail(email: email)
                                if checkEmail == false && email.count > 0{
                                    cautionEmail = "이미 가입한 이메일 입니다."
                                    checkEmailColor = .red
                                } else {
                                    cautionEmail = "사용 가능한 이메일 입니다"
                                    checkEmailColor = .green
                                }
                            }
                        } label: {
                            Text("중복확인")
                        }
                        .padding(.top, 30)
                        .padding(.horizontal ,12)
                    }
                }
                
                TextField("", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .border(isEmailValid ? Color.clear : Color.systemColor)
                    .focused($focusField, equals: .email)
                    .onChange(of: email) { newValue in
                        ischeckEmail()
                        checkEmail = false
                        email = newValue.trimmingCharacters(in: .whitespaces)
                    }
                Text(cautionEmail)
                    .foregroundColor(checkEmailColor)
  
                Text("비밀번호")
                    .padding(.top, 30)
                    .bold()
                HStack {
                    if showPassword {
                        TextField("", text: $password)
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .focused($focusField, equals: .password)
                            .onChange(of: password) { newValue in
                                password = newValue.trimmingCharacters(in: .whitespaces)
                            }
                            .border(isPasswordValid ? Color.clear : Color.systemColor)
                    } else {
                        SecureField("", text: $password)
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .focused($focusField, equals: .password)
                            .onChange(of: password) { newValue in
                                password = newValue.trimmingCharacters(in: .whitespaces)
                            }
                            .border(isPasswordValid ? Color.clear : Color.systemColor)
                    }
                    
                    Button {
                        self.showPassword.toggle()
                    } label: {
                        if showPassword == true {
                            Image(systemName: "eye")
                                .foregroundColor(.black)
                        } else if showPassword == false {
                            Image(systemName: "eye.slash")
                                .foregroundColor(.black)
                        }
                    }
                }
                
                if password.count > 0 && password.count <= 5 {
                    Text("6자리 이상 입력 가능합니다.")
                        .foregroundColor(.systemColor)
                } else {
                    Text("")
                }
            } .padding(.horizontal, 12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture {
            hideKeyboard()
        }
        
        if isFieldAllWrite {
            NavigationLink {
                SignUpEducationView(signUpStore: signUpStore)
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
                signUpStore.addDefaultInfo(nickName: nickName, name: name, email: email, password: password)
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
            .navigationTitle("회원가입")
        }
    }
    func ischeckEmail(){
        if isValidEmail(email) {
            cautionEmail = ""
            isHiddenCheckButton = true
            checkEmailColor = .red
        }
        else if !isValidEmail(email) && email.count > 0 {
            cautionEmail = "이메일 형식이 맞지 않습니다."
            isHiddenCheckButton = false
            checkEmailColor = .red
        }
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func nextFocusConditions() {
        if nickName.isEmpty {
            focusField = .nickName
        } else if name.isEmpty {
            focusField = .name
        } else if email.isEmpty {
            focusField = .email
        } else if !isValidEmail(email) {
            isEmailValid = false
            focusField = .email
        } else if isValidEmail(email) {
            isEmailValid = true
            focusField = .password
        } else if password.count < 6 {
            isPasswordValid = false
            focusField = .password
        } else {
            isPasswordValid = true
            focusField = nil
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignUpView()
        }
    }
}
