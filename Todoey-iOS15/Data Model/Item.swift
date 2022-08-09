//
//  Item.swift
//  Todoey-iOS15
//
//  Created by Elahe  Sharifi on 04/08/2022.
//

import Foundation
import RealmSwift

class Item: Object{
    // when you want to add variable in RealmSwift you should use @objc dynamic
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property:"items")
}
