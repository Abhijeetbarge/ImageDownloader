


import Foundation
import CoreData

class CoreDataManager: NSObject {
    
    var managedObjectContext: NSManagedObjectContext
    
    override init() {
        // Get coredata model resource path from bundle
        guard let modelUrl = Bundle.main.url(forResource: "Database", withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }
        
        guard let mom = NSManagedObjectModel(contentsOf: modelUrl) else {
            fatalError("Error initiazing mom from:\(modelUrl)")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = psc
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docUrl = urls[urls.endIndex-1]
        let storeUrl = docUrl.appendingPathComponent("Database.sqlite")
        do{
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: nil)
        }catch{
            print( "Error migrating store:\(error)")
        }
    }
}

