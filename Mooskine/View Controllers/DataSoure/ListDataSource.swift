//
//  ListDataSource.swift
//  Mooskine
//
//  Created by Marcos Vinicius Goncalves Contente on 22/02/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import CoreData

class ListDataSource<EntityType: NSManagedObject, CellType: UITableViewCell>: NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate  {
    // MARK: - Properties
    var tableView: UITableView!
    var managedObjectContext: NSManagedObjectContext!
    var fetchRequest: NSFetchRequest<EntityType>!
    var fetchedResultsController: NSFetchedResultsController<EntityType>!
    var cacheName: String!
    var configure: ((CellType, EntityType) -> Void)!
    var selectedObject: EntityType? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        return fetchedResultsController.object(at: indexPath)
    }
    
    // MARK: - Initializer
    
    init(tableView: UITableView, managedObjectContext: NSManagedObjectContext, fetchRequest: NSFetchRequest<EntityType>, cacheName: String = "", configure: @escaping (CellType, EntityType) -> Void) {
        super.init()
        self.tableView = tableView
        self.managedObjectContext = managedObjectContext
        self.fetchRequest = fetchRequest
        self.cacheName = cacheName
        self.configure = configure
        tableView.dataSource = self
        
        fetchedResultsController = NSFetchedResultsController<EntityType>(fetchRequest: fetchRequest,
                                                                          managedObjectContext:managedObjectContext,
                                                                          sectionNameKeyPath: nil,
                                                                          cacheName: cacheName)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    /// Deletes the notebook at the specified index path
    func deleteEntity(at indexPath: IndexPath) {
        let entityToDelete = fetchedResultsController.object(at: indexPath)
        managedObjectContext.delete(entityToDelete)
        try? managedObjectContext.save()
    }
    
    // MARK: - TableViewControllerDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entity = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: CellType.defaultReuseIdentifier, for: indexPath) as! CellType
        configure(cell, entity)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deleteEntity(at: indexPath)
        default: () // Unsupported
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            break
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
            break
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
            break
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .fade)
        case .delete:
            tableView.deleteSections(indexSet, with: .fade)
        case .move, .update:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
}
