//
//  CategoryModel.swift
//  PersistentToDoList
//
//  Created by Djinsolobzik on 01.04.2023.
//

import Foundation
import RealmSwift


class CategoryModel: Object {
    @Persisted var name: String
    @Persisted var notes: List<NoteModel>
}
