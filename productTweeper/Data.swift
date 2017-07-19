//
//  Data.swift
//  productTweeper
//
//  Created by andrzej semeniuk on 7/18/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import CoreData

class Data {
    
    struct ModelForSearchEntry {
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

    static func search(add entry:ModelForSearchEntry) {
        do {
            let context = AppDelegate.instance.persistentContainer.viewContext
            
            if let description = NSEntityDescription.entity(forEntityName: "SearchEntry", in: context) {
            
                let item = NSManagedObject.init(entity: description, insertInto: context)
                
                item.setValue(entry.title,      forKey: "title")
                item.setValue(entry.created,    forKey: "created")
                
                try item.managedObjectContext?.save()
            }
        }
        catch let error {
            print(error)
        }
    }
    
    static func search(remove entry:ModelForSearchEntry, save:Bool = true) -> Int {
        let context = AppDelegate.instance.persistentContainer.viewContext
        
        if let description = NSEntityDescription.entity(forEntityName: "SearchEntry", in: context) {
            
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
                do {
                    try context.save()
                }
                catch let error {
                    print(error)
                }
            }
            
            return deleted
        }
        
        return 0
    }
    
    static func searchGetAllEntries() -> [ModelForSearchEntry] {
        
        var results             : [ModelForSearchEntry] = []
        
        let context             = AppDelegate.instance.persistentContainer.viewContext
        
        let request             = NSFetchRequest<NSFetchRequestResult>()
        
        let description         = NSEntityDescription.entity(forEntityName: "SearchEntry", in: context)
        
        request.entity          = description
        
//        request.predicate       = NSPredicate() //format:"%K = %@", "category", category)
        
        do {
            let result          = try context.fetch(request)
            //                    print(result)
            
            var item            = ModelForSearchEntry(title:"")
            
            for object in result {
                let object      = object as AnyObject
                
                item.title      = object.value(forKey:"title") as? String ?? ""
                item.created    = object.value(forKey:"created") as? String ?? ""
                
                results.append(item)
            }
            
        } catch let error {
            print(error)
        }

        return results.sorted {
            return $1.created < $0.created
        }
    }
    
}
