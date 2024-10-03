//
//  DetailsView.swift
//  Liverpool_App
//
//  Created by Gil casimiro on 03/10/24.
//

import SwiftUI

import SwiftUI
import FirebaseAuth

struct DetailsView: View {
    @ObservedObject var viewModel: ConversationDetailViewModel
    init(conversation: Conversation) {
        self.viewModel = ConversationDetailViewModel(conversationId: conversation.id ?? "")
    }

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(viewModel.messages) { message in
                        HStack {
                            if message.senderId == Auth.auth().currentUser?.uid {
                                Spacer()
                                Text(message.content)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                            } else {
                                Text(message.content)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.top)
            }
            HStack {
                TextField("Escribe un mensaje...", text: $viewModel.newMessageContent)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    viewModel.sendMessage()
                }) {
                    Text("Enviar")
                        .bold()
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                .padding(.trailing)
                .disabled(viewModel.newMessageContent.isEmpty)
            }
        }
        .navigationTitle("Mensajes")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchMessages()
        }
    }
}

