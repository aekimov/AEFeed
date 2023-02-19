//
//  ManagedCache.swift
//  AEFeed
//
//  Created by Artem Ekimov on 1/18/23.
//

import CoreData

@objc(ManagedCache)
class ManagedCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var feed: NSOrderedSet
    
    static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
        let request = NSFetchRequest<ManagedCache>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    static func deleteCache(in context: NSManagedObjectContext) throws {
        try find(in: context).map(context.delete).map(context.save)
    }

    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedCache {
        try deleteCache(in: context)
        return ManagedCache(context: context)
    }
    
    var localFeed: [LocalFeedImage] {
        return feed
            .compactMap { $0 as? ManagedFeedImage }
            .map { LocalFeedImage(id: $0.id.intValue, title: $0.title, imagePath: $0.imagePath, overview: $0.overview) }
    }
}
