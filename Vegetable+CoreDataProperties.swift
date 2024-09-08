//
//  Vegetable+CoreDataProperties.swift
//  homeGardening
//
//  Created by Rasim Egi on 17.07.2024.
//
//

import Foundation
import CoreData


extension Vegetable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vegetable> {
        return NSFetchRequest<Vegetable>(entityName: "Vegetable")
    }

    @NSManaged public var isim: String?
    @NSManaged public var metin: String?
    @NSManaged public var gorsel: Data?
    @NSManaged public var buyumeSuresi: Int16
    

}

extension Vegetable : Identifiable {

}
