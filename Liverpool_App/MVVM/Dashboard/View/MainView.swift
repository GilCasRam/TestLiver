//
//  MainView.swift
//  Liverpool_App
//
//  Created by Gil casimiro on 03/10/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        VStack{
            List(viewModel.conversations) { conversation in
                            NavigationLink(destination: DetailsView(conversation: conversation)) {
//                NavigationLink(destination: Text("Detalles")) {
                                VStack(alignment: .leading) {
                                    Text(conversation.lastMessage)
                                        .font(.headline)
                                    Text(conversation.lastUpdated, style: .date)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .navigationTitle("Conversaciones")
                        .onAppear {
                            viewModel.fetchConversations()
                        }
            Button(action: {
                loginViewModel.signOut()
            }, label: {
                Text("Cerra sesion")
            })
        }
    }
}

#Preview {
    MainView()
}
