//
//  TaskCloudManager.swift
//  taskfolio
//
//  Created by 송영모 on 2023/05/25.
//

import Foundation

import CloudKit
import CoreData

class TaskCloudManager {
    static let shared = TaskCloudManager()
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "taskfolio")
        let storeDirectory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).last!
        
        let localUrl = storeDirectory.appendingPathComponent("Local.sqlite")
        let localStoreDescription =
        NSPersistentStoreDescription(url: localUrl)
        localStoreDescription.configuration = "Local"
        
        let cloudUrl = storeDirectory.appendingPathComponent("Cloud.sqlite")
        let cloudStoreDescription =
        NSPersistentStoreDescription(url: cloudUrl)
        cloudStoreDescription.configuration = "Cloud"
        
        cloudStoreDescription.cloudKitContainerOptions =
        NSPersistentCloudKitContainerOptions(
            containerIdentifier: "iCloud.taskfolio")
        
        container.persistentStoreDescriptions = [
            cloudStoreDescription,
            localStoreDescription
        ]
        
        container.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError("Could not load persistent stores. \(error!)")
            }
        }
        
        return container
    }()
}

extension TaskCloudManager {
    func newTask() -> Task {
        let viewContext = self.persistentContainer.viewContext
        viewContext.reset()
        
        let task = Task(context: viewContext)
        
        return task
    }
    
    func fetch() -> [Task] {
        let viewContext = self.persistentContainer.viewContext
        
        let request: NSFetchRequest<NSFetchRequestResult> = .init(entityName: "Plot")
        
        do {
            return try viewContext.fetch(request) as! [Task]
        } catch {
            print(error)
            return []
        }
    }
    
    func fetch(id: NSManagedObjectID) -> Task? {
        let viewContext = self.persistentContainer.viewContext
        
        do {
            return try viewContext.existingObject(with: id) as? Task
        } catch {
            print(error)
            return nil
        }
    }
    
    func save() {
        let viewContext = self.persistentContainer.viewContext

        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    func delete(id: NSManagedObjectID) {
        let viewContext = self.persistentContainer.viewContext
        
        if let task = self.fetch(id: id) {
            viewContext.delete(task)
            self.save()
        }
    }
}

