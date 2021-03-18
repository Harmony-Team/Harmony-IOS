//
//  CoreDataManager.swift
//  Harmony
//
//  Created by Macbook Pro on 18.03.2021.
//

import CoreData
import UIKit

final class CoreDataManager {
    
    static var shared = CoreDataManager()
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GroupsList")
        container.loadPersistentStores { (_, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
        }
        
        
        return container
    }()
    
    var moc: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func getGroup(id: NSManagedObjectID) -> Group? {
        do {
            return try moc.existingObject(with: id) as? Group
        } catch {
            return nil
        }
    }
    
    func saveGroup(name: String, image: UIImage) {
        let newGroup = Group(context: moc)
        newGroup.setValue(name, forKey: "name")
        let imageData = image.jpegData(compressionQuality: 1)
        newGroup.setValue(imageData, forKey: "image")
        
        do {
            try moc.save()
        } catch {
            return
        }
    }
    
    func fetchGroups() -> [Group] {
        do {
            let fetchRequest = NSFetchRequest<Group>(entityName: "Group")
            let groups = try moc.fetch(fetchRequest)
            print(groups.count)
            return groups
        } catch {
            return []
        }
    }
}

