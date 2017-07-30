//
//  StoreForSearch.swift
//  productTweeper
//
//  Created by andrzej semeniuk on 7/18/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import CoreData

class StoreForSearch {
    
    struct Entry {
        var title       : String
        var created     : String
        
        init(title:String, created:String? = nil) {
            self.title = title
            if let created = created {
                self.created = created
            }
            else {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
                self.created = formatter.string(from: Date())
            }
        }
    }
    
    static private let EntityName = "SearchEntry"
    
    init(removeTooMany:Bool = false) {
        if removeTooMany {
            _ = self.removeTooMany()
        }
    }
    
    func add(entry:Entry) {
        
        if !AppDelegate.instance.preferences.enableHistory.value {
            return
        }
        
        do {
            let context = AppDelegate.instance.persistentContainer.viewContext
            
            if let description = NSEntityDescription.entity(forEntityName: StoreForSearch.EntityName, in: context) {
                
                let item = NSManagedObject.init(entity: description, insertInto: context)
                
                item.setValue(entry.title,      forKey: "title")
                item.setValue(entry.created,    forKey: "created")
                
                try item.managedObjectContext?.save()
            }
        }
        catch let error {
            print(error)
        }
        
        _ = removeTooMany()
    }
    
    func addIfUnique(title:String) -> Bool {
        var result = false
        let count = getAllEntries().filter {
            $0.title == title
            }.count
        if 0 == count {
            add(entry:Entry(title:title))
            result = true
        }
        return result
    }
    
    func update(entry:Entry, save:Bool = true) {
        let context = AppDelegate.instance.persistentContainer.viewContext
        
        if let description = NSEntityDescription.entity(forEntityName: StoreForSearch.EntityName, in: context) {
            
            let request         = NSFetchRequest<NSFetchRequestResult>()
            
            request.entity      = description
            
            request.predicate   = NSPredicate(format:"created == %@", entry.created)
            
            if let result       = try? context.fetch(request) {
                
                for object in result {
                    if let object = object as? NSManagedObject {
                        object.setValue(entry.title, forKey: "title")
                        if save {
                            do {
                                try context.save()
                            }
                            catch let error {
                                print(error)
                            }
                        }
                        break
                    }
                }
            }
        }
    }
    
    func replace(from:StoreForSearch.Entry, to:StoreForSearch.Entry) -> Bool {
        var result = false
        if 0 < remove(entry: from) {
            add(entry: to)
            result = true
        }
        return result
    }
    
    func remove(entry:Entry, save:Bool = true) -> Int {
        let context = AppDelegate.instance.persistentContainer.viewContext
        
        if let description = NSEntityDescription.entity(forEntityName: StoreForSearch.EntityName, in: context) {
            
            let request         = NSFetchRequest<NSFetchRequestResult>()
            
            request.entity      = description
            
            request.predicate   = NSPredicate(format:"(title == %@) AND (created == %@)", entry.title, entry.created)
            
            var deleted         = context.deletedObjects.count
            
            if let result       = try? context.fetch(request) {
                
                for object in result {
                    if let object = object as? NSManagedObject {
                        context.delete(object)
                    }
                }
            }
            
            deleted = context.deletedObjects.count - deleted
            
            if save && 0 < deleted {
                synchronize()
            }
            
            return deleted
        }
        
        return 0
    }
    
    func removeTooMany() -> [StoreForSearch.Entry] {
        var result:[StoreForSearch.Entry] = []
        var entries = getAllEntries()
        let maximum = AppDelegate.instance.preferences.enableHistory.value ? AppDelegate.instance.preferences.maximumHistory.value : 0
        var count = entries.count - maximum
        while 0 < count {
            if let last = entries.last {
                _ = self.remove(entry:last, save:false)
                result.append(last)
                entries.removeLast()
            }
            count -= 1
        }
        return result
    }
    
    func removeAll(save:Bool = true) {
        let context = AppDelegate.instance.persistentContainer.viewContext
        
        if let description = NSEntityDescription.entity(forEntityName: StoreForSearch.EntityName, in: context) {
            
            let request         = NSFetchRequest<NSFetchRequestResult>()
            
            request.entity      = description
            
            request.predicate   = nil
            
            var deleted         = context.deletedObjects.count
            
            if let result       = try? context.fetch(request) {
                
                for object in result {
                    if let object = object as? NSManagedObject {
                        context.delete(object)
                    }
                }
            }
            
            deleted = context.deletedObjects.count - deleted
            
            if save && 0 < deleted {
                synchronize()
            }
        }
    }
    
    func synchronize() {
        let context = AppDelegate.instance.persistentContainer.viewContext
        do {
            try context.save()
        }
        catch let error {
            print(error)
        }
    }
    
    enum SortType {
        case byCreationDateAscending
        case byCreationDateDescending
        case byAlphabeticallyAscending
        case byAlphabeticallyDescending
    }
    
    func getAllEntries(sorted:SortType = .byCreationDateDescending) -> [Entry] {
        
        var results             : [Entry] = []
        
        let context             = AppDelegate.instance.persistentContainer.viewContext
        
        let request             = NSFetchRequest<NSFetchRequestResult>()
        
        let description         = NSEntityDescription.entity(forEntityName: StoreForSearch.EntityName, in: context)
        
        request.entity          = description
        
        do {
            let result          = try context.fetch(request)
            //                    print(result)
            
            var item            = Entry(title:"")
            
            for object in result {
                let object      = object as AnyObject
                
                item.title      = object.value(forKey:"title") as? String ?? ""
                item.created    = object.value(forKey:"created") as? String ?? ""
                
                results.append(item)
            }
            
        } catch let error {
            print(error)
        }
        
        switch sorted {
        case .byCreationDateAscending       : return results.sorted { $0.created < $1.created }
        case .byCreationDateDescending      : return results.sorted { $1.created < $0.created }
        case .byAlphabeticallyAscending     : return results.sorted { $0.title < $1.title }
        case .byAlphabeticallyDescending    : return results.sorted { $1.title < $0.title }
        }
    }
    
}
