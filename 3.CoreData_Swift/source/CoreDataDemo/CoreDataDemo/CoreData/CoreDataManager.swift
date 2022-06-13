//
//  CoreDataManager.swift
//  CoreDataDemo
//
//  Created by Bradley Hoang on 11/06/2022.
//

import Foundation
import CoreData

/*
 https://www.advancedswift.com/batch-delete-everything-core-data-swift
 */
class CoreDataManager: CoreDataStack {
    static let shared = CoreDataManager()
    
    func getCoins() -> [CoinEntity] {
        let fetchRequest: NSFetchRequest<CoinEntity> = CoinEntity.fetchRequest()
        
        // Sort by rank
        let rankSort = NSSortDescriptor(key: "rank", ascending: true)
        fetchRequest.sortDescriptors = [rankSort]
        
        do {
            let coins = try persistentContainer.viewContext.fetch(fetchRequest)
            return coins
        } catch let error {
            print("Could not fetch. \(error), \(error.localizedDescription)")
            return []
        }
    }
    
    func editNameCoin(_ coin: CoinEntity, newName: String) {
        // Create a fetch request with a predicate
        let fetchRequest: NSFetchRequest<CoinEntity> = CoinEntity.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "rank == %@", argumentArray: [coin.rank])
        
        // Setting includesPropertyValues to false means
        // the fetch request will only get the managed
        // object ID for each object
        fetchRequest.includesPropertyValues = false

        // Get a reference to a managed object context
        let context = persistentContainer.viewContext

        do {
            // Perform the fetch request
            let coinEntity = try context.fetch(fetchRequest).first
            
            // Edit
            if let coinEntity = coinEntity {
                coinEntity.name = newName
            } else {
                print("Not found coin entity with rank = \(coin.rank)")
            }
            
            // Save the deletions to the persistent store
            saveContext()
        } catch let error {
            print("Could not edit. \(error), \(error.localizedDescription)")
        }
    }
    
    func saveCoins(_ coins: [CoinModel]) -> [CoinEntity] {
        var coinEntities: [CoinEntity] = []
        for coin in coins {
            let entity = NSEntityDescription.insertNewObject(forEntityName: "CoinEntity", into: persistentContainer.viewContext) as! CoinEntity
            entity.rank = Int16(coin.rank)
            entity.imageUrl = coin.image
            entity.name = coin.symbol
            entity.currentPrice = coin.currentPrice
            entity.priceChangePercent = coin.priceChangePercentage24H ?? 0
            coinEntities.append(entity)
        }
        
        saveContext()
        return coinEntities
    }
    
    func deleteOneCoin(_ coin: CoinEntity) {
        persistentContainer.viewContext.delete(coin)
        
        // Save the deletions to the persistent store
        saveContext()
    }
    
    func batchDeleteOneCoin(_ coin: CoinEntity) {
        // Specify a batch to delete with a fetch request
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CoinEntity")
        
        fetchRequest.predicate = NSPredicate(format: "name == USDT", argumentArray: [coin.rank])

        // Create a batch delete request for the
        // fetch request
        let deleteRequest = NSBatchDeleteRequest(
            fetchRequest: fetchRequest
        )

        // Specify the result of the NSBatchDeleteRequest
        // should be the NSManagedObject IDs for the
        // deleted objects
        deleteRequest.resultType = .resultTypeObjectIDs

        // Get a reference to a managed object context
        let context = persistentContainer.viewContext

        do {
            // Perform the batch delete
            let batchDelete = try context.execute(deleteRequest)
                as? NSBatchDeleteResult

            guard let deleteResult = batchDelete?.result
                as? [NSManagedObjectID]
                else { return }

            let deletedObjects: [AnyHashable: Any] = [
                NSDeletedObjectsKey: deleteResult
            ]

            // Merge the delete changes into the managed
            // object context
            NSManagedObjectContext.mergeChanges(
                fromRemoteContextSave: deletedObjects,
                into: [context]
            )
            
        } catch let error {
            print("Could not delete. \(error), \(error.localizedDescription)")
        }
    }
    
    func deleteAllCoins() {
        do {
            // Get a reference to a NSPersistentStoreCoordinator
            let storeContainer =
                persistentContainer.persistentStoreCoordinator

            // Delete each existing persistent store
            for store in storeContainer.persistentStores {
                try storeContainer.destroyPersistentStore(
                    at: store.url!,
                    ofType: store.type,
                    options: nil
                )
            }

            // Re-create the persistent container
            persistentContainer = NSPersistentContainer(
                name: "CoreDataDemo" // the name of
                // a .xcdatamodeld file
            )

            // Calling loadPersistentStores will re-create the
            // persistent stores
            persistentContainer.loadPersistentStores {
                (store, error) in
                // Handle errors
            }
        } catch let error {
            print("Could not delete. \(error), \(error.localizedDescription)")
        }
    }
}
