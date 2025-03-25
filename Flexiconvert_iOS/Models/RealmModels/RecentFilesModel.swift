//
//  RecentFilesModel.swift
//  Flexiconvert_iOS
//
//  Created by Carlos Mendez on 3/18/25.
//

import Foundation
import UIKit
import RealmSwift

class RecentFilesRealmModel: Object, Identifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var format: String
    @Persisted var file_name: String
    @Persisted var date: String
    @Persisted var image: Data
//    @Persisted var image: String = ""
}
