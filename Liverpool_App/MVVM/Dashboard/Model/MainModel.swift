//
//  MainModel.swift
//  Liverpool_App
//
//  Created by Gil casimiro on 03/10/24.
//

import Foundation
import FirebaseFirestoreCombineSwift

struct Conversation: Identifiable, Codable {
    var id: String?
    var participants: [String] 
    var lastMessage: String
    var lastUpdated: Date
}
