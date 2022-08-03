//
//  Category.swift
//  Todoey-iOS15
//
//  Created by Elahe  Sharifi on 04/08/2022.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()  //explanation is the same as Array<int>()
}
