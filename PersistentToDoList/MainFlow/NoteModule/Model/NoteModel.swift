//
//  NoteModel.swift
//  PersistentToDoList
//
//  Created by Djinsolobzik on 01.04.2023.
//

import Foundation
import RealmSwift

class NoteModel: Object {
    @Persisted var title: String
    @Persisted var dateCreate: Date
    @Persisted var done: Bool = false
    @Persisted(originProperty: "notes") var parentCategory: LinkingObjects<CategoryModel>
    
}
