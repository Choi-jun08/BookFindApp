//
//  SavedBook+CoreDataProperties.swift
//  BookFindApp
//
//  Created by t2023-m0072 on 1/3/25.
//
//

import Foundation
import CoreData

extension SavedBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedBook> {
        return NSFetchRequest<SavedBook>(entityName: "SavedBook")
    }

    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var price: Int32
    @NSManaged public var thumbnailURL: String?
    @NSManaged public var descriptionText: String?
}

extension SavedBook: Identifiable {}
