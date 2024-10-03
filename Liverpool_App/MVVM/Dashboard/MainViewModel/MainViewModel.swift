//
//  MainViewModel.swift
//  Liverpool_App
//
//  Created by Gil casimiro on 03/10/24.
//

import Foundation
import Combine
import FirebaseAuth

class MainViewModel: ObservableObject {
    @Published var conversations: [Conversation] = []
    @Published var errorMessage: String?

    private let firestoreDataSource = FirestoreDataSource()
    private var cancellables = Set<AnyCancellable>()

    func fetchConversations() {
           guard let userId = Auth.auth().currentUser?.uid else {
               errorMessage = "Usuario no autenticado"
               return
           }

           firestoreDataSource.getConversations(for: userId)
               .receive(on: DispatchQueue.main)
               .sink { [weak self] completion in
                   if case let .failure(error) = completion {
                       print("Error al obtener conversaciones: \(error.localizedDescription)")
                       self?.errorMessage = error.localizedDescription
                   }
               } receiveValue: { [weak self] conversations in
                   print("Conversaciones obtenidas: \(conversations)")
                   self?.conversations = conversations
               }
               .store(in: &cancellables)
       }
}
