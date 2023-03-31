//
//  NoteModel.swift
//  PersistentToDoList
//
//  Created by Djinsolobzik on 25.03.2023.
//

import Foundation

struct Note: Hashable, Codable {
    var id = UUID()
    let title: String
    var done = false
}
