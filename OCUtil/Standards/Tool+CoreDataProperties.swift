//
//  Tool+CoreDataProperties.swift
//  OCUtil
//
//  Created by M. De Vries on 11/09/2020.
//  Copyright © 2020 M. De Vries. All rights reserved.
//
//

import Foundation
import CoreData


extension Tool {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tool> {
        return NSFetchRequest<Tool>(entityName: "Tool")
    }

    @NSManaged public var name: String
    @NSManaged public var adress: String
    @NSManaged public var id: UUID
    @NSManaged public var headline: String
    @NSManaged public var body: String
    @NSManaged public var fileAdress: String
    @NSManaged public var runAdress: String

}
