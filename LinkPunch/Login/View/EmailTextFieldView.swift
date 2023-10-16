//
//  EmailTextFieldView.swift
//  LinkPunch
//
//  Created by 아라 on 2023/08/31.
//

import SwiftUI

struct EmailTextFieldView: View {
    @Binding var userEmail: String
    @Binding var isEmailValid: Bool
    @Binding var isLoginSuccess: LoginState
    
    var emailBorderColor: Color {
        if isLoginSuccess == .fail || !isEmailValid {
            return Color.systemColor
        } else {
            return Color.gray
        }
    }
    
    var body: some View {
        TextField("e-mail", text: $userEmail)
            .submitLabel(.next)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .frame(height: 45)
            .padding(.horizontal, 12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(emailBorderColor))
            .onAppear {
                UITextField.appearance().clearButtonMode = .whileEditing
            }
            .onChange(of: userEmail) { newValue in
                userEmail = newValue.trimmingCharacters(in: .whitespaces)
            }
    }
}

struct EmailTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        EmailTextFieldView(userEmail: LoginView().$userEmail, isEmailValid: LoginView().$isEmailValid, isLoginSuccess: LoginView().$isLoginSuccess)
    }
}
