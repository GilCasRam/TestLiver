//
//  FireBaseConfiguration.swift
//  Liverpool_App
//
//  Created by Gil casimiro on 03/10/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreCombineSwift
import Combine

class FirestoreDataSource {
    private let db = Firestore.firestore()

    func getConversations(for userId: String) -> AnyPublisher<[Conversation], Error> {
        return db.collection("conversations")
            .whereField("participants", arrayContains: userId)
            .getDocuments()
            .tryMap { snapshot in
                snapshot.documents.compactMap { doc -> Conversation? in
                    var conversation = try? doc.data(as: Conversation.self)
                    conversation?.id = doc.documentID  // Asignar el ID del documento al modelo
                    return conversation
                }
            }
            .eraseToAnyPublisher()
    }

}

extension FirestoreDataSource {
    func getMessages(for conversationId: String) -> AnyPublisher<[Message], Error> {
        return db.collection("conversations")
            .document(conversationId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
            .getDocuments()
            .tryMap { snapshot in
                snapshot.documents.compactMap { doc -> Message? in
                    var message = try? doc.data(as: Message.self)
                    message?.id = doc.documentID
                    return message
                }
            }
            .eraseToAnyPublisher()
    }
    
    func sendMessage(to conversationId: String, message: Message) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            let collection = self.db.collection("conversations")
                .document(conversationId)
                .collection("messages")

            do {
                _ = try collection.addDocument(from: message) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}

