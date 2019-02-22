//
//  DataController.swift
//  Mooskine
//
//  Created by Marcos Vinicius Goncalves Contente on 13/02/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
       persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.autoSaveViewContext(interval: 3)
            completion?()
        }
    }
}

extension DataController {
    func autoSaveViewContext(interval: TimeInterval = 30) {
        print("Auto Saving")
        guard interval > 0 else {
            print("Cannot set negative save time interval")
            return
        }
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }
    
    
}
