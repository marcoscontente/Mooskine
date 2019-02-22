//
//  ListDataSource.swift
//  Mooskine
//
//  Created by Marcos Vinicius Goncalves Contente on 22/02/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import CoreData

class ListDataSource<ObjectType: NSManagedObject, CellType: UITableViewCell>: NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate  {
    
    init(tableView: UITableView, managedObjectContext: NSManagedObjectContext, fetchRequest: NSFetchRequest<EntityType>, configure: @escaping (CellType, EntityType) -> Void) {
        //
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
