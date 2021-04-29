//
//  CoreDataManager.swift
//  Harmony
//
//  Created by Macbook Pro on 18.03.2021.
//

import CoreData
import UIKit

/* Groups Core Data Manager */
final class GroupsCoreDataManager {
    
    static var shared = GroupsCoreDataManager()
    
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
    
    /* Groups */
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
    func deleteGroup(id: NSManagedObjectID) {
        do {
            let deletingGroup = try moc.existingObject(with: id) as! Group
            moc.delete(deletingGroup)
            try moc.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

/* Tracks Core Data Manager */
final class TracksCoreDataManager {
    
    static var shared = TracksCoreDataManager()
    
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

    /* Music */
    func getTrack(id: NSManagedObjectID) -> SpotifyTrack? {
        do {
            return try moc.existingObject(with: id) as? SpotifyTrack
        } catch {
            return nil
        }
    }
    func saveTrack(track: Track) -> SpotifyTrack? {
        let newTrack = SpotifyTrack(context: moc)
        newTrack.setValue(track.name, forKey: "name")
        newTrack.setValue(track.artists[0].name, forKey: "artist")
        newTrack.setValue(track.album.images[0].url, forKey: "image_url")
        newTrack.setValue(track.id, forKey: "spotifyId")
        
            do {
                try self.moc.save()
                return newTrack
            } catch {
                return nil
            }
 
    }
    func fetchTracks() -> [SpotifyTrack] {
        do {
            let fetchRequest = NSFetchRequest<SpotifyTrack>(entityName: "SpotifyTrack")
            let tracks = try moc.fetch(fetchRequest)
            return tracks
        } catch {
            return []
        }
    }
    func deleteTracks() {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SpotifyTrack")
            let request: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try moc.execute(request)
            try moc.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }

}

/* Lobby's Playlists Core Data Manager */
final class PlaylistsCoreDataManager {
    
    static var shared = PlaylistsCoreDataManager()
    
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
    
    /* Groups */
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
    func deleteGroup(id: NSManagedObjectID) {
        do {
            let deletingGroup = try moc.existingObject(with: id) as! Group
            moc.delete(deletingGroup)
            try moc.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
