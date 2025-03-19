//
//  Migrator.swift
//  Flexiconvert_iOS
//
//  Created by Carlos Mendez on 3/18/25.
//

import Foundation
import RealmSwift

class Migrator{
    init() {
        updateSchema()
    }

    func updateSchema(){
        let config = Realm.Configuration(schemaVersion: 2){ migration, oldSchemaVersion in
        }

        Realm.Configuration.defaultConfiguration = config
            let _ = try! Realm()
    }
}
