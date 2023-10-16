//
//  LoginView.swift
//  LinkPunch
//
//  Created by 유하은 on 2023/08/22.
//

import SwiftUI

enum LoginState {
    case none
    case fail
    case duplication
    case success
}

enum LoginFeild {
    case email
    case password
}

struct LoginView: View {
    @State var userEmail: String = ""
    @State var userPwd: String = ""
    var social: Social = .none // DB에 정보 보낼 땐 .rawValue로 String값 전달하기
    
    @ObservedObject var loginStore: LoginStore = LoginStore() //successLogin -> true면 성공 false면 실패
    @StateObject var kakaoAuthVM : KakaoAuthVM = KakaoAuthVM()
    @ObservedObject var googleLoginVM = GoogleSignInVM()
    
    @FocusState private var isKeyBoardUp: LoginFeild?
    
    @State private var isAgreeKakaoLogin: Bool = false
    @State private var isAgreeGoogleLogin: Bool = false
    @State var isEmailValid: Bool = true
    @State var isPasswordValid: Bool = true
    @State var isLoginSuccess: LoginState = .none
    @State private var isAutoLogin: Bool = false
    @State private var isLoginBtnDisabled = false
    
    let emailMessage = "이메일 형식이 맞지 않습니다."
    let passwordMessage = "6글자 이상 입력해주세요."
    let failLoginMessage = "e-mail 혹은 password가 일치하지 않습니다."
    let duplLoginMessage = "이미 로그인 된 아이디 입니다."
    
    private func signInWithGoogle() {
        Task {
            if await googleLoginVM.signInWithGoogle() {
                guard let userEmail = UserDefaultsData.shared.getUserEmail() else { return }
                await loginStore.checkDeviceDuplicate(userEmail: userEmail)
                isAgreeGoogleLogin = true
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack() {
                HStack {
                    Spacer()
                    Image("admin_Logo")
                        .resizable()
                        .frame(width: 200,height: 200)
                    Spacer()
                }
                .padding(.vertical, 20)
                
                VStack(alignment: .leading) {
                    EmailTextFieldView(userEmail: $userEmail, isEmailValid: $isEmailValid, isLoginSuccess: $isLoginSuccess)
                        .focused($isKeyBoardUp, equals: .email)
                        .onTapGesture {
                            userEmail = ""
                            isKeyBoardUp = .email
                        }
                    
                    Text(isLoginSuccess == .fail || isLoginSuccess == .duplication || isEmailValid ? "" : emailMessage)
                        .font(.footnote)
                        .foregroundColor(.systemColor)
                        .padding(.horizontal, 4)
                    
                    PasswordSecureField(userPwd: $userPwd, isPasswordValid: $isPasswordValid, isLoginSuccess: $isLoginSuccess)
                        .focused($isKeyBoardUp, equals: .password)
                        .onTapGesture {
                            userPwd = ""
                            isKeyBoardUp = .password
                        }
                    
                    Text(isLoginSuccess == .fail ? failLoginMessage : isLoginSuccess == .duplication ? duplLoginMessage : isPasswordValid ? "" : passwordMessage)
                        .font(.footnote)
                        .foregroundColor(.systemColor)
                        .padding(.horizontal, 4)
                        .padding(.vertical, isPasswordValid ? 0 : 4)
                    
                    Button {
                        isAutoLogin.toggle()
                    } label: {
                        Image(systemName: isAutoLogin ? "checkmark.square" : "square")
                        Text("자동 로그인")
                    }
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 5)
                }
                .onChange(of: isKeyBoardUp) { isFocused in
                    if isFocused != nil {
                        resetFields()
                    }
                }
                .onSubmit {
                    switch isKeyBoardUp {
                    case .email:
                        isKeyBoardUp = .password
                    case .password:
                        isKeyBoardUp = nil
                    default:
                        isKeyBoardUp = nil
                    }
                }
                
                HStack {
                    Spacer()
                    Button {
                        if !checkEmailValid(userEmail) || userPwd.count < 6 {
                            isEmailValid = checkEmailValid(userEmail)
                            
                            isPasswordValid = (userPwd.count < 6) ? false : true
                            
                        } else {
                            isLoginBtnDisabled = true
                            Task {
                                if isAutoLogin {
                                    loginStore.autoLogin()
                                }
                                
                                isLoginSuccess = await loginStore.signIn(email: userEmail, password: userPwd)
                                
                                if isLoginSuccess == .fail || isLoginSuccess == .duplication{
                                    userEmail = ""
                                    userPwd = ""
                                    isEmailValid = false
                                    isPasswordValid = false
                                    isLoginBtnDisabled = false
                                }
                            }
                        }
                    } label: {
                        Text("로그인")
                            .font(.title3).bold()
                            .foregroundColor(.mainColor)
                            .padding([.horizontal, .vertical], 15)
                    }
                    .disabled(isLoginBtnDisabled)
                    .navigationDestination(isPresented: $loginStore.successLogin) {
                        MainTabView()
                    }
                    .padding(10)
                    
                    NavigationLink {
                        SignUpView()
                    } label: {
                        Text("회원가입")
                            .font(.title3).bold()
                            .foregroundColor(.mainColor)
                    }
                    .padding(10)
                    Spacer()
                }
                
                DividerView()
                
                HStack {
                    Spacer()
                    Button {
                        
                    } label: {
                        Image("Apple_Black")
                            .frame(width: 61)
                    }
                    
                    Button {
                        signInWithGoogle()
                        if isAutoLogin {
                            loginStore.autoLogin()
                        }
                    } label: {
                        Image("Google")
                            .frame(width: 61)
                    }
                    .navigationDestination(isPresented: $isAgreeGoogleLogin) {
                        MainTabView()
                    }
                    .padding()
                    
                    Button {
                        kakaoAuthVM.handleKakaoLogin { success in
                            if success {
                                guard let userEmail = UserDefaultsData.shared.getUserEmail() else { return }
                                
                                Task {
                                    await loginStore.checkDeviceDuplicate(userEmail: userEmail)
                                    isAgreeKakaoLogin = true
                                    
                                    if isAutoLogin {
                                        loginStore.autoLogin()
                                    }
                                }
                                
                            }
                            if isAutoLogin {
                                loginStore.autoLogin()
                            }
                        }
                    } label: {
                        Image("Kakao")
                            .frame(width: 61)
                    }
                    .navigationDestination(isPresented: $isAgreeKakaoLogin) {
                        MainTabView()
                    }
                    
                    Spacer()
                }
            }
            .background()
            .onTapGesture {
                if isKeyBoardUp != nil {
                    isKeyBoardUp = nil
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden()
    }
    
    func checkEmailValid(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func resetFields() {
        isEmailValid = true
        isPasswordValid = true
        isLoginSuccess = .none
    }
}

struct DividerView: View {
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Divider()
                    .frame(width: 80)
            }
            Text("OR")
                .bold()
                .foregroundColor(.secondary)
            VStack {
                Divider()
                    .frame(width: 80)
            }
            Spacer()
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
