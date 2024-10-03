//
//  DetailsViewModel.swift
//  Liverpool_App
//
//  Created by Gil casimiro on 03/10/24.
//

import Foundation
import Combine
import FirebaseAuth

class ConversationDetailViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var newMessageContent: String = ""
    @Published var errorMessage: String?

    private let firestoreDataSource = FirestoreDataSource()
    private var cancellables = Set<AnyCancellable>()
    var conversationId: String

    init(conversationId: String) {
        self.conversationId = conversationId
        fetchMessages()
    }

    func fetchMessages() {
        firestoreDataSource.getMessages(for: conversationId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    print("Error al obtener mensajes: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] messages in
                print("Mensajes obtenidos: \(messages)")
                self?.messages = messages
            }
            .store(in: &cancellables)
    }

    func sendMessage() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let message = Message(senderId: userId, content: newMessageContent, timestamp: Date())
        firestoreDataSource.sendMessage(to: conversationId, message: message)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] in
                self?.newMessageContent = ""
                self?.fetchMessages()
            }
            .store(in: &cancellables)
    }
}
