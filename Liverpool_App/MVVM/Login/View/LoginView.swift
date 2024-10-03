//
//  LoginView.swift
//  Liverpool_App
//
//  Created by Gil casimiro on 03/10/24.
//

import SwiftUI

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @ObservedObject private var viewModel = LoginViewModel()  

    var body: some View {
        VStack {
            // Campo para el correo electrónico
            TextField("Correo electrónico", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)
                .keyboardType(.emailAddress)

            SecureField("Contraseña", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: {
                viewModel.signIn(email: email, password: password)
            }) {
                Text("Iniciar Sesión")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()
        }
        .padding()
        .fullScreenCover(isPresented: $viewModel.goToMain, content: {
            MainView()
        })
    }
}

#Preview {
    LoginView()
}
