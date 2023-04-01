//
//  CategoryModel+CoreDataProperties.swift
//  PersistentToDoList
//
//  Created by Djinsolobzik on 01.04.2023.
//
//

import Foundation
import CoreData


extension CategoryModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryModel> {
        return NSFetchRequest<CategoryModel>(entityName: "CategoryModel")
    }

    @NSManaged public var name: String?
    @NSManaged public var notes: NoteModel?

}

extension CategoryModel : Identifiable {

}
