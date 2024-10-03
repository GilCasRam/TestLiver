//
//  DetailsModel.swift
//  Liverpool_App
//
//  Created by Gil casimiro on 03/10/24.
//

import Foundation

struct Message: Identifiable, Codable {
    var id: String? 
    var senderId: String
    var content: String
    var timestamp: Date
}
