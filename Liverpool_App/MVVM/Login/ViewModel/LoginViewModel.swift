//
//  LoginViewModel.swift
//  Liverpool_App
//
//  Created by Gil casimiro on 03/10/24.
//

import Foundation
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var user: User?  // Usuario autenticado, puede ser nil si no está autenticado
    @Published var errorMessage: String?  // Mensaje de error para mostrar si ocurre un problema
    @Published var goToMain: Bool = false
    init() {
        self.user = Auth.auth().currentUser  // Obtiene el usuario actual al inicializar
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription  // Actualiza el mensaje de error si falla
                }
            } else {
                DispatchQueue.main.async {
                    self?.user = result?.user  // Actualiza el usuario autenticado si tiene éxito
                    self?.errorMessage = nil  // Limpia el mensaje de error
                    self?.goToMain = true 
                }
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()  // Cierra la sesión del usuario actual
            DispatchQueue.main.async {
                self.user = nil  // Marca que no hay usuario autenticado
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Error al cerrar sesión"  // Muestra un mensaje de error si falla el cierre de sesión
            }
        }
    }
}
