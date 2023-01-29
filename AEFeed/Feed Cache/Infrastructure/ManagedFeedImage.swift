//
//  ManagedFeedImage.swift
//  AEFeed
//
//  Created by Artem Ekimov on 1/18/23.
//

import CoreData

@objc(ManagedFeedImage)
class ManagedFeedImage: NSManagedObject {
    @NSManaged var id: NSNumber
    @NSManaged var title: String
    @NSManaged var imagePath: String
    @NSManaged var overview: String
    @NSManaged var data: Data?
    @NSManaged var cache: ManagedCache
    
    static func images(from localFeed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: localFeed.map {
            let managed = ManagedFeedImage(context: context)
            managed.id = NSNumber(value: $0.id)
            managed.title = $0.title
            managed.imagePath = $0.imagePath
            managed.overview = $0.overview
            return managed
        })
    }
}
