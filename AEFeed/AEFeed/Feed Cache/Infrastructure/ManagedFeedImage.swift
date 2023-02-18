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
    
    static func first(with path: String, in context: NSManagedObjectContext) throws -> ManagedFeedImage? {
        let request = NSFetchRequest<ManagedFeedImage>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedFeedImage.imagePath), path])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    static func images(from localFeed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
        let images = NSOrderedSet(array: localFeed.map {
            let managed = ManagedFeedImage(context: context)
            managed.id = NSNumber(value: $0.id)
            managed.title = $0.title
            managed.imagePath = $0.imagePath
            managed.overview = $0.overview
            managed.data = context.userInfo[$0.imagePath] as? Data
            return managed
        })
        context.userInfo.removeAllObjects()
        return images
    }
    
    static func data(with url: URL, in context: NSManagedObjectContext) throws -> Data? {
        if let data = context.userInfo[url.lastPathComponent] as? Data {
            return data
        }
        return try first(with: url.lastPathComponent, in: context)?.data
    }
    
    override func prepareForDeletion() {
        super.prepareForDeletion()
        managedObjectContext?.userInfo[imagePath] = data
    }
}
