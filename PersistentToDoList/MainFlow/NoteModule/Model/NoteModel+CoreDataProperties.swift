//
//  NoteModel+CoreDataProperties.swift
//  PersistentToDoList
//
//  Created by Djinsolobzik on 31.03.2023.
//
//

import Foundation
import CoreData


extension NoteModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteModel> {
        return NSFetchRequest<NoteModel>(entityName: "NoteModel")
    }

    @NSManaged public var done: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var parentCategory: CategoryModel?

}

extension NoteModel : Identifiable {

}
