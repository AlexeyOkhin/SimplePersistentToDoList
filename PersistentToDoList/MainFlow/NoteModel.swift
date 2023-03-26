//
//  NoteModel.swift
//  PersistentToDoList
//
//  Created by Djinsolobzik on 25.03.2023.
//

import Foundation

struct Note: Hashable {
    let id = UUID()
    let title: String
    var done = false
}
