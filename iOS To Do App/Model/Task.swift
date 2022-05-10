//
//  Task.swift
//  iOS To Do App
//
//  Created by Mert Şafaktepe on 6.05.2022.
//

import Foundation
import FirebaseFirestoreSwift

struct Task: Identifiable, Codable {
    @DocumentID var id: String?
    @ServerTimestamp var createdAt: Date?
    
    let title : String
    var isDone: Bool = false
    var doneAt: Date?
    
}
