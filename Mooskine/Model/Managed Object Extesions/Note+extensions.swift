//
//  Note+extensions.swift
//  Mooskine
//
//  Created by Marcos Vinicius Goncalves Contente on 21/02/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import CoreData

extension Note {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
