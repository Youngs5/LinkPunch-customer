//
//  PasswordSecureField.swift
//  LinkPunch
//
//  Created by 아라 on 2023/08/31.
//

import SwiftUI

struct PasswordSecureField: View {
    @Binding var userPwd: String
    @Binding var isPasswordValid: Bool
    @Binding var isLoginSuccess: LoginState
    
    var passwordBorderColor: Color {
        if isLoginSuccess == .fail || !isPasswordValid {
            return Color.systemColor
        } else {
            return Color.gray
        }
    }
    
    var body: some View {
        SecureField("password", text: $userPwd)
            .submitLabel(.done)
            .autocapitalization(.none)
            .frame(height: 45)
            .padding(.horizontal, 12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(passwordBorderColor))
            .onAppear {
                UITextField.appearance().clearButtonMode = .whileEditing
            }
            .onChange(of: userPwd) { newValue in
                userPwd = newValue.trimmingCharacters(in: .whitespaces)
            }
    }
}

struct PasswordSecureField_Previews: PreviewProvider {
    static var previews: some View {
        PasswordSecureField(userPwd: LoginView().$userPwd, isPasswordValid: LoginView().$isPasswordValid, isLoginSuccess: LoginView().$isLoginSuccess)
    }
}
