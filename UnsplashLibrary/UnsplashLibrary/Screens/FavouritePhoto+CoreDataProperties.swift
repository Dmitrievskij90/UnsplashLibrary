//
//  FavouritePhoto+CoreDataProperties.swift
//  
//
//  Created by Konstantin Dmitrievskiy on 22.03.2022.
//
//

import Foundation
import CoreData


extension FavouritePhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouritePhoto> {
        return NSFetchRequest<FavouritePhoto>(entityName: "FavouritePhoto")
    }

    @NSManaged public var photo: Data?
    @NSManaged public var index: Int16

}
